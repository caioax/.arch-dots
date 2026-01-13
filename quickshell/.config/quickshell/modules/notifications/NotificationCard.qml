pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import qs.config
import qs.services

Item {
    id: root

    // ========================================================================
    // PROPRIEDADES
    // ========================================================================

    // O wrapper da notificação (do NotificationService)
    required property var wrapper

    // Modo popup (true) ou histórico (false)
    property bool popupMode: false

    // Estado interno para animação de saída
    property bool isExiting: false
    property bool isCollapsed: false

    // ========================================================================
    // PROPRIEDADES DERIVADAS DO WRAPPER
    // ========================================================================

    readonly property int notifId: wrapper ? wrapper.notifId : -1
    readonly property string summary: wrapper ? wrapper.summary : ""
    readonly property string body: wrapper ? wrapper.body : ""
    readonly property string appName: wrapper ? wrapper.appName : "Sistema"
    readonly property string appIcon: wrapper ? wrapper.appIcon : ""
    readonly property string image: wrapper ? wrapper.image : ""
    readonly property int urgency: wrapper ? wrapper.urgency : 0
    readonly property bool isUrgent: wrapper ? wrapper.isUrgent : false
    readonly property var actions: wrapper ? wrapper.actions : []
    readonly property bool hasActions: wrapper ? wrapper.hasActions : false
    readonly property bool showPopup: wrapper ? wrapper.popup : false
    readonly property string timeStr: wrapper ? wrapper.timeStr : ""

    // Filtra ações que não devem ser mostradas como botões
    // "default" e "activate" são ações especiais que geralmente não têm label útil
    readonly property var visibleActions: {
        if (!actions || actions.length === 0)
            return [];

        let filtered = [];
        for (let i = 0; i < actions.length; i++) {
            const action = actions[i];
            if (!action)
                continue;

            const identifier = (action.identifier || "").toLowerCase();
            const text = action.text || "";

            // Pula ações sem texto útil ou com identificadores especiais sem texto
            if (identifier === "default" && text === "")
                continue;
            if (identifier === "activate" && text === "")
                continue;

            // Pula se o texto é igual ao identificador (comum em ações mal formatadas)
            if (text.toLowerCase() === identifier && (identifier === "default" || identifier === "activate"))
                continue;

            // Se tem texto, mostra
            if (text !== "") {
                filtered.push(action);
            }
        }
        return filtered;
    }

    readonly property bool hasVisibleActions: visibleActions && visibleActions.length > 0

    // Obtém o label da ação (usa text, ou fallback para identifier formatado)
    function getActionLabel(action) {
        if (!action)
            return "";

        const text = action.text || "";
        if (text !== "")
            return text;

        // Fallback: formata o identifier
        const id = action.identifier || "";
        if (id === "")
            return "Abrir";

        // Capitaliza primeira letra
        return id.charAt(0).toUpperCase() + id.slice(1);
    }

    // ========================================================================
    // DIMENSÕES
    // ========================================================================

    readonly property int visualHeight: contentColumn.implicitHeight + 24
    implicitWidth: Config.notifWidth

    implicitHeight: {
        if (isCollapsed)
            return 0;
        if (popupMode && !showPopup)
            return 0;
        if (!wrapper)
            return 0;
        return visualHeight + Config.notifSpacing;
    }

    visible: !isCollapsed && (popupMode ? showPopup : true) && opacity > 0 && wrapper !== null

    // ========================================================================
    // PROGRESSO DO TIMER (para barra de progresso)
    // ========================================================================

    property real timeProgress: 0.0

    // Verifica se o timer do wrapper está rodando
    readonly property bool timerRunning: wrapper && wrapper.timer && wrapper.timer.running
    readonly property int timerInterval: wrapper && wrapper.timer ? wrapper.timer.interval : Config.notifTimeout

    // Verifica se está pausado (hover)
    readonly property bool isPaused: wrapper && wrapper.isPaused

    // Animação de progresso
    NumberAnimation on timeProgress {
        id: progressAnim
        from: 0.0
        to: 1.0
        duration: root.timerInterval
        running: root.popupMode && root.showPopup && !root.isExiting && root.wrapper !== null && root.timerRunning
        // Só pausa se a animação estiver realmente rodando
        paused: running && root.isPaused
        onFinished: root.startExitAnimation(false)
    }

    // Reseta o progresso quando o timer reinicia
    Connections {
        target: wrapper ? wrapper.timer : null
        function onRunningChanged() {
            if (wrapper && wrapper.timer && wrapper.timer.running) {
                root.timeProgress = 0;
                progressAnim.restart();
            }
        }
    }

    // ========================================================================
    // VISUAL
    // ========================================================================

    // Container com clipping
    Item {
        id: clippedContainer
        width: parent.width
        height: root.visualHeight
        visible: root.wrapper !== null

        // Máscara para borda arredondada
        Rectangle {
            id: maskRect
            anchors.fill: parent
            radius: Config.radiusLarge
            visible: false
        }

        layer.enabled: true
        layer.samples: 4
        layer.effect: OpacityMask {
            maskSource: maskRect
        }

        // Fundo
        Rectangle {
            anchors.fill: parent
            color: Config.surface0Color
        }

        // Barra de progresso (só no modo popup quando não pausado)
        Rectangle {
            visible: root.popupMode && !(wrapper && wrapper.isPaused)
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            height: 3
            width: parent.width * (1.0 - root.timeProgress)
            color: root.isUrgent ? Config.errorColor : Config.accentColor
        }

        // Conteúdo
        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            // Linha principal: Ícone + Texto
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                // Ícone / Imagem
                Rectangle {
                    Layout.preferredWidth: 42
                    Layout.preferredHeight: 42
                    Layout.alignment: Qt.AlignTop
                    radius: width / 2
                    color: root.isUrgent ? Qt.alpha(Config.errorColor, 0.2) : Config.surface1Color

                    Image {
                        id: notifImage
                        anchors.fill: parent
                        anchors.margins: root.image !== "" ? 0 : 8
                        fillMode: Image.PreserveAspectCrop

                        mipmap: true
                        antialiasing: true
                        smooth: true
                        sourceSize: Qt.size(128, 128)

                        source: NotificationService.getIconSource(root.appIcon, root.image)

                        onStatusChanged: {
                            if (status === Image.Error && source !== "") {
                                source = "image://icon/dialog-information";
                            }
                        }

                        // Máscara circular para a imagem
                        layer.enabled: root.image !== ""
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                width: notifImage.width
                                height: notifImage.height
                                radius: width / 2
                                visible: false
                            }
                        }
                    }

                    // Ícone de fallback se não tiver imagem
                    Text {
                        visible: notifImage.status === Image.Error || (notifImage.source + "") === ""
                        anchors.centerIn: parent
                        text: "󰍡"
                        font.family: Config.font
                        font.pixelSize: 20
                        color: Config.subtextColor
                    }
                }

                // Textos
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    // Header: Título + Nome do App + Tempo
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 5

                        Text {
                            text: root.summary
                            color: Config.textColor
                            font.family: Config.font
                            font.pixelSize: Config.fontSizeNormal
                            font.bold: true
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                            textFormat: Text.StyledText
                        }

                        Text {
                            text: root.appName
                            color: root.isUrgent ? Config.errorColor : Config.accentColor
                            font.family: Config.font
                            font.pixelSize: 10
                            font.bold: true
                            opacity: 0.8
                        }
                    }

                    // Tempo (só no histórico)
                    Text {
                        visible: !root.popupMode && root.timeStr !== ""
                        text: root.timeStr
                        color: Config.subtextColor
                        font.family: Config.font
                        font.pixelSize: 10
                        opacity: 0.7
                    }

                    // Corpo da notificação
                    Text {
                        text: root.body
                        color: Config.subtextColor
                        font.family: Config.font
                        font.pixelSize: Config.fontSizeSmall
                        wrapMode: Text.Wrap
                        maximumLineCount: 3
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        visible: text !== ""
                        textFormat: Text.StyledText
                        onLinkActivated: link => Qt.openUrlExternally(link)
                    }
                }
            }

            // --- AINDA NÃO IMPLEMENTADO POR COMPLETO, PARA TENTAR FAZER DEPOIS ---
            // // Botões de Ação
            // RowLayout {
            //     id: actionRow
            //     visible: root.hasVisibleActions
            //     Layout.fillWidth: true
            //     spacing: 8
            //
            //     Repeater {
            //         model: root.visibleActions
            //
            //         delegate: Rectangle {
            //             id: actionDelegate
            //
            //             required property var modelData
            //             required property int index
            //
            //             Layout.fillWidth: true
            //             Layout.preferredHeight: 30
            //             radius: Config.radiusSmall
            //             color: actionMouse.containsMouse ? Config.surface2Color : Config.surface1Color
            //
            //             Behavior on color {
            //                 ColorAnimation {
            //                     duration: Config.animDurationShort
            //                 }
            //             }
            //
            //             Text {
            //                 anchors.centerIn: parent
            //                 text: root.getActionLabel(actionDelegate.modelData)
            //                 font.family: Config.font
            //                 font.pixelSize: Config.fontSizeSmall
            //                 color: Config.textColor
            //                 elide: Text.ElideRight
            //             }
            //
            //             MouseArea {
            //                 id: actionMouse
            //                 anchors.fill: parent
            //                 hoverEnabled: true
            //                 cursorShape: Qt.PointingHandCursor
            //                 onClicked: {
            //                     // Invoca a ação diretamente no objeto nativo
            //                     if (actionDelegate.modelData && typeof actionDelegate.modelData.invoke === "function") {
            //                         console.log("[Notif] Invocando ação:", actionDelegate.modelData.identifier || actionDelegate.modelData.text);
            //                         actionDelegate.modelData.invoke();
            //                     }
            //
            //                     // Se não for resident, fecha após invocar
            //                     if (root.wrapper && root.wrapper.notification && !root.wrapper.notification.resident) {
            //                         root.startExitAnimation(true);
            //                     }
            //                 }
            //             }
            //         }
            //     }
            // }
        }
    }

    // Borda externa (hover state)
    Rectangle {
        width: parent.width
        height: root.visualHeight
        radius: Config.radiusLarge
        color: "transparent"
        border.width: 1
        border.color: {
            if (root.isUrgent)
                return Config.errorColor;
            if (mouseArea.containsMouse)
                return Config.surface2Color;
            return "transparent";
        }
    }

    // MouseArea principal
    MouseArea {
        id: mouseArea
        width: parent.width
        height: root.visualHeight
        hoverEnabled: true
        acceptedButtons: Qt.RightButton | Qt.LeftButton

        onEntered: NotificationService.setHovered(root.notifId)
        onExited: NotificationService.clearHovered()

        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) {
                // Clique direito: remove completamente
                root.startExitAnimation(true);
            } else {
                // Clique esquerdo no modo popup: apenas esconde
                if (root.popupMode) {
                    root.startExitAnimation(false);
                }
            }
        }
    }

    // ========================================================================
    // ANIMAÇÃO DE SAÍDA
    // ========================================================================

    function startExitAnimation(removeCompletely) {
        if (isExiting)
            return;
        isExiting = true;
        exitAnim.removeCompletely = removeCompletely;
        exitAnim.start();
    }

    SequentialAnimation {
        id: exitAnim
        property bool removeCompletely: false

        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "opacity"
                to: 0
                duration: Config.animDuration
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: root
                property: "x"
                to: 50
                duration: Config.animDuration
                easing.type: Easing.InQuad
            }
        }

        ScriptAction {
            script: root.isCollapsed = true
        }

        PauseAnimation {
            duration: Config.animDuration
        }

        ScriptAction {
            script: {
                const id = root.notifId;

                if (exitAnim.removeCompletely) {
                    NotificationService.removeNotification(id);
                } else {
                    NotificationService.expireNotification(id);
                }

                // Reset do estado visual
                root.opacity = 1;
                root.x = 0;
                root.isCollapsed = false;
                root.isExiting = false;
            }
        }
    }
}

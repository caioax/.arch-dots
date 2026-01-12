pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import qs.config
import qs.services

Item {
    id: root

    // --- PROPRIEDADES ---
    required property string notifId
    required property string summary
    required property string body
    required property string appName
    required property string appIcon
    required property string image
    required property int urgency
    required property var index

    // --- DIMENSÕES ---
    width: Config.notifWidth

    // A altura da ROOT deve ser igual à altura do Fundo + Sombra.
    implicitHeight: backgroundRect.height + 10

    // --- LÓGICA DE TEMPO ---
    property real timeProgress: 0.0
    readonly property bool isPaused: NotificationService.hoveredNotificationId === root.notifId

    NumberAnimation on timeProgress {
        id: progressAnim
        from: 0.0
        to: 1.0
        duration: Config.notifTimeout
        running: true
        paused: root.isPaused && running
        onFinished: {
            if (!root.isPaused)
                closeAnim.start();
        }
    }

    // --- BASE DO CARD ---
    Rectangle {
        id: backgroundRect
        width: parent.width

        // Altura dinâmica: Conteúdo + Padding (12 em cima + 12 em baixo = 24)
        // Isso garante que o fundo sempre abrace todo o texto.
        height: contentItem.implicitHeight + 24

        radius: Config.radiusLarge
        color: Config.surface0Color

        border.width: 1
        border.color: {
            if (root.urgency === 2)
                return Config.errorColor;
            if (mouseArea.containsMouse)
                return Config.surface2Color;
            return "transparent";
        }

        // Sombra/Hover
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: Config.surface1Color
            opacity: mouseArea.containsMouse ? 0.4 : 0.0
            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                }
            }
        }
    }

    // --- CONTEÚDO RECORTADO ---
    Item {
        id: clippedContent
        anchors.fill: backgroundRect
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: backgroundRect
        }

        // BARRA DE PROGRESSO
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            height: 4
            width: parent.width * (1.0 - root.timeProgress)
            color: root.urgency === 2 ? Config.errorColor : Config.accentColor
            visible: !root.isPaused
        }

        // LAYOUT PRINCIPAL
        RowLayout {
            id: contentItem

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 12

            spacing: 12

            // ÍCONE
            Rectangle {
                Layout.preferredWidth: 42
                Layout.preferredHeight: 42
                Layout.alignment: Qt.AlignTop
                radius: width / 2
                color: root.urgency === 2 ? Qt.alpha(Config.errorColor, 0.2) : Config.surface1Color

                Image {
                    anchors.fill: parent
                    anchors.margins: 8
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    smooth: true
                    sourceSize: Qt.size(128, 128)
                    source: {
                        if (root.image !== "")
                            return root.image;
                        if (root.appIcon !== "")
                            return "image://icon/" + root.appIcon;
                        return "image://icon/dialog-information";
                    }
                    onStatusChanged: if (status === Image.Error)
                        source = "image://icon/dialog-information"
                }
            }

            // TEXTOS
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

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
                    }
                    Text {
                        text: root.appName
                        color: root.urgency === 2 ? Config.errorColor : Config.accentColor
                        font.family: Config.font
                        font.pixelSize: 10
                        font.bold: true
                        opacity: 0.8
                    }
                }

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
                }
            }

            // Botão Fechar
            Text {
                Layout.alignment: Qt.AlignTop
                text: ""
                font.family: Config.font
                font.pixelSize: Config.fontSizeNormal
                color: closeMouse.containsMouse ? Config.errorColor : Config.surface2Color
                MouseArea {
                    id: closeMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: closeAnim.start()
                }
            }
        }
    }

    // --- INTERAÇÃO ---
    MouseArea {
        id: mouseArea
        anchors.fill: backgroundRect
        hoverEnabled: true
        acceptedButtons: Qt.RightButton
        onEntered: NotificationService.setHovered(root.notifId)
        onExited: NotificationService.clearHovered()
        onClicked: closeAnim.start()
    }

    // --- ANIMAÇÕES ---
    Component.onCompleted: {
        root.x = 50;
        root.opacity = 0;
        entryAnim.start();
    }
    ParallelAnimation {
        id: entryAnim
        NumberAnimation {
            target: root
            property: "x"
            to: 0
            duration: Config.animDurationLong
            easing.type: Easing.OutExpo
        }
        NumberAnimation {
            target: root
            property: "opacity"
            to: 1.0
            duration: Config.animDuration
        }
    }
    SequentialAnimation {
        id: closeAnim
        running: false
        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "x"
                to: 50
                duration: Config.animDuration
                easing.type: Easing.InQuad
            }
            NumberAnimation {
                target: root
                property: "opacity"
                to: 0
                duration: Config.animDuration
            }
        }
        ScriptAction {
            script: NotificationService.closeNotification(root.index)
        }
    }
}

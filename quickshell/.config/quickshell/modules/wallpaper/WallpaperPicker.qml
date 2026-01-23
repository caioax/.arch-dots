pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.services
import qs.config

PanelWindow {
    id: root

    visible: WallpaperService.pickerVisible

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    WlrLayershell.namespace: "qs_wallpaper"

    color: "transparent"

    // Clique no fundo fecha ou limpa seleção
    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (WallpaperService.selectedCount > 0) {
                WallpaperService.clearSelection();
            } else {
                WallpaperService.hide();
            }
        }
    }

    // Conteúdo principal
    Rectangle {
        id: content
        anchors.centerIn: parent
        width: Math.min(900, root.width - 100)
        height: Math.min(650, root.height - 100)
        radius: Config.radiusLarge
        color: Config.backgroundColor
        border.color: Qt.alpha(Config.accentColor, 0.2)
        border.width: 1

        // Animação de entrada
        scale: WallpaperService.pickerVisible ? 1 : 0.9
        opacity: WallpaperService.pickerVisible ? 1 : 0

        Behavior on scale {
            NumberAnimation {
                duration: Config.animDuration
                easing.type: Easing.OutBack
                easing.overshoot: 1.1
            }
        }

        Behavior on opacity {
            NumberAnimation { duration: Config.animDuration }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Config.spacing + 8
            spacing: Config.spacing

            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: Config.spacing

                Text {
                    text: "󰸉"
                    font.family: Config.font
                    font.pixelSize: Config.fontSizeIcon
                    color: Config.accentColor
                }

                Text {
                    text: "Wallpapers"
                    font.family: Config.font
                    font.pixelSize: Config.fontSizeLarge
                    font.weight: Font.DemiBold
                    color: Config.textColor
                }

                Item { Layout.fillWidth: true }

                // Contador
                Rectangle {
                    Layout.preferredWidth: countText.implicitWidth + 16
                    Layout.preferredHeight: 26
                    radius: height / 2
                    color: Config.surface1Color

                    Text {
                        id: countText
                        anchors.centerIn: parent
                        text: WallpaperService.wallpapers.length + " imagens"
                        font.family: Config.font
                        font.pixelSize: Config.fontSizeSmall
                        color: Config.subtextColor
                    }
                }

                // Botão adicionar
                Rectangle {
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36
                    radius: Config.radius
                    color: addMouse.containsMouse ? Config.surface2Color : Config.surface1Color

                    Behavior on color {
                        ColorAnimation { duration: Config.animDurationShort }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "󰐕"
                        font.family: Config.font
                        font.pixelSize: Config.fontSizeIcon
                        color: Config.successColor
                    }

                    MouseArea {
                        id: addMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: WallpaperService.addWallpapers()
                    }

                    ToolTip {
                        visible: addMouse.containsMouse
                        text: "Adicionar wallpapers"
                        delay: 500
                    }
                }

                // Botão random
                Rectangle {
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36
                    radius: Config.radius
                    color: randomMouse.containsMouse ? Config.surface2Color : Config.surface1Color

                    Behavior on color {
                        ColorAnimation { duration: Config.animDurationShort }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "󰒝"
                        font.family: Config.font
                        font.pixelSize: Config.fontSizeIcon
                        color: Config.accentColor
                    }

                    MouseArea {
                        id: randomMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: WallpaperService.setRandomWallpaper()
                    }

                    ToolTip {
                        visible: randomMouse.containsMouse
                        text: "Wallpaper aleatório"
                        delay: 500
                    }
                }

                // Botão fechar
                Rectangle {
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36
                    radius: Config.radius
                    color: closeMouse.containsMouse ? Config.errorColor : Config.surface1Color

                    Behavior on color {
                        ColorAnimation { duration: Config.animDurationShort }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "󰅖"
                        font.family: Config.font
                        font.pixelSize: Config.fontSizeNormal
                        color: closeMouse.containsMouse ? Config.textColor : Config.subtextColor
                    }

                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: WallpaperService.hide()
                    }
                }
            }

            // Separador
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Config.surface1Color
            }

            // Grid de wallpapers
            GridView {
                id: wallpaperGrid
                Layout.fillWidth: true
                Layout.fillHeight: true

                clip: true
                cellWidth: 200
                cellHeight: 130

                model: WallpaperService.wallpapers

                delegate: Item {
                    id: wallpaperItem
                    required property int index
                    required property string modelData

                    width: wallpaperGrid.cellWidth
                    height: wallpaperGrid.cellHeight

                    property bool isHovered: itemMouse.containsMouse
                    property bool isCurrent: modelData === WallpaperService.currentWallpaper
                    property bool isSelected: WallpaperService.isSelected(modelData)

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 6
                        radius: Config.radius
                        color: Config.surface0Color
                        border.width: wallpaperItem.isSelected ? 2 : (wallpaperItem.isCurrent ? 2 : (wallpaperItem.isHovered ? 1 : 0))
                        border.color: wallpaperItem.isSelected ? Config.successColor : (wallpaperItem.isCurrent ? Config.accentColor : Config.surface2Color)

                        Behavior on border.width {
                            NumberAnimation { duration: Config.animDurationShort }
                        }

                        Behavior on border.color {
                            ColorAnimation { duration: Config.animDurationShort }
                        }

                        // Thumbnail com clip arredondado
                        Item {
                            anchors.fill: parent
                            anchors.margins: 4

                            Rectangle {
                                anchors.fill: parent
                                radius: Config.radiusSmall
                                clip: true

                                Image {
                                    id: thumbnail
                                    anchors.fill: parent
                                    source: "file://" + wallpaperItem.modelData
                                    sourceSize: Qt.size(256, 144)
                                    fillMode: Image.PreserveAspectCrop
                                    asynchronous: true
                                    cache: true
                                }
                            }
                        }

                        // Overlay de loading
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 4
                            radius: Config.radiusSmall
                            color: Config.surface1Color
                            visible: thumbnail.status === Image.Loading

                            Text {
                                anchors.centerIn: parent
                                text: "󰑓"
                                font.family: Config.font
                                font.pixelSize: Config.fontSizeIcon
                                color: Config.mutedColor

                                RotationAnimator on rotation {
                                    from: 0; to: 360
                                    duration: 1000
                                    loops: Animation.Infinite
                                    running: thumbnail.status === Image.Loading
                                }
                            }
                        }

                        // Overlay de seleção
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 4
                            radius: Config.radiusSmall
                            color: Qt.alpha(Config.successColor, 0.2)
                            visible: wallpaperItem.isSelected
                        }

                        // Badge de wallpaper atual
                        Rectangle {
                            visible: wallpaperItem.isCurrent
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.margins: 8
                            width: 24
                            height: 24
                            radius: height / 2
                            color: Config.accentColor

                            Text {
                                anchors.centerIn: parent
                                text: "󰄬"
                                font.family: Config.font
                                font.pixelSize: 12
                                color: Config.textReverseColor
                            }
                        }

                        // Badge de selecionado
                        Rectangle {
                            visible: wallpaperItem.isSelected
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.margins: 8
                            width: 24
                            height: 24
                            radius: height / 2
                            color: Config.successColor

                            Text {
                                anchors.centerIn: parent
                                text: "󰄬"
                                font.family: Config.font
                                font.pixelSize: 12
                                color: Config.textReverseColor
                            }
                        }

                        // Efeito de escala no hover
                        scale: wallpaperItem.isHovered ? 1.02 : 1

                        Behavior on scale {
                            NumberAnimation {
                                duration: Config.animDurationShort
                                easing.type: Easing.OutCubic
                            }
                        }

                        MouseArea {
                            id: itemMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.LeftButton

                            onClicked: mouse => {
                                if (mouse.modifiers & Qt.ControlModifier) {
                                    // Ctrl+Click: adiciona/remove da seleção
                                    WallpaperService.toggleSelection(wallpaperItem.modelData);
                                } else {
                                    // Click normal: seleciona apenas este
                                    WallpaperService.selectOnly(wallpaperItem.modelData);
                                }
                            }

                            onDoubleClicked: {
                                // Duplo clique: aplica wallpaper
                                WallpaperService.setWallpaper(wallpaperItem.modelData);
                            }
                        }
                    }
                }

                // Estado vazio
                Column {
                    anchors.centerIn: parent
                    spacing: Config.spacing
                    visible: wallpaperGrid.count === 0

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "󰸉"
                        font.family: Config.font
                        font.pixelSize: 48
                        color: Config.mutedColor
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Nenhum wallpaper encontrado"
                        font.family: Config.font
                        font.pixelSize: Config.fontSizeNormal
                        color: Config.subtextColor
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Adicione imagens em ~/.local/wallpapers"
                        font.family: Config.font
                        font.pixelSize: Config.fontSizeSmall
                        color: Config.mutedColor
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded

                    contentItem: Rectangle {
                        implicitWidth: 4
                        radius: 2
                        color: Config.surface2Color
                        opacity: parent.active ? 1 : 0

                        Behavior on opacity {
                            NumberAnimation { duration: Config.animDurationShort }
                        }
                    }
                }
            }

            // Barra de ações (aparece quando há seleção)
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: WallpaperService.selectedCount > 0 ? 50 : 0
                radius: Config.radius
                color: Config.surface0Color
                visible: Layout.preferredHeight > 0
                clip: true

                Behavior on Layout.preferredHeight {
                    NumberAnimation {
                        duration: Config.animDuration
                        easing.type: Easing.OutCubic
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Config.spacing + 4
                    anchors.rightMargin: Config.spacing + 4
                    spacing: Config.spacing

                    // Info de seleção
                    Text {
                        text: WallpaperService.selectedCount + " selecionado" + (WallpaperService.selectedCount > 1 ? "s" : "")
                        font.family: Config.font
                        font.pixelSize: Config.fontSizeNormal
                        color: Config.subtextColor
                    }

                    Item { Layout.fillWidth: true }

                    // Confirmação de delete (aparece quando necessário)
                    Row {
                        visible: WallpaperService.confirmDelete
                        spacing: Config.spacing

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Deletar " + WallpaperService.selectedCount + " wallpapers?"
                            font.family: Config.font
                            font.pixelSize: Config.fontSizeNormal
                            color: Config.warningColor
                        }

                        Rectangle {
                            width: 80
                            height: 32
                            radius: Config.radiusSmall
                            color: confirmYesMouse.containsMouse ? Config.errorColor : Config.surface1Color

                            Text {
                                anchors.centerIn: parent
                                text: "Sim"
                                font.family: Config.font
                                font.pixelSize: Config.fontSizeNormal
                                color: confirmYesMouse.containsMouse ? Config.textColor : Config.errorColor
                            }

                            MouseArea {
                                id: confirmYesMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: WallpaperService.deleteSelected()
                            }
                        }

                        Rectangle {
                            width: 80
                            height: 32
                            radius: Config.radiusSmall
                            color: confirmNoMouse.containsMouse ? Config.surface2Color : Config.surface1Color

                            Text {
                                anchors.centerIn: parent
                                text: "Não"
                                font.family: Config.font
                                font.pixelSize: Config.fontSizeNormal
                                color: Config.subtextColor
                            }

                            MouseArea {
                                id: confirmNoMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: WallpaperService.cancelDelete()
                            }
                        }
                    }

                    // Botões de ação (escondem durante confirmação)
                    Row {
                        visible: !WallpaperService.confirmDelete
                        spacing: Config.spacing

                        // Botão aplicar (só quando 1 selecionado)
                        Rectangle {
                            visible: WallpaperService.selectedCount === 1
                            width: 100
                            height: 32
                            radius: Config.radiusSmall
                            color: applyMouse.containsMouse ? Config.accentColor : Config.surface1Color

                            Behavior on color {
                                ColorAnimation { duration: Config.animDurationShort }
                            }

                            Row {
                                anchors.centerIn: parent
                                spacing: 6

                                Text {
                                    text: "󰄬"
                                    font.family: Config.font
                                    font.pixelSize: Config.fontSizeNormal
                                    color: applyMouse.containsMouse ? Config.textReverseColor : Config.accentColor
                                }

                                Text {
                                    text: "Aplicar"
                                    font.family: Config.font
                                    font.pixelSize: Config.fontSizeNormal
                                    color: applyMouse.containsMouse ? Config.textReverseColor : Config.textColor
                                }
                            }

                            MouseArea {
                                id: applyMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: WallpaperService.applySelected()
                            }
                        }

                        // Botão deletar
                        Rectangle {
                            width: 100
                            height: 32
                            radius: Config.radiusSmall
                            color: deleteMouse.containsMouse ? Config.errorColor : Config.surface1Color

                            Behavior on color {
                                ColorAnimation { duration: Config.animDurationShort }
                            }

                            Row {
                                anchors.centerIn: parent
                                spacing: 6

                                Text {
                                    text: "󰅖"
                                    font.family: Config.font
                                    font.pixelSize: Config.fontSizeNormal
                                    color: deleteMouse.containsMouse ? Config.textColor : Config.errorColor
                                }

                                Text {
                                    text: "Deletar"
                                    font.family: Config.font
                                    font.pixelSize: Config.fontSizeNormal
                                    color: deleteMouse.containsMouse ? Config.textColor : Config.textColor
                                }
                            }

                            MouseArea {
                                id: deleteMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: WallpaperService.requestDelete()
                            }
                        }

                        // Botão limpar seleção
                        Rectangle {
                            width: 32
                            height: 32
                            radius: Config.radiusSmall
                            color: clearMouse.containsMouse ? Config.surface2Color : Config.surface1Color

                            Text {
                                anchors.centerIn: parent
                                text: "󰜺"
                                font.family: Config.font
                                font.pixelSize: Config.fontSizeNormal
                                color: Config.subtextColor
                            }

                            MouseArea {
                                id: clearMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: WallpaperService.clearSelection()
                            }

                            ToolTip {
                                visible: clearMouse.containsMouse
                                text: "Limpar seleção"
                                delay: 500
                            }
                        }
                    }
                }
            }
        }

        // Atalhos de teclado
        Keys.onEscapePressed: {
            if (WallpaperService.confirmDelete) {
                WallpaperService.cancelDelete();
            } else if (WallpaperService.selectedCount > 0) {
                WallpaperService.clearSelection();
            } else {
                WallpaperService.hide();
            }
        }
        Keys.onDeletePressed: WallpaperService.requestDelete()
        Keys.onReturnPressed: WallpaperService.applySelected()
        Keys.onPressed: event => {
            if (event.key === Qt.Key_R) {
                WallpaperService.setRandomWallpaper();
                event.accepted = true;
            } else if (event.key === Qt.Key_A && (event.modifiers & Qt.ControlModifier)) {
                // Ctrl+A: seleciona todos
                WallpaperService.selectedWallpapers = [...WallpaperService.wallpapers];
                event.accepted = true;
            }
        }

        Component.onCompleted: forceActiveFocus()
    }

    // Focus grab
    HyprlandFocusGrab {
        windows: [root]
        active: root.visible
        onCleared: WallpaperService.hide()
    }
}

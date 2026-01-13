pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import qs.config
import qs.services

PopupWindow {
    id: root

    implicitWidth: 385
    implicitHeight: 500
    color: "transparent"

    property bool isClosing: false
    property bool isOpening: false

    function closeWindow() {
        if (!visible)
            return;
        isClosing = true;
        closeTimer.restart();
    }

    Timer {
        id: closeTimer
        interval: Config.animDuration
        onTriggered: {
            root.visible = false;
            isClosing = false;
        }
    }

    HyprlandFocusGrab {
        id: focusGrab
        windows: [root]
        active: false
        onCleared: root.closeWindow()
    }

    Timer {
        id: grabTimer
        interval: 10
        onTriggered: {
            focusGrab.active = true;
            background.forceActiveFocus();
        }
    }

    onVisibleChanged: {
        if (visible) {
            isClosing = false;
            isOpening = true;
            grabTimer.restart();
        } else {
            focusGrab.active = false;
            isOpening = false;
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: Config.backgroundColor
        radius: Config.radiusLarge
        clip: true

        transformOrigin: Item.TopRight

        property bool showState: visible && !isClosing && isOpening

        scale: showState ? 1.0 : 0.9
        opacity: showState ? 1.0 : 0.0

        Behavior on scale {
            NumberAnimation {
                duration: Config.animDurationLong
                easing.type: Easing.OutExpo
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Config.animDurationShort
            }
        }

        Keys.onEscapePressed: root.closeWindow()

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 10

            // Header
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Notificações"
                    font.family: Config.font
                    font.bold: true
                    font.pixelSize: Config.fontSizeLarge
                    color: Config.textColor
                    Layout.fillWidth: true
                }

                // Botão Limpar Tudo
                Button {
                    visible: NotificationService.count > 0

                    background: Rectangle {
                        color: parent.hovered ? Config.surface2Color : "transparent"
                        radius: 5
                    }

                    contentItem: Text {
                        text: "Limpar tudo"
                        color: parent.hovered ? Config.errorColor : Config.subtextColor
                        font.family: Config.font
                        font.pixelSize: Config.fontSizeSmall
                        padding: 5
                    }

                    onClicked: NotificationService.clearAll()
                }
            }

            // Divisor
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Config.surface1Color
            }

            // Mensagem de lista vazia
            Text {
                visible: NotificationService.count === 0
                text: "Nenhuma notificação recente"
                color: Config.subtextColor
                font.family: Config.font
                font.italic: true
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin: 50
            }

            // Lista de notificações
            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 10

                model: NotificationService.notifications

                delegate: NotificationCard {
                    required property var modelData

                    wrapper: modelData
                    popupMode: false
                }

                ScrollBar.vertical: ScrollBar {
                    active: listView.moving || listView.contentHeight > listView.height
                    policy: ScrollBar.AsNeeded
                }
            }
        }
    }
}

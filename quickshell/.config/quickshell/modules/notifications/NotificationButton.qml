pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import qs.config
import qs.services

Item {
    id: root

    implicitWidth: Config.barHeight - 10
    implicitHeight: Config.barHeight - 10

    // Janela Popup
    NotificationWindow {
        id: notifWindow

        anchor.item: root
        anchor.edges: Edges.Bottom | Edges.Right
        anchor.gravity: Edges.Bottom | Edges.Left
        anchor.rect: Qt.rect(0, 0, root.width, root.height + 10)

        visible: false
    }

    // Botão Visual
    Rectangle {
        anchors.fill: parent
        radius: height / 2

        color: {
            if (notifWindow.visible || mouseArea.containsMouse)
                return Config.surface2Color;

            return "transparent";
        }

        Behavior on color {
            ColorAnimation {
                duration: Config.animDurationShort
            }
        }

        // Ícone (Sino)
        Text {
            anchors.centerIn: parent
            text: NotificationService.count > 0 ? "󰂚" : "󰂜"
            font.family: Config.font
            font.pixelSize: Config.fontSizeLarge
            color: notifWindow.visible ? Config.accentColor : Config.textColor
        }

        // Badge de contagem
        Rectangle {
            visible: NotificationService.count > 0
            width: 8
            height: 8
            radius: 4
            color: Config.errorColor
            border.width: 1
            border.color: Config.backgroundColor

            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 2
            anchors.rightMargin: 2
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: notifWindow.visible = !notifWindow.visible
        }
    }
}

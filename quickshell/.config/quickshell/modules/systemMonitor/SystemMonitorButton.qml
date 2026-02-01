pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services
import "../../components/"

BarButton {
    id: root

    active: monitorWindow.visible
    contentItem: buttonContent
    onClicked: monitorWindow.visible = !monitorWindow.visible

    RowLayout {
        id: buttonContent
        anchors.centerIn: parent
        spacing: Config.spacing

        Text {
            text: "󰍛"
            font.family: Config.font
            font.pixelSize: Config.fontSizeLarge
            color: root.active ? Config.accentColor : Config.textColor

            Behavior on color {
                ColorAnimation { duration: Config.animDuration }
            }
        }
    }

    SystemMonitorWindow {
        id: monitorWindow
        visible: false
    }
}

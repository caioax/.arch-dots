pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.config
import "../../components/"

BarButton {
    id: root

    active: quickSettingsWindow.visible
    contentItem: iconsLayout
    onClicked: quickSettingsWindow.visible = !quickSettingsWindow.visible

    RowLayout {
        id: iconsLayout
        anchors.centerIn: parent
        spacing: Config.spacing

        property color iconColor: root.active ? Config.accentColor : Config.textColor

        Behavior on iconColor {
            ColorAnimation {
                duration: Config.animDuration
            }
        }

        WifiIcon {
            color: iconsLayout.iconColor
        }
        BluetoothIcon {
            color: iconsLayout.iconColor
        }
        BatteryIcon {
            color: iconsLayout.iconColor
        }
    }

    QuickSettingsWindow {
        id: quickSettingsWindow
        visible: false
    }
}

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.config

Item {
    id: root

    property int maxWidth: 200

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    readonly property string windowTitle: Hyprland.activeToplevel?.title ?? ""

    RowLayout {
        id: content
        spacing: 6

        // Separador
        Rectangle {
            visible: root.windowTitle !== ""
            Layout.preferredWidth: 1
            Layout.preferredHeight: 14
            color: Config.surface2Color
        }

        Text {
            id: titleText
            visible: root.windowTitle !== ""
            text: root.windowTitle
            color: Config.subtextColor
            font.family: Config.font
            font.pixelSize: Config.fontSizeNormal
            elide: Text.ElideRight
            Layout.maximumWidth: root.maxWidth
        }
    }
}

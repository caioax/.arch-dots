pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.config

Button {
    id: root

    // --- Properties ---
    property bool active: false          // The main state (true = on/colored)
    property string iconOn: ""           // Icon when active
    property string iconOff: ""          // Icon when inactive (optional)
    property string tooltipText: ""      // Tooltip text
    property int size: 30                // Button size

    // --- Fine Tuning (Offsets) ---
    // Use if the font icon is not visually centered
    property real iconOffsetX: 0
    property real iconOffsetY: 0

    // If iconOff is not defined, uses the same icon for both states
    readonly property string currentIcon: active ? iconOn : (iconOff !== "" ? iconOff : iconOn)

    // Layout
    implicitWidth: size
    implicitHeight: size
    Layout.preferredWidth: size
    Layout.preferredHeight: size

    // --- Background ---
    background: Rectangle {
        radius: root.width / 2

        color: {
            if (root.active)
                return Config.accentColor;
            if (root.hovered)
                return Config.surface2Color;
            return Config.surface1Color;
        }

        Behavior on color {
            ColorAnimation {
                duration: Config.animDuration
            }
        }
    }

    // --- Icon ---
    contentItem: Item {
        anchors.fill: parent

        Text {
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: root.iconOffsetX
            anchors.verticalCenterOffset: root.iconOffsetY

            text: root.currentIcon

            font.family: Config.font
            font.pixelSize: Config.fontSizeNormal
            font.bold: true

            // If active, uses contrast color (black/dark). If inactive, uses normal text color.
            color: root.active ? Config.textReverseColor : Config.textColor

            // Slight transparency when inactive to indicate it is "off"
            opacity: root.active ? 1.0 : 0.6
        }
    }

    // --- Tooltip ---
    ToolTip.visible: root.hovered && root.tooltipText !== ""
    ToolTip.text: root.tooltipText
    ToolTip.delay: 500
}

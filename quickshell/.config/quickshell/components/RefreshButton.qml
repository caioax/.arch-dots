pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.config

Button {
    id: root

    // --- Properties ---
    property bool loading: false         // Controls whether to show the Spinner or the Icon
    property int size: 30                // Button size
    property string tooltipText: "Refresh"

    // --- Fine Tuning (Offsets) ---
    property real iconOffsetX: 0.5
    property real iconOffsetY: 0.5

    // --- Layout ---
    implicitWidth: size
    implicitHeight: size
    Layout.preferredWidth: size
    Layout.preferredHeight: size

    // --- Background ---
    background: Rectangle {
        radius: root.height / 2

        color: {
            if (root.loading)
                return Config.accentColor;
            if (root.hovered)
                return Config.surface2Color
            return Config.surface1Color;
        }

        Behavior on color {
            ColorAnimation {
                duration: Config.animDuration
            }
        }
    }

    // --- Content ---
    contentItem: Item {
        anchors.centerIn: root

        // Refresh Icon (Visible when NOT loading)
        Text {
            anchors.centerIn: parent

            // Manual offsets
            anchors.horizontalCenterOffset: root.iconOffsetX
            anchors.verticalCenterOffset: root.iconOffsetY

            text: ""
            font.family: Config.font
            font.pixelSize: Config.fontSizeNormal
            color: Config.textColor

            visible: !root.loading
        }

        // Spinner (Visible when loading)
        Spinner {
            anchors.centerIn: parent
            running: root.loading
            size: Config.fontSizeNormal + 2
            color: Config.textReverseColor
        }
    }

    // --- Tooltip ---
    ToolTip.visible: root.hovered && root.tooltipText !== ""
    ToolTip.text: root.tooltipText
    ToolTip.delay: 500
}

pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.config

Rectangle {
    id: root

    // --- Properties ---
    property string icon: ""
    property string label: ""
    property string subLabel: ""

    property bool active: false
    property bool hasDetails: false

    // --- Signals ---
    signal toggled
    signal openDetails

    // --- Layout ---
    Layout.fillWidth: true
    implicitHeight: 50
    radius: Config.radiusLarge

    // Colors and Animation
    color: {
        if (active)
            return Config.accentColor;
        if (mainMouse.containsMouse || (detailsMouse.containsMouse && hasDetails))
            return Config.surface2Color;
        return Config.surface1Color;
    }

    Behavior on color {
        ColorAnimation {
            duration: Config.animDurationShort
        }
    }

    // Scale effect on click
    scale: mainMouse.pressed || detailsMouse.pressed ? 0.98 : 1.0
    Behavior on scale {
        NumberAnimation {
            duration: Config.animDurationShort
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 5
        spacing: 0

        // TOGGLE AREA (Icon + Text)
        // Takes up all remaining space
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                anchors.fill: parent
                spacing: 12

                // Icon
                Text {
                    text: root.icon
                    font.family: Config.font
                    font.pixelSize: Config.fontSizeIcon
                    // If active, dark text (contrast). If inactive, normal color.
                    color: root.active ? Config.textReverseColor : Config.textColor
                }

                // Text (Title and Subtitle)
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Text {
                        text: root.label
                        font.family: Config.font
                        font.bold: true
                        font.pixelSize: Config.fontSizeNormal
                        color: root.active ? Config.textReverseColor : Config.textColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    // Only show sublabel if there is text
                    Text {
                        visible: root.subLabel !== ""
                        text: root.subLabel
                        font.family: Config.font
                        font.pixelSize: Config.fontSizeSmall
                        // Slight transparency on subtext
                        color: root.active ? Qt.alpha(Config.textReverseColor, 0.8) : Config.subtextColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }
            }

            // Main MouseArea (Toggle)
            MouseArea {
                id: mainMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.toggled()
            }
        }

        // SEPARATOR (Only if there are details)
        Rectangle {
            visible: root.hasDetails
            Layout.preferredWidth: 1
            Layout.preferredHeight: parent.height * 0.6
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 5
            Layout.rightMargin: 5

            // Separator color adapts to the background
            color: root.active ? Qt.alpha(Config.textReverseColor, 0.3) : Config.surface2Color
        }

        // DETAILS BUTTON (Arrow/Gear)
        Item {
            visible: root.hasDetails
            Layout.preferredWidth: 30
            Layout.fillHeight: true

            Text {
                anchors.centerIn: parent
                text: ""
                font.family: Config.font
                font.pixelSize: Config.fontSizeNormal
                font.bold: true
                color: root.active ? Config.textReverseColor : Config.textColor

                // Subtle animation on the arrow when hovering over it
                opacity: detailsMouse.containsMouse ? 1.0 : 0.7
            }

            MouseArea {
                id: detailsMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.openDetails()
            }
        }
    }
}

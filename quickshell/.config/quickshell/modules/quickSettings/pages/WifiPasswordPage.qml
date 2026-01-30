pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.config
import qs.services

Item {
    id: root

    Layout.fillWidth: true

    implicitHeight: 350

    // Received properties
    property string targetSsid: ""

    signal cancelled
    signal connectClicked(string password)

    // Intercept background clicks to remove input focus when clicking outside
    MouseArea {
        anchors.fill: parent
        onClicked: parent.forceActiveFocus()
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width * 0.85 // Takes 85% of the window width
        spacing: 20

        // --- Highlight Icon ---
        Text {
            text: ""
            font.family: Config.font
            font.pixelSize: 48
            color: Config.accentColor
            Layout.alignment: Qt.AlignHCenter
        }

        // --- Titles ---
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 5

            Text {
                text: "Password Required"
                color: Config.subtextColor
                font.pixelSize: Config.fontSizeNormal
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: root.targetSsid
                color: Config.textColor
                font.bold: true
                font.pixelSize: Config.fontSizeLarge
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: parent.width
            }
        }

        // --- Password Field ---
        TextField {
            id: passInput
            Layout.fillWidth: true
            Layout.preferredHeight: 45

            placeholderText: "Enter network password..."
            placeholderTextColor: Qt.alpha(Config.subtextColor, 0.5)

            color: Config.textColor
            font.family: Config.font
            font.pixelSize: Config.fontSizeNormal

            verticalAlignment: TextInput.AlignVCenter
            leftPadding: 15
            rightPadding: 40 // Space for the eye icon

            echoMode: showPassToggle.checked ? TextInput.Normal : TextInput.Password
            passwordCharacter: "•"

            background: Rectangle {
                color: Config.surface1Color
                radius: Config.radius
                border.width: 1
                border.color: passInput.activeFocus ? Config.accentColor : Config.surface2Color

                // Smooth border animation on focus
                Behavior on border.color {
                    ColorAnimation {
                        duration: 150
                    }
                }
            }

            // Show/Hide Password Button (Eye)
            Text {
                id: eyeIcon
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter

                text: showPassToggle.checked ? "" : "" // NerdFont icons (eye open/closed)
                font.family: Config.font
                font.pixelSize: 16
                color: showPassHover.containsMouse ? Config.textColor : Config.subtextColor

                MouseArea {
                    id: showPassHover
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: showPassToggle.checked = !showPassToggle.checked
                }
            }

            // Invisible state control for the toggle
            Item {
                id: showPassToggle
                property bool checked: false
            }

            // Request focus on open
            onVisibleChanged: if (visible)
                forceActiveFocus()

            // Enter connects
            onAccepted: {
                if (text.length > 0) {
                    root.connectClicked(text);
                    text = "";
                }
            }
        }

        // --- Action Buttons ---
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 10
            spacing: 15

            // Cancel Button
            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40

                background: Rectangle {
                    color: parent.down ? Qt.darker(Config.surface1Color, 1.2) : parent.hovered ? Config.surface1Color : "transparent"
                    radius: Config.radius
                    border.width: 1
                    border.color: Config.surface2Color

                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                        }
                    }
                }

                contentItem: Text {
                    text: "Cancel"
                    color: Config.subtextColor
                    font.family: Config.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    passInput.text = "";
                    showPassToggle.checked = false;
                    root.cancelled();
                }
            }

            // Connect Button
            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                enabled: passInput.text.length >= 8 // Basic WPA2 validation (min 8 chars)
                opacity: enabled ? 1.0 : 0.5

                background: Rectangle {
                    color: parent.down ? Qt.darker(Config.accentColor, 1.1) : Config.accentColor
                    radius: Config.radius

                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                        }
                    }
                }

                contentItem: Text {
                    text: "Connect"
                    color: Config.textReverseColor
                    font.bold: true
                    font.family: Config.font
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    root.connectClicked(passInput.text);
                    passInput.text = "";
                    showPassToggle.checked = false;
                }
            }
        }
    }
}

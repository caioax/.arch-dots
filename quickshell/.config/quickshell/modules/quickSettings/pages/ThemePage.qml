pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services
import "../../../components/"

Item {
    id: root

    signal backRequested

    Layout.fillWidth: true
    implicitHeight: main.implicitHeight

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: main.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        ColumnLayout {
            id: main
            width: flickable.width
            spacing: 12

            // Header
            PageHeader {
                icon: "󰏘"
                title: "Theme"
                onBackClicked: root.backRequested()

                // Current theme badge
                Rectangle {
                    Layout.preferredHeight: 28
                    Layout.preferredWidth: badgeText.implicitWidth + 16
                    radius: Config.radius
                    color: Qt.alpha(Config.accentColor, 0.15)
                    border.width: 1
                    border.color: Qt.alpha(Config.accentColor, 0.3)

                    Text {
                        id: badgeText
                        anchors.centerIn: parent
                        text: ThemeService.isAutoMode ? "Auto" : ThemeService.currentThemeName
                        font.family: Config.font
                        font.pixelSize: Config.fontSizeSmall
                        font.bold: true
                        color: Config.accentColor
                    }
                }
            }

            // Mode toggle (Auto / Preset)
            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                spacing: 8

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    radius: Config.radius
                    color: !ThemeService.isAutoMode ? Config.accentColor : (presetMouse.containsMouse ? Config.surface1Color : Config.surface0Color)
                    border.width: 1
                    border.color: !ThemeService.isAutoMode ? Config.accentColor : Config.surface1Color

                    Behavior on color {
                        ColorAnimation { duration: Config.animDurationShort }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Preset"
                        font.family: Config.font
                        font.pixelSize: Config.fontSizeSmall
                        font.bold: !ThemeService.isAutoMode
                        color: !ThemeService.isAutoMode ? Config.backgroundColor : Config.textColor
                    }

                    MouseArea {
                        id: presetMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (ThemeService.isAutoMode) {
                                ThemeService.setPresetMode(ThemeService.currentThemeName);
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    radius: Config.radius
                    color: ThemeService.isAutoMode ? Config.accentColor : (autoMouse.containsMouse ? Config.surface1Color : Config.surface0Color)
                    border.width: 1
                    border.color: ThemeService.isAutoMode ? Config.accentColor : Config.surface1Color

                    Behavior on color {
                        ColorAnimation { duration: Config.animDurationShort }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Material You"
                        font.family: Config.font
                        font.pixelSize: Config.fontSizeSmall
                        font.bold: ThemeService.isAutoMode
                        color: ThemeService.isAutoMode ? Config.backgroundColor : Config.textColor
                    }

                    MouseArea {
                        id: autoMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (!ThemeService.isAutoMode) {
                                ThemeService.setAutoMode();
                            }
                        }
                    }
                }
            }

            // Dark / Light toggle
            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                spacing: 8

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    radius: Config.radius
                    color: ThemeService.isDarkMode ? Config.accentColor : (darkMouse.containsMouse ? Config.surface1Color : Config.surface0Color)
                    border.width: 1
                    border.color: ThemeService.isDarkMode ? Config.accentColor : Config.surface1Color

                    Behavior on color {
                        ColorAnimation { duration: Config.animDurationShort }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Dark"
                        font.family: Config.font
                        font.pixelSize: Config.fontSizeSmall
                        font.bold: ThemeService.isDarkMode
                        color: ThemeService.isDarkMode ? Config.backgroundColor : Config.textColor
                    }

                    MouseArea {
                        id: darkMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (!ThemeService.isDarkMode)
                                ThemeService.setColorScheme("dark");
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    radius: Config.radius
                    color: !ThemeService.isDarkMode ? Config.accentColor : (lightMouse.containsMouse ? Config.surface1Color : Config.surface0Color)
                    border.width: 1
                    border.color: !ThemeService.isDarkMode ? Config.accentColor : Config.surface1Color

                    Behavior on color {
                        ColorAnimation { duration: Config.animDurationShort }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Light"
                        font.family: Config.font
                        font.pixelSize: Config.fontSizeSmall
                        font.bold: !ThemeService.isDarkMode
                        color: !ThemeService.isDarkMode ? Config.backgroundColor : Config.textColor
                    }

                    MouseArea {
                        id: lightMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (ThemeService.isDarkMode)
                                ThemeService.setColorScheme("light");
                        }
                    }
                }
            }

            // Separator
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Config.surface1Color
            }

            // Auto mode indicator
            Text {
                visible: ThemeService.isAutoMode
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                text: "Colors are generated from your wallpaper. Change wallpaper to update."
                font.family: Config.font
                font.pixelSize: Config.fontSizeSmall
                color: Config.subtextColor
                wrapMode: Text.WordWrap
            }

            // Theme grid
            GridLayout {
                Layout.fillWidth: true
                Layout.margins: 10
                columns: 2
                columnSpacing: 10
                rowSpacing: 10
                opacity: ThemeService.isAutoMode ? 0.5 : 1.0

                Behavior on opacity {
                    NumberAnimation { duration: Config.animDurationShort }
                }

                Repeater {
                    model: ThemeService.displayThemes

                    delegate: Rectangle {
                        id: card

                        required property string modelData
                        required property int index

                        readonly property bool isCurrent: !ThemeService.isAutoMode && modelData === ThemeService.currentThemeName
                        readonly property var preview: ThemeService.themePreviews[modelData] || {}
                        readonly property var previewPalette: preview.palette || {}
                        readonly property string displayName: preview.name || modelData

                        Layout.fillWidth: true
                        Layout.preferredHeight: 76
                        radius: Config.radius
                        color: cardMouse.containsMouse ? Config.surface1Color : Config.surface0Color
                        border.width: isCurrent ? 2 : 1
                        border.color: isCurrent ? Config.accentColor : (cardMouse.containsMouse ? Config.surface2Color : Config.surface1Color)

                        Behavior on color {
                            ColorAnimation { duration: Config.animDurationShort }
                        }
                        Behavior on border.color {
                            ColorAnimation { duration: Config.animDurationShort }
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 8

                            Text {
                                text: card.displayName
                                font.family: Config.font
                                font.pixelSize: Config.fontSizeNormal
                                font.bold: card.isCurrent
                                color: card.isCurrent ? Config.accentColor : Config.textColor
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 5

                                Repeater {
                                    model: [
                                        card.previewPalette.background || "#1a1b26",
                                        card.previewPalette.accent || "#7aa2f7",
                                        card.previewPalette.success || "#9ece6a",
                                        card.previewPalette.warning || "#e0af68",
                                        card.previewPalette.error || "#f7768e"
                                    ]

                                    delegate: Rectangle {
                                        required property string modelData
                                        width: 14
                                        height: 14
                                        radius: 7
                                        color: modelData
                                        border.width: 1
                                        border.color: Qt.alpha(Config.textColor, 0.15)
                                    }
                                }

                                Item { Layout.fillWidth: true }
                            }
                        }

                        MouseArea {
                            id: cardMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (!card.isCurrent) {
                                    ThemeService.setPresetMode(card.modelData);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

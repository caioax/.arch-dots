pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.config
import qs.services
import "./pages/"

PopupWindow {
    id: root

    // Size settings
    readonly property int contentWidth: 400
    readonly property int defaultHeight: 300
    readonly property int internalMargin: 32
    readonly property int screenMargin: 15

    implicitWidth: contentWidth + screenMargin
    implicitHeight: (pageStack.children[pageStack.currentIndex]?.implicitHeight ?? defaultHeight) + internalMargin

    // Smooth animation when height changes (page switch)
    Behavior on implicitHeight {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutQuad
        }
    }

    color: "transparent"

    property bool isClosing: false
    property bool isOpening: false

    function closeWindow() {
        if (!visible)
            return;
        isClosing = true;
        closeTimer.restart();
    }

    // Exit timer
    Timer {
        id: closeTimer
        interval: Config.animDuration
        onTriggered: {
            root.visible = false;
            isClosing = false;
            pageStack.currentIndex = 0;
        }
    }

    // --- Focus ---
    HyprlandFocusGrab {
        id: focusGrab
        windows: [root]
        active: false
        onCleared: root.closeWindow()
    }

    Timer {
        id: grapTimer
        interval: 10
        onTriggered: {
            focusGrab.active = true;
            background.forceActiveFocus();
        }
    }

    // State management on open/close
    onVisibleChanged: {
        if (visible) {
            isClosing = false;
            isOpening = true;
            WindowManagerService.registerOpen("QuickSettings");
            grapTimer.restart();
        } else {
            WindowManagerService.registerClose("QuickSettings");
            pageStack.currentIndex = 0;
            focusGrab.active = false;
            isOpening = false;
        }
    }

    // Layout
    Item {
        anchors.fill: parent

        Rectangle {
            id: background
            width: root.contentWidth
            height: root.implicitHeight
            anchors.centerIn: parent
            color: Config.backgroundTransparentColor
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

            Keys.onEscapePressed: {
                root.closeWindow();
            }

            StackLayout {
                id: pageStack
                anchors.fill: parent
                anchors.margins: 16
                currentIndex: 0

                // ==========================
                // PAGE 0: DASHBOARD
                // ==========================
                DashboardPage {
                    onCloseWindow: root.closeWindow()
                }

                // ==========================
                // PAGE 1: WI-FI
                // ==========================
                WifiPage {
                    onBackRequested: pageStack.currentIndex = 0
                    onPasswordRequested: ssid => {
                        wifiPasswordPage.targetSsid = ssid;
                        pageStack.currentIndex = 2;
                    }
                }

                // ==========================
                // PAGE 2: WI-FI PASSWORD
                // ==========================
                WifiPasswordPage {
                    id: wifiPasswordPage
                    onCancelled: pageStack.currentIndex = 1
                    onConnectClicked: password => {
                        NetworkService.connect(targetSsid, password);
                        pageStack.currentIndex = 1;
                    }
                }

                // ==========================
                // PAGE 3: BLUETOOTH
                // ==========================
                BluetoothPage {
                    onBackRequested: pageStack.currentIndex = 0
                }

                // ==========================
                // PAGE 4: NIGHT LIGHT
                // ==========================
                NightLightPage {
                    onBackRequested: pageStack.currentIndex = 0
                }
            }
        }
    }
}

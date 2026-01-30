pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services
import "../../../components/"

Item {
    id: root

    signal backRequested
    signal passwordRequested(string ssid)

    Layout.fillWidth: true
    implicitHeight: 350

    ColumnLayout {
        id: main
        anchors.fill: parent
        spacing: 15

        // Header
        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 10
            spacing: 10

            // Back button
            BackButton {
                onClicked: root.backRequested()
            }

            // Title
            Text {
                text: "Wi-Fi"
                color: Config.textColor
                font.bold: true
                font.pixelSize: Config.fontSizeIcon
                Layout.fillWidth: true
            }

            // Scan Button
            RefreshButton {
                visible: NetworkService.wifiEnabled
                loading: NetworkService.scanning

                onClicked: NetworkService.scan()
            }

            // On/Off Switch
            QsSwitch {
                checked: NetworkService.wifiEnabled
                onToggled: NetworkService.toggleWifi()
            }
        }

        // Network List
        ListView {
            id: wifiList
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 10
            clip: true
            spacing: 8

            model: NetworkService.wifiEnabled ? NetworkService.accessPoints : []

            delegate: DeviceCard {
                required property var modelData

                // Helper to know if this card is connecting
                property bool isConnectingThis: NetworkService.connectingSsid === modelData.ssid

                // Data
                title: modelData.ssid || "Hidden Network"
                subtitle: modelData.signal + "%"
                icon: NetworkService.getWifiIcon(modelData.signal)

                // States
                active: modelData.active
                connecting: isConnectingThis
                secured: modelData.secure && !active && !connecting

                // Status text
                statusText: {
                    if (connecting)
                        return "Connecting...";
                    if (active)
                        return "Connected";
                    if (modelData.saved)
                        return "Saved";
                    if (modelData.secure)
                        return "Secured";
                    return "Open";
                }

                // Menu
                showMenu: !connecting

                menuModel: {
                    var list = [];
                    if (active) {
                        list.push({
                            text: "Disconnect",
                            action: "disconnect",
                            icon: "",
                            textColor: Config.warningColor,
                            iconColor: Config.warningColor
                        });
                    } else {
                        list.push({
                            text: "Connect",
                            action: "connect",
                            icon: "",
                            textColor: Config.successColor,
                            iconColor: Config.successColor
                        });
                    }
                    if (active || modelData.saved) {
                        list.push({
                            text: "Forget",
                            action: "forget",
                            icon: "",
                            textColor: Config.errorColor,
                            iconColor: Config.errorColor
                        });
                    }
                    return list;
                }

                onMenuAction: actionId => {
                    if (actionId === "disconnect") {
                        NetworkService.disconnect();
                    } else if (actionId === "connect") {
                        wifiToggleConnect();
                    } else if (actionId === "forget") {
                        NetworkService.forget(modelData.ssid);
                    }
                }

                // Main click
                onClicked: wifiToggleConnect()

                function wifiToggleConnect() {
                    if (active) {
                        NetworkService.disconnect();
                        return;
                    }
                    if (modelData.saved) {
                        NetworkService.connect(modelData.ssid, "");
                        return;
                    }
                    if (modelData.secure) {
                        root.passwordRequested(modelData.ssid);
                    }
                    NetworkService.connect(modelData.ssid, "");
                }
            }

            // Empty list message
            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -40
                visible: !NetworkService.wifiEnabled || (parent.count === 0 && !NetworkService.scanning)
                text: {
                    if (!NetworkService.wifiEnabled)
                        return "Wi-Fi Off";
                    return "No networks found";
                }
                color: Config.surface2Color
                font.pixelSize: Config.fontSizeNormal
                font.italic: true
            }
        }
    }
}

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

            // Back Button
            BackButton {
                onClicked: root.backRequested()
            }

            // Title
            Text {
                text: "Bluetooth"
                color: Config.textColor
                font.bold: true
                font.pixelSize: Config.fontSizeIcon
                Layout.fillWidth: true
            }

            // Scan Button
            RefreshButton {
                visible: BluetoothService.isPowered
                loading: BluetoothService.isDiscovering

                onClicked: BluetoothService.toggleScan()
            }

            // Visibility Button
            ToggleButton {
                visible: BluetoothService.isPowered
                active: BluetoothService.isDiscoverable
                iconOffsetX: 0.5
                iconOffsetY: 0.5
                iconOn: ""
                iconOff: ""

                tooltipText: active ? "Visible to all" : "Invisible"

                onClicked: BluetoothService.toggleDiscoverable()
            }

            // On/Off Switch
            QsSwitch {
                checked: BluetoothService.isPowered
                onToggled: {
                    if (!BluetoothService.isPowered)
                        startScanTimer.restart();
                    BluetoothService.togglePower();
                }
            }

            // Timer to start scanning after turning on bluetooth
            Timer {
                id: startScanTimer
                interval: 300
                repeat: false
                onTriggered: BluetoothService.toggleScan()
            }
        }

        // Device List
        ListView {
            id: deviceList
            clip: true
            spacing: 8

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 10

            model: BluetoothService.isPowered ? BluetoothService.devicesList : []

            delegate: DeviceCard {
                required property var modelData

                // Data
                title: modelData.alias || modelData.name || "Unknown"
                subtitle: modelData.address || ""
                icon: BluetoothService.getDeviceIcon(modelData)

                // States
                active: modelData.connected
                connecting: BluetoothService.getIsConnecting(modelData)

                // Status text
                statusText: {
                    if (connecting)
                        return "Connecting...";
                    if (active)
                        return "Connected";
                    if (modelData.paired)
                        return "Paired";
                    return "";
                }

                // Menu settings
                showMenu: modelData.paired || modelData.trusted || modelData.connected

                menuModel: {
                    var list = [];
                    if (modelData.connected) {
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
                    list.push({
                        text: "Forget",
                        action: "forget",
                        icon: "",
                        textColor: Config.errorColor,
                        iconColor: Config.errorColor
                    });
                    return list;
                }

                onMenuAction: actionId => {
                    if (actionId === "forget") {
                        BluetoothService.forgetDevice(modelData);
                    } else if (actionId === "disconnect") {
                        BluetoothService.toggleConnection(modelData);
                    } else if (actionId === "connect") {
                        BluetoothService.toggleConnection(modelData);
                    }
                }

                // Main click
                onClicked: BluetoothService.toggleConnection(modelData)
            }

            // Empty list message
            Text {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -40
                visible: !BluetoothService.isPowered || (parent.count === 0)
                text: {
                    if (!BluetoothService.isPowered)
                        return "Activate to connect";

                    if (BluetoothService.isDiscovering)
                        return "Searching...";

                    return "No devices found";
                }
                color: Config.surface2Color
                font.pixelSize: Config.fontSizeNormal
                font.italic: true
            }
        }
    }
}

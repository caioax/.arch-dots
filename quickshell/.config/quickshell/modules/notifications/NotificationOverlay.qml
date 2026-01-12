pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.services

Scope {
    id: rootScope

    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: window

            required property var modelData
            screen: modelData

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.exclusiveZone: -1
            WlrLayershell.namespace: "notifications"

            anchors {
                top: true
                right: true
            }

            margins {
                top: 10
                right: 10
            }

            implicitWidth: Config.notifWidth
            implicitHeight: notifListView.contentHeight

            color: "transparent"

            Region {
                id: emptyRegion
            }

            mask: notifListView.count > 0 ? null : emptyRegion

            ListView {
                id: notifListView
                anchors.fill: parent

                model: NotificationService.notificationsModel

                spacing: Config.notifSpacing
                interactive: false

                displaced: Transition {
                    NumberAnimation {
                        properties: "y"
                        duration: Config.animDuration
                        easing.type: Easing.OutQuad
                    }
                }

                delegate: NotificationCard {

                    required property var modelData

                    notifId: modelData.notifId
                    appName: modelData.appName
                    summary: modelData.summary
                    body: modelData.body
                    appIcon: modelData.appIcon
                    image: modelData.image
                    urgency: modelData.urgency

                    index: modelData.index
                }
            }
        }
    }
}

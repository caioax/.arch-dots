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

            // Só mostra se houver popups ativos
            visible: NotificationService.activePopupCount > 0

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

            // Máscara vazia para quando não há notificações
            Region {
                id: emptyRegion
            }

            mask: (NotificationService.activePopupCount > 0 && implicitHeight > 0) ? null : emptyRegion

            ListView {
                id: notifListView
                anchors.fill: parent

                // Usa a lista de popups ativos
                model: NotificationService.popups

                spacing: 0
                interactive: false

                // Animação de reposicionamento
                displaced: Transition {
                    NumberAnimation {
                        properties: "y"
                        duration: Config.animDuration
                        easing.type: Easing.OutQuad
                    }
                }

                delegate: NotificationCard {
                    required property var modelData

                    wrapper: modelData
                    popupMode: true
                }
            }
        }
    }
}

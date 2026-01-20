pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.config

Item {
    id: root

    implicitWidth: isSpecialWorkspace ? specialIndicator.width : viewportWidth
    implicitHeight: heightSizeActive + 4

    readonly property int widthSize: 19
    readonly property int heightSize: 19
    readonly property int widthSizeActive: 36
    readonly property int heightSizeActive: 20
    readonly property int itemSpacing: 3
    readonly property int visibleCount: 5
    readonly property int totalWorkspaces: 99

    readonly property int activeWidthDelta: widthSizeActive - widthSize
    readonly property int bufferCount: 3

    readonly property real viewportWidth: (widthSize * visibleCount) + activeWidthDelta + (itemSpacing * (visibleCount - 1))
    readonly property real itemStep: widthSize + itemSpacing

    // --- Configuração das Special Workspaces ---
    readonly property var specialWorkspaces: ({
            "whatsapp": {
                icon: "󰖣",
                color: Config.successColor,
                name: "WhatsApp"
            },
            "spotify": {
                icon: "󰓇",
                color: Config.accentColor,
                name: "Music"
            },
            "magic": {
                icon: "",
                color: Config.warningColor,
                name: "Magic"
            }
        })

    // --- Lógica do Monitor ---
    property var currentMonitor: screen ? Hyprland.monitorFor(screen) : Hyprland.focusedMonitor

    readonly property string activeSpecialFull: currentMonitor?.lastIpcObject?.specialWorkspace?.name ?? ""

    readonly property bool isSpecialWorkspace: activeSpecialFull !== ""

    readonly property string specialWorkspaceName: {
        if (!isSpecialWorkspace)
            return "";
        if (activeSpecialFull.startsWith("special:")) {
            return activeSpecialFull.substring(8);
        }
        return activeSpecialFull;
    }

    readonly property var currentSpecialConfig: {
        if (!isSpecialWorkspace)
            return null;
        return specialWorkspaces[specialWorkspaceName] ?? {
            icon: "󰀘",
            color: Config.accentColor,
            name: specialWorkspaceName.charAt(0).toUpperCase() + specialWorkspaceName.slice(1)
        };
    }

    // Workspace ativa normal
    property var activeWorkspace: currentMonitor?.activeWorkspace ?? null
    property int activeId: activeWorkspace?.id ?? 1

    property int monitorOffset: Math.floor((activeId - 1) / 100) * 100

    readonly property int relativeActiveId: {
        let relative = activeId - monitorOffset;
        return Math.max(1, Math.min(relative, totalWorkspaces));
    }

    readonly property int targetIndex: Math.max(0, Math.min(relativeActiveId - 1, totalWorkspaces - 1))

    readonly property real targetScrollX: {
        let idealX = (targetIndex * itemStep) - (viewportWidth / 2) + (widthSizeActive / 2);
        let minX = 0;
        let maxX = (totalWorkspaces * itemStep) - itemSpacing - viewportWidth + activeWidthDelta;
        return Math.max(minX, Math.min(idealX, maxX));
    }

    property real animatedScrollX: targetScrollX

    Behavior on animatedScrollX {
        SmoothedAnimation {
            velocity: Config.animDuration
            duration: Config.animDurationLong
        }
    }

    readonly property int firstVisibleIndex: Math.max(0, Math.floor(animatedScrollX / itemStep) - bufferCount)
    readonly property int lastVisibleIndex: Math.min(totalWorkspaces - 1, Math.ceil((animatedScrollX + viewportWidth) / itemStep) + bufferCount)

    readonly property var visibleIndices: {
        let indices = [];
        for (let i = firstVisibleIndex; i <= lastVisibleIndex; i++) {
            indices.push(i);
        }
        return indices;
    }

    function calculateItemX(itemIndex: int): real {
        let baseX = itemIndex * itemStep;
        if (itemIndex > targetIndex) {
            return baseX + activeWidthDelta;
        }
        return baseX;
    }

    // =========================================================================
    // LISTENER PARA EVENTOS DO HYPRLAND
    // =========================================================================
    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "activespecial" || event.name === "workspace" || event.name === "focusedmon") {
                Hyprland.refreshMonitors();
            }
        }
    }

    Connections {
        target: Hyprland

        function onFocusedMonitorChanged() {
            Hyprland.refreshMonitors();
        }
    }

    Behavior on implicitWidth {
        SmoothedAnimation {
            velocity: 150
            duration: Config.animDuration
        }
    }

    // =========================================================================
    // SPECIAL WORKSPACE INDICATOR
    // =========================================================================
    Rectangle {
        id: specialIndicator

        visible: root.isSpecialWorkspace
        opacity: visible ? 1 : 0

        width: specialContent.width + Config.padding * 3
        height: root.heightSizeActive

        anchors.verticalCenter: parent.verticalCenter

        radius: Config.radius
        color: root.currentSpecialConfig?.color ?? Config.accentColor

        border.width: 1
        border.color: Qt.rgba(255, 255, 255, 0.1)

        Behavior on opacity {
            NumberAnimation {
                duration: Config.animDuration
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: Config.animDuration
            }
        }

        Row {
            id: specialContent

            anchors.centerIn: parent
            spacing: Config.padding * 0.8

            Text {
                id: specialIcon

                text: root.currentSpecialConfig?.icon ?? "󰀘"
                font.family: Config.font
                font.pixelSize: Config.fontSizeLarge
                color: Config.textReverseColor

                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: specialName

                text: root.currentSpecialConfig?.name ?? root.specialWorkspaceName
                font.family: Config.font
                font.bold: true
                font.pixelSize: Config.fontSizeNormal
                color: Config.textReverseColor

                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TapHandler {
            onTapped: {
                Hyprland.dispatch("togglespecialworkspace " + root.specialWorkspaceName);
            }
        }

        HoverHandler {
            id: specialHoverHandler
            cursorShape: Qt.PointingHandCursor
        }

        scale: specialHoverHandler.hovered ? 0.95 : 1.0

        Behavior on scale {
            NumberAnimation {
                duration: Config.animDuration
            }
        }
    }

    // =========================================================================
    // NORMAL WORKSPACES LIST
    // =========================================================================
    Item {
        id: workspacesContainer

        visible: !root.isSpecialWorkspace
        opacity: visible ? 1 : 0

        width: root.viewportWidth
        height: parent.height

        Behavior on opacity {
            NumberAnimation {
                duration: Config.animDuration
            }
        }

        clip: true

        Item {
            id: container

            x: -root.targetScrollX
            width: (root.totalWorkspaces * root.itemStep) + root.activeWidthDelta
            height: parent.height

            Behavior on x {
                SmoothedAnimation {
                    velocity: Config.animDuration
                    duration: Config.animDurationLong
                }
            }

            Repeater {
                model: root.visibleIndices

                delegate: Rectangle {
                    id: workspaceItem

                    required property int modelData

                    readonly property int index: modelData
                    readonly property int workspaceId: root.monitorOffset + index + 1
                    readonly property int visualId: index + 1
                    readonly property bool isActive: workspaceId === root.activeId && !root.isSpecialWorkspace
                    readonly property var wsObject: Hyprland.workspaces.values.find(ws => ws.id === workspaceId)
                    readonly property bool isEmpty: wsObject === undefined

                    x: root.calculateItemX(index)
                    y: (root.heightSizeActive + 4 - height) / 2

                    width: isActive ? root.widthSizeActive : root.widthSize
                    height: isActive ? root.heightSizeActive : root.heightSize

                    radius: Config.radius

                    color: {
                        if (isActive)
                            return Config.accentColor;
                        if (!isEmpty)
                            return Config.surface2Color;
                        return Config.surface0Color;
                    }

                    Behavior on x {
                        SmoothedAnimation {
                            velocity: 150
                            duration: Config.animDuration
                        }
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: Config.animDuration
                        }
                    }

                    Behavior on width {
                        SmoothedAnimation {
                            velocity: 150
                        }
                    }

                    Behavior on height {
                        SmoothedAnimation {
                            velocity: 150
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: workspaceItem.visualId

                        font.family: Config.font
                        font.bold: true
                        font.pixelSize: workspaceItem.isActive ? Config.fontSizeNormal : Config.fontSizeSmall

                        color: {
                            if (workspaceItem.isActive)
                                return Config.textReverseColor;
                            if (!workspaceItem.isEmpty)
                                return Config.textColor;
                            return Config.subtextColor;
                        }

                        Behavior on font.pixelSize {
                            SmoothedAnimation {
                                velocity: 50
                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: Config.animDuration
                            }
                        }
                    }

                    TapHandler {
                        onTapped: {
                            Hyprland.dispatch("workspace " + workspaceItem.workspaceId);
                        }
                    }

                    HoverHandler {
                        id: hoverHandler
                        cursorShape: !workspaceItem.isActive ? Qt.PointingHandCursor : Qt.ArrowCursor
                    }

                    opacity: hoverHandler.hovered && !isActive ? 0.7 : 1.0

                    Behavior on opacity {
                        NumberAnimation {
                            duration: Config.animDuration
                        }
                    }
                }
            }
        }
    }
}

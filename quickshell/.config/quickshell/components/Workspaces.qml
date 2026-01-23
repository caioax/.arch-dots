pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.config

Item {
    id: root

    // --- Sizing Properties ---
    readonly property int widthSize: 15
    readonly property int heightSize: 15
    readonly property int widthSizeActive: 30
    readonly property int heightSizeActive: 18
    readonly property int itemSpacing: 4
    readonly property int visibleCount: 5
    readonly property int totalWorkspaces: 99
    readonly property int activeWidthDelta: widthSizeActive - widthSize
    readonly property int bufferCount: 3

    // --- Calculated Dimensions ---
    readonly property real viewportWidth: (widthSize * visibleCount) + activeWidthDelta + (itemSpacing * (visibleCount - 1))
    readonly property real itemStep: widthSize + itemSpacing

    implicitWidth: isSpecialWorkspace ? specialIndicator.width : viewportWidth
    implicitHeight: heightSizeActive + 4

    // --- Special Workspaces Config ---
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

    // --- Monitor & Workspace Logic ---
    property var currentMonitor: screen ? Hyprland.monitorFor(screen) : Hyprland.focusedMonitor
    readonly property string activeSpecialFull: currentMonitor?.lastIpcObject?.specialWorkspace?.name ?? ""
    readonly property bool isSpecialWorkspace: activeSpecialFull !== ""

    readonly property string specialWorkspaceName: {
        if (!isSpecialWorkspace)
            return "";
        return activeSpecialFull.startsWith("special:") ? activeSpecialFull.substring(8) : activeSpecialFull;
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

    property var activeWorkspace: currentMonitor?.activeWorkspace ?? null
    property int activeId: activeWorkspace?.id ?? 1
    property int monitorOffset: Math.floor((activeId - 1) / 100) * 100

    readonly property int relativeActiveId: {
        let relative = activeId - monitorOffset;
        return Math.max(1, Math.min(relative, totalWorkspaces));
    }

    readonly property int targetIndex: Math.max(0, Math.min(relativeActiveId - 1, totalWorkspaces - 1))

    // --- Scrolling Logic ---
    readonly property real targetScrollX: {
        if (activeId < 1)
            return animatedScrollX;
        let idealX = (targetIndex * itemStep) - (viewportWidth / 2) + (widthSizeActive / 2);
        let minX = 0;
        let maxX = (totalWorkspaces * itemStep) - itemSpacing - viewportWidth + activeWidthDelta;
        return Math.max(minX, Math.min(idealX, maxX));
    }

    property real animatedScrollX: targetScrollX

    Behavior on animatedScrollX {
        NumberAnimation {
            duration: Config.animDurationLong
            easing.type: Easing.OutQuint
        }
    }

    // --- Visibility Virtualization ---
    readonly property int firstVisibleIndex: Math.max(0, Math.floor(animatedScrollX / itemStep) - bufferCount)
    readonly property int lastVisibleIndex: Math.min(totalWorkspaces - 1, Math.ceil((animatedScrollX + viewportWidth) / itemStep) + bufferCount)

    readonly property var visibleIndices: {
        let indices = [];
        for (let i = firstVisibleIndex; i <= lastVisibleIndex; i++)
            indices.push(i);
        return indices;
    }

    function calculateItemX(itemIndex: int): real {
        let baseX = itemIndex * itemStep;
        return (itemIndex > targetIndex) ? (baseX + activeWidthDelta) : baseX;
    }

    // --- IPC Listeners ---
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activespecial" || event.name === "workspace" || event.name === "focusedmon") {
                Hyprland.refreshMonitors();
            }
        }
        function onFocusedMonitorChanged() {
            Hyprland.refreshMonitors();
        }
    }

    // --- Transitions ---
    Behavior on implicitWidth {
        NumberAnimation {
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
                text: root.currentSpecialConfig?.icon ?? "󰀘"
                font {
                    family: Config.font
                    pixelSize: Config.fontSizeLarge
                }
                color: Config.textReverseColor
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: root.currentSpecialConfig?.name ?? root.specialWorkspaceName
                font {
                    family: Config.font
                    bold: true
                    pixelSize: Config.fontSizeNormal
                }
                color: Config.textReverseColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        TapHandler {
            onTapped: Hyprland.dispatch("togglespecialworkspace " + root.specialWorkspaceName)
        }

        HoverHandler {
            id: specialHover
            cursorShape: Qt.PointingHandCursor
        }
        scale: specialHover.hovered ? 0.95 : 1.0
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
        clip: true

        Behavior on opacity {
            NumberAnimation {
                duration: Config.animDuration
            }
        }

        Item {
            id: container
            x: -root.animatedScrollX
            width: (root.totalWorkspaces * root.itemStep) + root.activeWidthDelta
            height: parent.height

            Repeater {
                model: root.visibleIndices
                delegate: Rectangle {
                    id: workspaceItem
                    required property int modelData
                    readonly property int index: modelData
                    readonly property int workspaceId: root.monitorOffset + index + 1
                    readonly property bool isActive: workspaceId === root.activeId && !root.isSpecialWorkspace
                    readonly property var wsObject: Hyprland.workspaces.values.find(ws => ws.id === workspaceId)
                    readonly property bool isEmpty: wsObject === undefined

                    x: root.calculateItemX(index)
                    anchors.verticalCenter: parent.verticalCenter // Fixed vertical jumping

                    width: isActive ? root.widthSizeActive : root.widthSize
                    height: isActive ? root.heightSizeActive : root.heightSize
                    radius: Config.radius

                    color: isActive ? Config.accentColor : (!isEmpty ? Config.surface3Color : Config.surface1Color)

                    // Unified animations
                    Behavior on x {
                        NumberAnimation {
                            duration: Config.animDurationShort
                        }
                    }
                    Behavior on width {
                        NumberAnimation {
                            duration: Config.animDurationShort
                        }
                    }
                    Behavior on height {
                        NumberAnimation {
                            duration: Config.animDurationShort
                        }
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: Config.animDuration
                        }
                    }

                    TapHandler {
                        onTapped: Hyprland.dispatch("workspace " + workspaceItem.workspaceId)
                    }
                    HoverHandler {
                        id: h
                        cursorShape: !isActive ? Qt.PointingHandCursor : Qt.ArrowCursor
                    }

                    opacity: h.hovered && !isActive ? 0.7 : 1.0
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

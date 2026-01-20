pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Hyprland
import qs.config

Item {
    id: root

    implicitWidth: viewportWidth
    implicitHeight: heightSizeActive + 4

    readonly property int widthSize: 19
    readonly property int heightSize: 19
    readonly property int widthSizeActive: 36
    readonly property int heightSizeActive: 20
    readonly property int itemSpacing: 3
    readonly property int visibleCount: 5
    readonly property int totalWorkspaces: 99

    // Diferença de largura quando ativo
    readonly property int activeWidthDelta: widthSizeActive - widthSize

    // Margem extra para animação suave
    readonly property int bufferCount: 3

    readonly property real viewportWidth: (widthSize * visibleCount) + activeWidthDelta + (itemSpacing * (visibleCount - 1))
    readonly property real itemStep: widthSize + itemSpacing

    // --- Lógica do Monitor ---
    property var currentMonitor: {
        if (!screen)
            return Hyprland.focusedMonitor;
        const screenName = screen.name;
        const monitor = Hyprland.monitors.values.find(m => m.name === screenName);
        return monitor ?? Hyprland.focusedMonitor;
    }

    property int activeId: currentMonitor ? currentMonitor.activeWorkspace.id : 1
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

    // ScrollX animado para calcular janela visível
    property real animatedScrollX: targetScrollX

    Behavior on animatedScrollX {
        SmoothedAnimation {
            velocity: Config.animDuration
            duration: Config.animDurationLong
        }
    }

    // Calcula range de índices visíveis
    readonly property int firstVisibleIndex: Math.max(0, Math.floor(animatedScrollX / itemStep) - bufferCount)
    readonly property int lastVisibleIndex: Math.min(totalWorkspaces - 1, Math.ceil((animatedScrollX + viewportWidth) / itemStep) + bufferCount)

    readonly property var visibleIndices: {
        let indices = [];
        for (let i = firstVisibleIndex; i <= lastVisibleIndex; i++) {
            indices.push(i);
        }
        return indices;
    }

    // Função para calcular posição X de um item
    function calculateItemX(itemIndex: int): real {
        // Posição base (como se todos fossem do tamanho padrão)
        let baseX = itemIndex * itemStep;

        // Se este item está DEPOIS do item ativo, adiciona o delta
        if (itemIndex > targetIndex) {
            return baseX + activeWidthDelta;
        }

        return baseX;
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
                readonly property bool isActive: workspaceId === root.activeId
                readonly property var wsObject: Hyprland.workspaces.values.find(ws => ws.id === workspaceId)
                readonly property bool isEmpty: wsObject === undefined

                // Posição calculada considerando o item ativo
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

                // Anima a posição X quando o item ativo muda
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
                        duration: Config.animDuration / 2
                    }
                }
            }
        }
    }
}

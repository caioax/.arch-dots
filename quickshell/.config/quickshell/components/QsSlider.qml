pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.config

Item {
    id: root

    // --- Propriedades ---
    property real value: 0
    property real from: 0
    property real to: 1
    property string icon: ""
    property bool showPercentage: true

    // SINAIS
    signal moved(real newValue)
    signal iconClicked

    // Tamanho do componente
    implicitHeight: 40
    Layout.fillWidth: true

    RowLayout {
        anchors.fill: parent
        spacing: 10

        // --- O BOTÃO DO ÍCONE ---
        Rectangle {
            id: iconBtn

            // Define o tamanho: altura total do componente e largura igual à altura (quadrado)
            Layout.fillHeight: true
            Layout.preferredWidth: height

            radius: Config.radiusLarge

            // Cor muda se passar o mouse (feedback de botão)
            color: iconMouse.containsMouse ? Config.surface2Color : Config.surface1Color

            Behavior on color {
                ColorAnimation {
                    duration: Config.animDurationShort
                }
            }

            // Ícone
            Text {
                anchors.centerIn: parent
                text: root.icon
                font.family: Config.font
                font.pixelSize: Config.fontSizeLarge
                font.bold: true
                color: Config.textColor

                scale: iconMouse.pressed ? 0.8 : 1.0
                Behavior on scale {
                    NumberAnimation {
                        duration: Config.animDurationShort
                    }
                }
            }

            MouseArea {
                id: iconMouse
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: root.iconClicked()
            }
        }

        // A BARRA DE SLIDER
        Item {
            id: sliderContainer

            // Mágica do Layout: Ocupa toda a largura restante
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height - 5

            // Container interno para a animação de escala
            Item {
                anchors.fill: parent
                scale: sliderMouse.pressed ? 0.98 : 1.0
                Behavior on scale {
                    NumberAnimation {
                        duration: Config.animDurationShort
                        easing.type: Easing.OutQuad
                    }
                }

                // Fundo da Trilha
                Rectangle {
                    id: track
                    anchors.fill: parent
                    radius: Config.radiusLarge
                    color: Config.surface1Color
                    clip: true

                    // Barra de Preenchimento
                    Rectangle {
                        id: fill
                        height: parent.height
                        radius: Config.radiusLarge

                        // Largura baseada na porcentagem
                        width: {
                            var percent = (root.value - root.from) / (root.to - root.from);
                            percent = Math.max(0, Math.min(1, percent));
                            return parent.width * percent;
                        }

                        color: Config.accentColor

                        Behavior on width {
                            NumberAnimation {
                                duration: Config.animDurationShort
                                easing.type: Easing.OutQuad
                            }
                        }
                    }

                    // Texto de Porcentagem
                    Text {
                        visible: root.showPercentage
                        anchors.centerIn: parent

                        text: Math.round(((root.value - root.from) / (root.to - root.from)) * 100) + "%"

                        font.family: Config.font
                        font.bold: true
                        font.pixelSize: Config.fontSizeNormal

                        // Cor inteligente
                        property bool isCovered: fill.width > (parent.width / 2)
                        color: isCovered ? Config.textReverseColor : Config.textColor

                        opacity: (sliderMouse.containsMouse || sliderMouse.pressed) ? 1.0 : 0.0
                        Behavior on opacity {
                            NumberAnimation {
                                duration: Config.animDuration
                            }
                        }
                    }
                }
            }

            // MouseArea
            MouseArea {
                id: sliderMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                function updateFromMouse(mouseX) {
                    let percent = mouseX / width;
                    percent = Math.max(0, Math.min(1, percent));
                    let val = root.from + (root.to - root.from) * percent;
                    root.moved(val);
                }

                onPressed: mouse => updateFromMouse(mouse.x)
                onPositionChanged: mouse => {
                    if (pressed)
                        updateFromMouse(mouse.x);
                }

                onWheel: wheel => {
                    let step = (root.to - root.from) * 0.05;
                    if (wheel.angleDelta.y > 0)
                        root.moved(Math.min(root.to, root.value + step));
                    else
                        root.moved(Math.max(root.from, root.value - step));
                }
            }
        }
    }
}

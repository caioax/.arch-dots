pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.config

Rectangle {
    id: root

    // --- Propriedades ---
    property string icon: ""
    property string label: ""
    property string subLabel: ""

    property bool active: false
    property bool hasDetails: false

    // --- Sinais ---
    signal toggled
    signal openDetails

    // --- Layout ---
    Layout.fillWidth: true
    implicitHeight: 50
    radius: Config.radiusLarge

    // Cores e Animação
    color: {
        if (active)
            return Config.accentColor;
        if (mainMouse.containsMouse || (detailsMouse.containsMouse && hasDetails))
            return Config.surface2Color;
        return Config.surface1Color;
    }

    Behavior on color {
        ColorAnimation {
            duration: Config.animDurationShort
        }
    }

    // Efeito de escala ao clicar
    scale: mainMouse.pressed || detailsMouse.pressed ? 0.98 : 1.0
    Behavior on scale {
        NumberAnimation {
            duration: Config.animDurationShort
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 5
        spacing: 0

        // ÁREA DE TOGGLE (Ícone + Textos)
        // Ocupa todo o espaço restante
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                anchors.fill: parent
                spacing: 12

                // Ícone
                Text {
                    text: root.icon
                    font.family: Config.font
                    font.pixelSize: Config.fontSizeIcon
                    // Se ativo, texto escuro (contraste). Se inativo, cor normal.
                    color: root.active ? Config.textReverseColor : Config.textColor
                }

                // Textos (Título e Subtítulo)
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Text {
                        text: root.label
                        font.family: Config.font
                        font.bold: true
                        font.pixelSize: Config.fontSizeNormal
                        color: root.active ? Config.textReverseColor : Config.textColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    // Só mostra sublabel se tiver texto
                    Text {
                        visible: root.subLabel !== ""
                        text: root.subLabel
                        font.family: Config.font
                        font.pixelSize: Config.fontSizeSmall
                        // Leve transparência no subtexto
                        color: root.active ? Qt.alpha(Config.textReverseColor, 0.8) : Config.subtextColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }
            }

            // MouseArea Principal (Toggle)
            MouseArea {
                id: mainMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.toggled()
            }
        }

        // SEPARADOR (Apenas se tiver detalhes)
        Rectangle {
            visible: root.hasDetails
            Layout.preferredWidth: 1
            Layout.preferredHeight: parent.height * 0.6
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 5
            Layout.rightMargin: 5

            // Cor do separador se adapta ao fundo
            color: root.active ? Qt.alpha(Config.textReverseColor, 0.3) : Config.surface2Color
        }

        // BOTÃO DE DETALHES (Seta/Engrenagem)
        Item {
            visible: root.hasDetails
            Layout.preferredWidth: 30
            Layout.fillHeight: true

            Text {
                anchors.centerIn: parent
                text: ""
                font.family: Config.font
                font.pixelSize: Config.fontSizeNormal
                font.bold: true
                color: root.active ? Config.textReverseColor : Config.textColor

                // Animação sutil na seta quando passa o mouse nela
                opacity: detailsMouse.containsMouse ? 1.0 : 0.7
            }

            MouseArea {
                id: detailsMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.openDetails()
            }
        }
    }
}

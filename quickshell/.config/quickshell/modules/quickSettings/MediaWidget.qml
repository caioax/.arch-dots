pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import qs.config
import qs.services

Rectangle {
    id: root

    visible: MprisService.hasPlayer

    Layout.fillWidth: true
    implicitHeight: 110
    radius: Config.radiusLarge
    color: Config.surface1Color

    // --- FUNDO ---
    Item {
        anchors.fill: parent
        layer.enabled: true

        // A Imagem Real (Escondida, serve de fonte)
        Image {
            id: bgSource
            anchors.fill: parent
            source: MprisService.artUrl
            fillMode: Image.PreserveAspectCrop
            visible: false
        }

        // A Máscara (Para obter o formato na imagem: Retângulo arredondado)
        Rectangle {
            id: bgMask
            anchors.fill: parent
            radius: Config.radiusLarge
            visible: false
        }

        OpacityMask {
            anchors.fill: parent
            source: bgSource
            maskSource: bgMask
            opacity: 0.25
        }
    }

    // --- CONTEÚDO ---
    RowLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 15

        // --- CAPA DO ÁLBUM (Pequena) ---
        Item {
            Layout.preferredWidth: 80
            Layout.preferredHeight: 80

            // Fundo cinza de fallback
            Rectangle {
                anchors.fill: parent
                radius: Config.radius
                color: Config.surface2Color
            }

            // Imagem da capa (Fonte)
            Image {
                id: coverSource
                anchors.fill: parent
                source: MprisService.artUrl
                fillMode: Image.PreserveAspectCrop
                visible: false
            }

            // Máscara da capa
            Rectangle {
                id: coverMask
                anchors.fill: parent
                radius: Config.radius
                visible: false
            }

            // Juntando os dois
            OpacityMask {
                anchors.fill: parent
                source: coverSource
                maskSource: coverMask
            }

            // Ícone de fallback (Por cima de tudo)
            Text {
                visible: MprisService.artUrl == ""
                anchors.centerIn: parent
                text: ""
                font.family: Config.font
                font.pixelSize: 30
                color: Config.subtextColor
            }
        }

        // --- INFORMAÇÕES E CONTROLES ---
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 5
            Layout.alignment: Qt.AlignVCenter

            // Faixa e Artista
            ColumnLayout {
                spacing: 0
                Text {
                    text: MprisService.title
                    color: Config.textColor
                    font.bold: true
                    font.pixelSize: Config.fontSizeNormal
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
                Text {
                    text: MprisService.artist
                    color: Config.subtextColor
                    font.pixelSize: Config.fontSizeSmall
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    opacity: 0.8
                }
            }

            // Botões
            RowLayout {
                spacing: 15
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin: 5

                ControlButton {
                    icon: ""
                    onClicked: MprisService.previous()
                }

                // Play / Pause
                Rectangle {
                    width: 40
                    height: 40
                    radius: 20
                    color: playBtnMouse.containsMouse ? Qt.lighter(Config.accentColor, 1.1) : Config.accentColor

                    scale: playBtnMouse.pressed ? 0.9 : 1.0
                    Behavior on scale {
                        NumberAnimation {
                            duration: Config.animDurationShort
                        }
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: Config.animDurationShort
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: MprisService.isPlaying ? "" : ""
                        font.family: Config.font
                        font.pixelSize: 18
                        color: Config.textReverseColor
                        anchors.horizontalCenterOffset: MprisService.isPlaying ? 0 : 2
                    }

                    MouseArea {
                        id: playBtnMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: MprisService.playPause()
                    }
                }

                ControlButton {
                    icon: ""
                    onClicked: MprisService.next()
                }
            }
        }
    }

    // --- COMPONENTE DOS BOTÕES ---
    component ControlButton: Item {
        id: btn
        property string icon: ""
        signal clicked

        width: 30
        height: 30

        Text {
            anchors.centerIn: parent
            text: btn.icon
            font.family: Config.font
            font.pixelSize: 22
            color: mouseArea.containsMouse ? Config.accentColor : Config.textColor
            Behavior on color {
                ColorAnimation {
                    duration: Config.animDurationShort
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: btn.clicked()
            onPressedChanged: btn.scale = pressed ? 0.9 : 1.0
        }
        Behavior on scale {
            NumberAnimation {
                duration: Config.animDurationShort
            }
        }
    }
}

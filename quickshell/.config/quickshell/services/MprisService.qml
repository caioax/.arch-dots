pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    // --- PROPRIEDADES ---
    readonly property var players: Mpris.players.values
    property var activePlayer: null
    readonly property bool hasPlayer: activePlayer !== null

    // Metadados seguros
    readonly property string title: activePlayer?.metadata?.["xesam:title"] ?? "Desconhecido"
    readonly property string artist: activePlayer?.metadata?.["xesam:artist"] ?? "Desconhecido"
    readonly property string artUrl: activePlayer?.metadata?.["mpris:artUrl"] ?? ""
    readonly property bool isPlaying: activePlayer?.isPlaying ?? false

    // A lista que a UI vai usar (Visual)
    property var orderedPlayers: []

    // --- TRIGGERS ---

    // Sempre que o player ativo mudar, reorganizamos a lista visual
    onActivePlayerChanged: updateOrderedList()

    // Se a lista bruta do sistema mudar, atualizamos tudo
    Connections {
        target: Mpris.players
        function onValuesChanged() {
            root.updateActivePlayer(); // Primeiro decide quem é o ativo
            root.updateOrderedList();  // Depois ordena
        }
    }

    // --- MONITORAMENTO ---
    Instantiator {
        model: Mpris.players.values

        delegate: QtObject {
            required property var modelData

            property bool isPlaying: modelData.isPlaying ?? false

            // Se alguém der Play/Pause, rodamos a lógica
            onIsPlayingChanged: root.updateActivePlayer()
        }

        // Garante atualização ao abrir/fechar players
        onObjectAdded: root.updateActivePlayer()
        onObjectRemoved: root.updateActivePlayer()
    }

    // --- LÓGICA DE DECISÃO (O Cérebro) ---
    function updateActivePlayer() {
        const rawList = Mpris.players.values;

        if (rawList.length === 0) {
            root.activePlayer = null;
            return;
        }

        // Procurando se tem algum player ativo
        const playing = rawList.find(p => p.isPlaying);

        if (playing) {
            // Se achou alguém tocando, ele assume imediatamente.
            root.activePlayer = playing;
            return;
        }

        // Se ninguém está tocando, verifica se o activePlayer atual ainda existe na lista.
        // Se existir, não mudamos nada. Ele continua lá, pausado.
        if (root.activePlayer && rawList.includes(root.activePlayer)) {
            return;
        }

        // Se ninguém toca e o player anterior foi fechado, pega o primeiro que sobrar.
        root.activePlayer = rawList[0];
    }

    // --- LÓGICA VISUAL (A Ordem) ---
    function updateOrderedList() {
        const rawList = Mpris.players.values;

        if (!root.activePlayer) {
            root.orderedPlayers = rawList;
            return;
        }

        // Filtra os outros e coloca o ativo no topo [0]
        const others = rawList.filter(p => p !== root.activePlayer);
        root.orderedPlayers = [root.activePlayer].concat(others);
    }

    // --- CONTROLES ---
    function playPause() {
        if (!hasPlayer)
            return;

        if (isPlaying) {
            activePlayer.pause();
        } else {
            activePlayer.play();
        }
    }

    function next() {
        if (activePlayer?.canGoNext)
            activePlayer.next();
    }

    function previous() {
        if (activePlayer?.canGoPrevious)
            activePlayer.previous();
    }
}

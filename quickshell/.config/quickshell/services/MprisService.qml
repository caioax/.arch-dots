pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    // --- PROPERTIES ---
    readonly property var players: Mpris.players.values
    property var activePlayer: null
    readonly property bool hasPlayer: activePlayer !== null

    // Safe metadata
    readonly property string title: activePlayer?.metadata?.["xesam:title"] ?? "Unknown"
    readonly property string artist: activePlayer?.metadata?.["xesam:artist"] ?? "Unknown"
    readonly property string artUrl: activePlayer?.metadata?.["mpris:artUrl"] ?? ""
    readonly property bool isPlaying: activePlayer?.isPlaying ?? false

    // The list the UI will use (Visual)
    property var orderedPlayers: []

    // --- TRIGGERS ---

    // Whenever the active player changes, we reorganize the visual list
    onActivePlayerChanged: updateOrderedList()

    // If the raw system list changes, we update everything
    Connections {
        target: Mpris.players
        function onValuesChanged() {
            root.updateActivePlayer(); // First decide who is the active one
            root.updateOrderedList();  // Then sort
        }
    }

    // --- MONITORING ---
    Instantiator {
        model: Mpris.players.values

        delegate: QtObject {
            required property var modelData

            property bool isPlaying: modelData.isPlaying ?? false

            // If someone triggers Play/Pause, we run the logic
            onIsPlayingChanged: root.updateActivePlayer()
        }

        // Ensures update when opening/closing players
        onObjectAdded: root.updateActivePlayer()
        onObjectRemoved: root.updateActivePlayer()
    }

    // --- DECISION LOGIC (The Brain) ---
    function updateActivePlayer() {
        const rawList = Mpris.players.values;

        if (rawList.length === 0) {
            root.activePlayer = null;
            return;
        }

        // Looking for any active player
        const playing = rawList.find(p => p.isPlaying);

        if (playing) {
            // If found someone playing, it takes over immediately.
            root.activePlayer = playing;
            return;
        }

        // If nobody is playing, check if the current activePlayer still exists in the list.
        // If it does, we don't change anything. It stays there, paused.
        if (root.activePlayer && rawList.includes(root.activePlayer)) {
            return;
        }

        // If nobody is playing and the previous player was closed, pick the first one left.
        root.activePlayer = rawList[0];
    }

    // --- VISUAL LOGIC (The Order) ---
    function updateOrderedList() {
        const rawList = Mpris.players.values;

        if (!root.activePlayer) {
            root.orderedPlayers = rawList;
            return;
        }

        // Filter the others and put the active one on top [0]
        const others = rawList.filter(p => p !== root.activePlayer);
        root.orderedPlayers = [root.activePlayer].concat(others);
    }

    // --- CONTROLS ---
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

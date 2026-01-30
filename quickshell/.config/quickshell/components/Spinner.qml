pragma ComponentBehavior: Bound
import QtQuick
import qs.config

Text {
    id: root

    // --- Configurable Properties ---
    property bool running: true          // Controls whether it spins and appears
    property int size: Config.fontSizeIcon

    // Default color is normal text color, but can be overridden
    color: Config.textColor

    // --- Visual Configuration ---
    text: ""
    font.family: Config.font
    font.pixelSize: size

    // Visibility tied to running state
    visible: running

    // --- Animation ---
    RotationAnimator on rotation {
        from: 0
        to: 360
        duration: 1000
        loops: Animation.Infinite
        running: root.running
    }
}

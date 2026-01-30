pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // Main boolean property for other modules to query
    readonly property bool anyModuleOpen: openWindowsCount > 0
    property int openWindowsCount: 0

    // List to know EXACTLY what is open
    property var activeModules: ({})

    function registerOpen(moduleName) {
        if (!activeModules[moduleName]) {
            let copy = activeModules;
            copy[moduleName] = true;
            activeModules = copy;
            openWindowsCount++;
        }
    }

    function registerClose(moduleName) {
        if (activeModules[moduleName]) {
            let copy = activeModules;
            delete copy[moduleName];
            activeModules = copy;
            openWindowsCount--;
        }
    }

    onAnyModuleOpenChanged: {
        if (anyModuleOpen) {
            createFile.running = true;
        } else {
            removeFile.running = true;
        }
    }

    // Initial cleanup to avoid remnants in case of errors
    Component.onCompleted: {
        removeFile.running = true;
    }

    // Control file
    Process {
        id: createFile
        command: ["touch", "/tmp/QsAnyModuleIsOpen"]
    }

    Process {
        id: removeFile
        command: ["rm", "-f", "/tmp/QsAnyModuleIsOpen"]
    }
}

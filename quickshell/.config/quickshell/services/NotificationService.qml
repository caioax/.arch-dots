pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    readonly property ListModel notificationsModel: ListModel {}

    // Guarda o ID da notificação que está com o mouse em cima atualmente
    property string hoveredNotificationId: ""

    function setHovered(id) {
        hoveredNotificationId = id;
    }

    function clearHovered() {
        hoveredNotificationId = "";
    }

    NotificationServer {
        id: server

        onNotification: notification => {
            const item = {
                "notifId": notification.id,
                "summary": notification.summary || "Notificação",
                "body": notification.body || "",
                "appName": notification.appName || "Sistema",
                "appIcon": notification.appIcon || "",
                "image": notification.image || "",
                "urgency": notification.urgency,
                "nativeObject": notification
            };

            root.notificationsModel.insert(0, item);
        }
    }

    // Fecha pelo Index da lista
    function closeNotification(index) {
        if (index >= 0 && index < notificationsModel.count) {
            const item = notificationsModel.get(index);
            if (item.nativeObject) {
                try {
                    item.nativeObject.dismiss();
                } catch (e) {}
            }
            notificationsModel.remove(index);
        }
    }
}

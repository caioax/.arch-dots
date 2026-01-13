pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import qs.config

Singleton {
    id: root

    // ========================================================================
    // LISTAS DE NOTIFICAÇÕES
    // ========================================================================

    // Lista principal de wrappers (todas as notificações)
    readonly property list<NotifWrapper> notifications: []

    // Lista de popups ativos (filtrada)
    readonly property list<NotifWrapper> popups: notifications.filter(n => n && n.popup)

    // Contagem para a UI
    readonly property int count: notifications.length
    readonly property int activePopupCount: popups.length

    // ID da notificação com hover (para pausar timer)
    property int hoveredNotificationId: -1

    // ========================================================================
    // SERVIDOR DE NOTIFICAÇÕES
    // ========================================================================

    NotificationServer {
        id: server

        keepOnReload: true
        actionsSupported: true
        actionIconsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        persistenceSupported: true

        onNotification: notif => {
            console.log("[Notif] Recebida:", notif.appName, "-", notif.summary);

            // Marca como tracked para persistir
            notif.tracked = true;

            // Cria o wrapper
            const wrapper = notifComponent.createObject(root, {
                "popup": true,
                "notification": notif
            });

            if (wrapper) {
                // Adiciona à lista (isso dispara a reatividade)
                root.notifications.push(wrapper);

                // Inicia o timer do popup
                wrapper.startLifecycle();

                console.log("[Notif] Wrapper criado. Total:", root.notifications.length, "Popups:", root.popups.length);
            }
        }
    }

    // ========================================================================
    // COMPONENTE WRAPPER
    // ========================================================================

    component NotifWrapper: QtObject {
        id: wrapper

        // Estado do popup
        property bool popup: false

        // Lógica de pausa do timer
        // Quanto tempo falta para expirar (começa com o total)
        property int _remainingTime: Config.notifTimeout
        // Timestamp de quando o timer começou a rodar pela última vez
        property double _startTime: 0

        // Timer em sí
        readonly property Timer timer: Timer {
            interval: wrapper._remainingTime
            repeat: false
            running: false
            onTriggered: {
                console.log("[Notif] Timer expirou para:", wrapper.notification ? wrapper.notification.id : "?");
                wrapper.popup = false;
            }
        }

        // Função para iniciar a vida do popup (chama ao criar)
        function startLifecycle() {
            _remainingTime = Config.notifTimeout;
            _startTime = Date.now();
            timer.interval = _remainingTime;
            timer.start();
        }

        // Pausa o timer quando hover
        property bool isPaused: root.hoveredNotificationId == (notification ? notification.id : -1)

        onIsPausedChanged: {
            if (isPaused) {
                // --- PAUSAR ---
                if (timer.running) {
                    timer.stop();
                    // Calcula quanto tempo passou desde o start até agora
                    var elapsed = Date.now() - _startTime;
                    // Subtrai do tempo restante
                    _remainingTime -= elapsed;

                    if (_remainingTime < 0)
                        _remainingTime = 0;
                    console.log("[Notif] Pausado. Restam:", _remainingTime, "ms");
                }
            } else {
                // --- RETOMAR ---
                if (popup && _remainingTime > 0) {
                    // Atualiza o start time para "agora"
                    _startTime = Date.now();
                    // Define o intervalo do timer apenas com o que falta
                    timer.interval = _remainingTime;
                    timer.start();
                    console.log("[Notif] Retomado.");
                } else if (popup && _remainingTime <= 0) {
                    // Se o tempo acabou durante a lógica, fecha logo
                    wrapper.popup = false;
                }
            }
        }

        // Timestamp
        readonly property date time: new Date()
        readonly property string timeStr: {
            const now = new Date();
            const diff = now.getTime() - time.getTime();
            const minutes = Math.floor(diff / 60000);

            if (minutes < 1)
                return "agora";
            if (minutes < 60)
                return minutes + "m atrás";

            const hours = Math.floor(minutes / 60);
            if (hours < 24)
                return hours + "h atrás";

            return Math.floor(hours / 24) + "d atrás";
        }

        // Referência à notificação nativa
        required property Notification notification

        // Propriedades derivadas (com null-safety)
        readonly property int notifId: notification ? notification.id : -1
        readonly property string summary: notification ? (notification.summary || "") : ""
        readonly property string body: notification ? (notification.body || "") : ""
        readonly property string appIcon: notification ? (notification.appIcon || "") : ""
        readonly property string appName: notification ? (notification.appName || "Sistema") : "Sistema"
        readonly property string image: notification ? (notification.image || "") : ""
        readonly property int urgency: notification ? notification.urgency : 0
        readonly property bool isUrgent: urgency === 2 // NotificationUrgency.Critical
        readonly property var actions: notification ? (notification.actions || []) : []
        readonly property bool hasActions: actions && actions.length > 0

        // Conexão para quando a notificação é destruída
        readonly property Connections conn: Connections {
            target: wrapper.notification ? wrapper.notification.Retainable : null

            function onDropped(): void {
                console.log("[Notif] Dropped:", wrapper.notifId);
                // Remove da lista
                root.notifications = root.notifications.filter(w => w !== wrapper);
            }

            function onAboutToDestroy(): void {
                wrapper.destroy();
            }
        }
    }

    Component {
        id: notifComponent
        NotifWrapper {}
    }

    // ========================================================================
    // FUNÇÕES PÚBLICAS
    // ========================================================================

    function setHovered(notifId) {
        hoveredNotificationId = notifId;
    }

    function clearHovered() {
        hoveredNotificationId = -1;
    }

    // Esconde o popup mas mantém no histórico
    function expireNotification(notifId) {
        for (let i = 0; i < notifications.length; i++) {
            if (notifications[i].notifId === notifId) {
                notifications[i].popup = false;
                notifications[i].timer.stop();
                break;
            }
        }
    }

    // Remove completamente
    function removeNotification(notifId) {
        for (let i = 0; i < notifications.length; i++) {
            if (notifications[i].notifId === notifId) {
                const wrapper = notifications[i];
                wrapper.popup = false;
                wrapper.timer.stop();
                if (wrapper.notification) {
                    wrapper.notification.dismiss();
                }
                break;
            }
        }
    }

    // Limpa todas
    function clearAll() {
        const toRemove = notifications.slice();
        for (const wrapper of toRemove) {
            if (wrapper && wrapper.notification) {
                wrapper.notification.dismiss();
            }
        }
    }

    // ========================================================================
    // HELPER PARA ÍCONES
    // ========================================================================

    function getIconSource(appIcon, image) {
        // Prioridade 1: imagem inline da notificação
        if (image && image !== "") {
            if (image.startsWith("/")) {
                return "file://" + image;
            }
            if (image.startsWith("file://") || image.startsWith("image://")) {
                return image;
            }
            return image;
        }

        // Prioridade 2: ícone do aplicativo
        if (appIcon && appIcon !== "") {
            if (appIcon.startsWith("/")) {
                return "file://" + appIcon;
            }
            if (appIcon.startsWith("file://") || appIcon.startsWith("image://")) {
                return appIcon;
            }
            return "image://icon/" + appIcon;
        }

        return "";
    }
}

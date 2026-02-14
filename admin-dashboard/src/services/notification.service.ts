import api from "@/lib/api";

export interface Notification {
    id: string;
    title: string;
    message: string;
    time: string; // ISO string or relative time for now
    unread: boolean;
    type: "alert" | "info" | "success" | "warning";
}

// Mock data to start with
let MOCK_NOTIFICATIONS: Notification[] = [
    {
        id: "1",
        title: "Nouvelle alerte épidémiologique",
        message: "Augmentation des cas de cholera dans le Sud",
        time: new Date(Date.now() - 1000 * 60 * 5).toISOString(), // 5 min ago
        unread: true,
        type: "alert",
    },
    {
        id: "2",
        title: "Rapport mensuel disponible",
        message: "Le rapport de janvier est prêt à être consulté",
        time: new Date(Date.now() - 1000 * 60 * 60).toISOString(), // 1 hour ago
        unread: true,
        type: "info",
    },
    {
        id: "3",
        title: "Nouveau patient enregistré",
        message: "Jean Baptiste a été ajouté au système",
        time: new Date(Date.now() - 1000 * 60 * 60 * 2).toISOString(), // 2 hours ago
        unread: false,
        type: "success",
    },
    {
        id: "4",
        title: "Stock faible: Amoxicilline",
        message: "Le stock du Centre Delmas 32 est sous le seuil critique",
        time: new Date(Date.now() - 1000 * 60 * 60 * 5).toISOString(),
        unread: true,
        type: "warning",
    },
];

export const NotificationService = {
    getAll: async (): Promise<Notification[]> => {
        // Simulate API delay
        await new Promise(resolve => setTimeout(resolve, 500));
        return [...MOCK_NOTIFICATIONS];
    },

    markAsRead: async (id: string): Promise<void> => {
        await new Promise(resolve => setTimeout(resolve, 200));
        MOCK_NOTIFICATIONS = MOCK_NOTIFICATIONS.map(n =>
            n.id === id ? { ...n, unread: false } : n
        );
    },

    markAllAsRead: async (): Promise<void> => {
        await new Promise(resolve => setTimeout(resolve, 300));
        MOCK_NOTIFICATIONS = MOCK_NOTIFICATIONS.map(n => ({ ...n, unread: false }));
    },

    clear: async (id: string): Promise<void> => {
        await new Promise(resolve => setTimeout(resolve, 200));
        MOCK_NOTIFICATIONS = MOCK_NOTIFICATIONS.filter(n => n.id !== id);
    },

    // For demo purposes to reset state
    resetMock: () => {
        MOCK_NOTIFICATIONS = [
            {
                id: "1",
                title: "Nouvelle alerte épidémiologique",
                message: "Augmentation des cas de cholera dans le Sud",
                time: new Date(Date.now() - 1000 * 60 * 5).toISOString(),
                unread: true,
                type: "alert",
            },
            {
                id: "2",
                title: "Rapport mensuel disponible",
                message: "Le rapport de janvier est prêt à être consulté",
                time: new Date(Date.now() - 1000 * 60 * 60).toISOString(),
                unread: true,
                type: "info",
            },
            {
                id: "3",
                title: "Nouveau patient enregistré",
                message: "Jean Baptiste a été ajouté au système",
                time: new Date(Date.now() - 1000 * 60 * 60 * 2).toISOString(),
                unread: false,
                type: "success",
            },
            {
                id: "4",
                title: "Stock faible: Amoxicilline",
                message: "Le stock du Centre Delmas 32 est sous le seuil critique",
                time: new Date(Date.now() - 1000 * 60 * 60 * 5).toISOString(),
                unread: true,
                type: "warning",
            },
        ];
    }
};

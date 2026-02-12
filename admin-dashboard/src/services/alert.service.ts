import api from "@/lib/api";

export interface EpidemiologicalAlert {
    id: string;
    disease: string;
    zone: string;
    severity: "LOW" | "MEDIUM" | "HIGH" | "CRITICAL";
    threshold: number;
    currentCases: number;
    status: "ACTIVE" | "RESOLVED";
    description: string;
    createdAt: Date;
    resolvedAt?: Date;
}

export interface AlertConfig {
    diseases: DiseaseConfig[];
}

export interface DiseaseConfig {
    name: string;
    thresholds: {
        low: number;
        medium: number;
        high: number;
        critical: number;
    };
}

export interface CreateAlertRequest {
    disease: string;
    zone: string;
    severity: "LOW" | "MEDIUM" | "HIGH" | "CRITICAL";
    threshold: number;
    description: string;
}

export const AlertService = {
    getAlerts: async (): Promise<EpidemiologicalAlert[]> => {
        try {
            const response = await api.get("/epidemiological-alerts");
            return response.data.data?.alerts || response.data.alerts || response.data.data || response.data;
        } catch (error) {
            console.error("Error fetching alerts:", error);
            throw error;
        }
    },

    getConfig: async (): Promise<AlertConfig> => {
        try {
            const response = await api.get("/epidemiological-alerts/config");
            return response.data.data || response.data;
        } catch (error) {
            console.error("Error fetching alert config:", error);
            throw error;
        }
    },

    updateConfig: async (config: AlertConfig): Promise<AlertConfig> => {
        try {
            const response = await api.put("/epidemiological-alerts/config", config);
            return response.data.data || response.data;
        } catch (error) {
            console.error("Error updating alert config:", error);
            throw error;
        }
    },

    createAlert: async (data: CreateAlertRequest): Promise<EpidemiologicalAlert> => {
        try {
            const response = await api.post("/epidemiological-alerts", data);
            return response.data.data?.alert || response.data.alert || response.data.data || response.data;
        } catch (error) {
            console.error("Error creating alert:", error);
            throw error;
        }
    },

    updateStatus: async (id: string, status: "ACTIVE" | "RESOLVED"): Promise<EpidemiologicalAlert> => {
        try {
            const response = await api.patch(`/epidemiological-alerts/${id}/status`, { status });
            return response.data.data?.alert || response.data.alert || response.data.data || response.data;
        } catch (error) {
            console.error("Error updating alert status:", error);
            throw error;
        }
    },
};

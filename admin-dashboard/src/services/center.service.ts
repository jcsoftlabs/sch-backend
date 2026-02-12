import api from "@/lib/api";
import { HealthCenter } from "@/components/dashboard/HealthCenterTable";

export const CenterService = {
    getAll: async (): Promise<HealthCenter[]> => {
        try {
            const response = await api.get("/health-centers");
            console.log("Centers API response:", response.data); // DEBUG
            // Backend returns {status, data: {healthCenters: [...]}}
            return response.data.data?.healthCenters || response.data.healthCenters || response.data.data || response.data;
        } catch (error) {
            console.error("Error fetching health centers:", error);
            throw error;
        }
    },

    create: async (data: Omit<HealthCenter, 'id'>): Promise<HealthCenter> => {
        try {
            const response = await api.post("/health-centers", data);
            return response.data.data?.healthCenter || response.data.healthCenter || response.data.data || response.data;
        } catch (error) {
            console.error("Error creating health center:", error);
            throw error;
        }
    },

    update: async (id: string, data: Partial<HealthCenter>): Promise<HealthCenter> => {
        try {
            const response = await api.put(`/health-centers/${id}`, data);
            return response.data.data?.healthCenter || response.data.healthCenter || response.data.data || response.data;
        } catch (error) {
            console.error("Error updating health center:", error);
            throw error;
        }
    },

    delete: async (id: string): Promise<void> => {
        try {
            await api.delete(`/health-centers/${id}`);
        } catch (error) {
            console.error("Error deleting health center:", error);
            throw error;
        }
    },
};

import api from "@/lib/api";
import { Household } from "@/components/dashboard/HouseholdTable";

export const HouseholdService = {
    getAll: async (): Promise<Household[]> => {
        try {
            const response = await api.get("/households");
            return response.data.data?.households || response.data.households || response.data.data || response.data;
        } catch (error) {
            console.error("Error fetching households:", error);
            throw error;
        }
    },

    getById: async (id: string): Promise<any> => {
        try {
            const response = await api.get(`/households/${id}`);
            return response.data.data?.household || response.data.household || response.data.data || response.data;
        } catch (error) {
            console.error("Error fetching household:", error);
            throw error;
        }
    },

    delete: async (id: string): Promise<void> => {
        try {
            await api.delete(`/households/${id}`);
        } catch (error) {
            console.error("Error deleting household:", error);
            throw error;
        }
    },
};

import api from "@/lib/api";

export interface User {
    id: string;
    email: string;
    name: string;
    role: "ADMIN" | "AGENT" | "DOCTOR" | "NURSE";
    phone?: string;
    zone?: string;
    healthCenterId?: string;
}

export const UserService = {
    getById: async (id: string): Promise<User> => {
        try {
            const response = await api.get(`/users/${id}`);
            return response.data.data?.user || response.data.user || response.data.data || response.data;
        } catch (error) {
            console.error("Error fetching user:", error);
            throw error;
        }
    },

    update: async (id: string, data: Partial<User> & { password?: string }): Promise<User> => {
        try {
            const response = await api.put(`/users/${id}`, data);
            return response.data.data?.user || response.data.user || response.data.data || response.data;
        } catch (error) {
            console.error("Error updating user:", error);
            throw error;
        }
    }
};

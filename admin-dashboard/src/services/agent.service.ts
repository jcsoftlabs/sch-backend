import api from "@/lib/api";

export interface Agent {
    id: string;
    name: string;
    email: string;
    role: "AGENT" | "ADMIN" | "DOCTOR";
    createdAt?: string;
}

export const AgentService = {
    getAll: async (): Promise<Agent[]> => {
        try {
            const response = await api.get("/users");
            console.log("Users API response:", response.data); // DEBUG
            // Backend returns {status, data: {users: [...]}}
            const users = response.data.data?.users || response.data.users || response.data.data || response.data;
            // Filter only agents
            return users.filter((u: any) => u.role === "AGENT");
        } catch (error) {
            console.error("Error fetching agents:", error);
            throw error;
        }
    },

    create: async (data: Omit<Agent, 'id'>): Promise<Agent> => {
        try {
            const response = await api.post("/users", { ...data, role: "AGENT" });
            return response.data.data?.user || response.data.user || response.data.data || response.data;
        } catch (error) {
            console.error("Error creating agent:", error);
            throw error;
        }
    },

    update: async (id: string, data: Partial<Agent>): Promise<Agent> => {
        try {
            const response = await api.put(`/users/${id}`, data);
            return response.data.data?.user || response.data.user || response.data.data || response.data;
        } catch (error) {
            console.error("Error updating agent:", error);
            throw error;
        }
    },

    delete: async (id: string): Promise<void> => {
        try {
            await api.delete(`/users/${id}`);
        } catch (error) {
            console.error("Error deleting agent:", error);
            throw error;
        }
    },
};

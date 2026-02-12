import api from "@/lib/api";

export interface Consultation {
    id: string;
    patientId: string;
    patient: {
        firstName: string;
        lastName: string;
    };
    doctorId?: string;
    doctor?: {
        name: string;
    };
    status: "PENDING" | "ACCEPTED" | "COMPLETED" | "CANCELLED";
    createdAt: string;
}

export const ConsultationService = {
    getAll: async (): Promise<Consultation[]> => {
        try {
            const response = await api.get("/consultations"); // Ensure backend has this endpoint
            console.log("Consultations API response:", response.data); // DEBUG
            // Backend returns {status, data: {consultations: [...]}}
            return response.data.data?.consultations || response.data.consultations || response.data.data || response.data;
        } catch (error) {
            console.error("Error fetching consultations:", error);
            throw error;
        }
    },

    create: async (data: Omit<Consultation, 'id' | 'createdAt'>): Promise<Consultation> => {
        try {
            const response = await api.post("/consultations", data);
            return response.data.data?.consultation || response.data.consultation || response.data.data || response.data;
        } catch (error) {
            console.error("Error creating consultation:", error);
            throw error;
        }
    },

    update: async (id: string, data: Partial<Consultation>): Promise<Consultation> => {
        try {
            const response = await api.put(`/consultations/${id}`, data);
            return response.data.data?.consultation || response.data.consultation || response.data.data || response.data;
        } catch (error) {
            console.error("Error updating consultation:", error);
            throw error;
        }
    },

    updateStatus: async (id: string, status: Consultation['status']): Promise<Consultation> => {
        try {
            const response = await api.patch(`/consultations/${id}/status`, { status });
            return response.data.data?.consultation || response.data.consultation || response.data.data || response.data;
        } catch (error) {
            console.error("Error updating consultation status:", error);
            throw error;
        }
    },

    delete: async (id: string): Promise<void> => {
        try {
            await api.delete(`/consultations/${id}`);
        } catch (error) {
            console.error("Error deleting consultation:", error);
            throw error;
        }
    },
};

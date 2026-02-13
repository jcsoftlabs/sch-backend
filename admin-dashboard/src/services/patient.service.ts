import api from "@/lib/api";
import { Patient } from "@/components/dashboard/PatientTable";

// Re-export Patient type for use in other components
export type { Patient };

export const PatientService = {
    getAll: async (): Promise<Patient[]> => {
        try {
            const response = await api.get("/patients");
            console.log("Patients API response:", response.data); // DEBUG
            // Backend returns {status, data: {patients: [...]}}
            return response.data.data?.patients || response.data.patients || response.data.data || response.data;
        } catch (error) {
            console.error("Error fetching patients:", error);
            throw error;
        }
    },

    getById: async (id: string): Promise<Patient> => {
        try {
            const response = await api.get(`/patients/${id}`);
            return response.data.data?.patient || response.data.patient || response.data.data || response.data;
        } catch (error) {
            console.error("Error fetching patient:", error);
            throw error;
        }
    },

    create: async (data: Omit<Patient, 'id'>): Promise<Patient> => {
        try {
            const response = await api.post("/patients", data);
            return response.data.data?.patient || response.data.patient || response.data.data || response.data;
        } catch (error) {
            console.error("Error creating patient:", error);
            throw error;
        }
    },

    update: async (id: string, data: Partial<Patient>): Promise<Patient> => {
        try {
            const response = await api.put(`/patients/${id}`, data);
            return response.data.data?.patient || response.data.patient || response.data.data || response.data;
        } catch (error) {
            console.error("Error updating patient:", error);
            throw error;
        }
    },

    delete: async (id: string): Promise<void> => {
        try {
            await api.delete(`/patients/${id}`);
        } catch (error) {
            console.error("Error deleting patient:", error);
            throw error;
        }
    },
};

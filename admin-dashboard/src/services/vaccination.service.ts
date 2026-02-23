import { api } from './api';

export interface Vaccination {
    id: string;
    patientId: string;
    vaccine: string;
    doseNumber: number;
    dateGiven: string;
    nextDueDate?: string;
    batchNumber?: string;
    agentId: string;
    notes?: string;
    createdAt: string;
    Patient?: {
        id: string;
        firstName: string;
        lastName: string;
        zone?: string;
    };
    Agent?: {
        id: string;
        firstName: string;
        lastName: string;
    };
}

export interface VaccinationStats {
    totalGiven: number;
    dueToday: number;
    overdue: number;
    coverageByZone: Array<{
        zone: string;
        count: number;
    }>;
    recentVaccinations: Vaccination[];
}

export const vaccinationService = {
    /**
     * Fetch all vaccinations, optionally filtered by zone or date
     */
    getAll: async (params?: Record<string, any>) => {
        const response = await api.get('/vaccinations', { params });
        return response.data;
    },

    /**
     * Fetch epidemiological stats for the dashboard
     */
    getStats: async (): Promise<VaccinationStats> => {
        const response = await api.get('/vaccinations/stats/dashboard');
        return response.data.data;
    },

    /**
     * Fetch vaccinations specifically for a single patient profile
     */
    getByPatient: async (patientId: string) => {
        const response = await api.get(`/vaccinations/patient/${patientId}`);
        return response.data;
    },
};

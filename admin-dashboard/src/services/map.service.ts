import api from "@/lib/api";

export interface HealthCenter {
    id: string;
    name: string;
    latitude: number;
    longitude: number;
    type: string;
    activeAgents: number;
    totalConsultations: number;
}

export interface CaseReport {
    id: string;
    latitude: number;
    longitude: number;
    urgency: 'NORMAL' | 'URGENT' | 'CRITICAL';
    disease: string;
    createdAt: Date;
}

export interface HeatmapData {
    zone: string;
    count: number;
    urgencyBreakdown: {
        normal: number;
        urgent: number;
        critical: number;
    };
}

export interface MapData {
    healthCenters: HealthCenter[];
    caseReports: CaseReport[];
    heatmapData: HeatmapData[];
}

export interface MapFilters {
    startDate?: string;
    endDate?: string;
    disease?: string;
    zone?: string;
    urgency?: 'NORMAL' | 'URGENT' | 'CRITICAL';
}

export const MapService = {
    getMapData: async (filters?: MapFilters): Promise<MapData> => {
        try {
            const response = await api.get("/stats/map-data", { params: filters });
            return response.data.data || response.data;
        } catch (error) {
            console.error("Error fetching map data:", error);
            throw error;
        }
    },
};

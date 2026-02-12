import api from "@/lib/api";

export interface ReportTemplate {
    id: string;
    name: string;
    description: string;
    type: "WEEKLY" | "MONTHLY" | "QUARTERLY" | "ANNUAL";
}

export interface GenerateReportRequest {
    templateId: string;
    startDate: string;
    endDate: string;
    zone?: string;
    format: "PDF" | "CSV";
}

export interface EpidemiologyStats {
    zone: string;
    totalCases: number;
    diseases: {
        name: string;
        count: number;
        trend: "UP" | "DOWN" | "STABLE";
    }[];
}

export interface ExportRawDataParams {
    entity: "patients" | "consultations" | "case-reports" | "vaccinations";
    startDate?: string;
    endDate?: string;
    zone?: string;
}

export const ReportService = {
    getTemplates: async (): Promise<ReportTemplate[]> => {
        try {
            const response = await api.get("/reports/templates");
            return response.data.data?.templates || response.data.templates || response.data.data || response.data;
        } catch (error) {
            console.error("Error fetching report templates:", error);
            throw error;
        }
    },

    generateReport: async (data: GenerateReportRequest): Promise<Blob> => {
        try {
            const response = await api.post("/reports/generate", data, {
                responseType: "blob",
            });
            return response.data;
        } catch (error) {
            console.error("Error generating report:", error);
            throw error;
        }
    },

    exportRawData: async (params: ExportRawDataParams): Promise<Blob> => {
        try {
            const response = await api.get("/reports/export/raw", {
                params,
                responseType: "blob",
            });
            return response.data;
        } catch (error) {
            console.error("Error exporting raw data:", error);
            throw error;
        }
    },

    getEpidemiologyStats: async (startDate?: string, endDate?: string): Promise<EpidemiologyStats[]> => {
        try {
            const response = await api.get("/reports/epidemiology", {
                params: { startDate, endDate },
            });
            return response.data.data?.stats || response.data.stats || response.data.data || response.data;
        } catch (error) {
            console.error("Error fetching epidemiology stats:", error);
            throw error;
        }
    },
};

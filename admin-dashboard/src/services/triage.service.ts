import api from "@/lib/api";

type TriageUrgency = "URGENT" | "ELEVEE" | "MODEREE" | "FAIBLE" | "ROUTINE";

// Define the TriageReport type based on the backend schema
export type TriageReport = {
    id: string;
    patientId: string | null;
    createdBy: string;
    symptoms: string[];
    aiDiagnosticName: string | null;
    aiDiagnosticReasoning: string | null;
    aiConfidenceScore: number | null;
    urgencyLevel: TriageUrgency | null;
    medicalProtocolId: string | null;
    createdAt: string;
    updatedAt: string;
    validationStatus: "PENDING" | "VALIDATED" | "REJECTED";
    validatedBy: string | null;
    validatedAt: string | null;
    // Relations that might be included
    patient?: {
        id: string;
        firstName: string;
        lastName: string;
    };
    creator?: {
        id: string;
        firstName: string;
        lastName: string;
    };
    protocol?: {
        id: string;
        name: string;
    };
};

export const TriageService = {
    getAll: async (): Promise<TriageReport[]> => {
        try {
            // Note: Adjust the endpoint to match your actual NestJS backend route
            const response = await api.get("/case-reports");
            return response.data.data?.caseReports || response.data.caseReports || response.data.data || response.data;
        } catch (error) {
            console.error("Error fetching triage reports:", error);
            throw error;
        }
    },

    getById: async (id: string): Promise<TriageReport> => {
        try {
            const response = await api.get(`/case-reports/${id}`);
            return response.data.data?.caseReport || response.data.caseReport || response.data.data || response.data;
        } catch (error) {
            console.error("Error fetching triage report:", error);
            throw error;
        }
    },

    updateValidationStatus: async (id: string, status: "VALIDATED" | "REJECTED"): Promise<void> => {
        try {
            await api.patch(`/case-reports/${id}/validation`, { status });
        } catch (error) {
            console.error("Error updating validation status:", error);
            throw error;
        }
    },

    delete: async (id: string): Promise<void> => {
        try {
            await api.delete(`/case-reports/${id}`);
        } catch (error) {
            console.error("Error deleting triage report:", error);
            throw error;
        }
    },
};

import api from "@/lib/api";

export interface SMS {
    id: string;
    to: string;
    message: string;
    status: 'SENT' | 'DELIVERED' | 'FAILED';
    direction: 'OUTBOUND' | 'INBOUND';
    createdAt: string;
    patientId?: string;
    patient?: {
        firstName: string;
        lastName: string;
    };
    agentId?: string;
    agent?: {
        name: string;
    };
}

export interface SendSMSRequest {
    to: string;
    message: string;
    patientId?: string;
}

export const SMSService = {
    /**
     * Send a new SMS
     */
    send: async (data: SendSMSRequest): Promise<SMS> => {
        try {
            const response = await api.post("/sms/send", data);
            return response.data.data?.sms || response.data.sms || response.data.data || response.data;
        } catch (error) {
            console.error("Error sending SMS:", error);
            throw error;
        }
    },

    /**
     * Get SMS history for the current user (Agent/Doctor)
     */
    getMyHistory: async (): Promise<SMS[]> => {
        try {
            const response = await api.get("/sms/history/me");
            return response.data.data?.history || response.data.history || response.data.data || response.data;
        } catch (error) {
            console.error("Error fetching SMS history:", error);
            throw error;
        }
    },

    /**
     * Get SMS history for a specific patient
     */
    getPatientHistory: async (patientId: string): Promise<SMS[]> => {
        try {
            const response = await api.get(`/sms/history/patient/${patientId}`);
            return response.data.data?.history || response.data.history || response.data.data || response.data;
        } catch (error) {
            console.error("Error fetching patient SMS history:", error);
            throw error;
        }
    }
};

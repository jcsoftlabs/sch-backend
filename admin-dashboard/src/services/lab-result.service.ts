import api from '@/lib/api';

export type LabTestType =
    | 'MALARIA_RDT'
    | 'HIV_RDT'
    | 'BLOOD_GLUCOSE'
    | 'HEMOGLOBIN'
    | 'PREGNANCY_TEST'
    | 'URINALYSIS'
    | 'STOOL_EXAM'
    | 'OTHER';

export interface LabResult {
    id: string;
    patientId: string;
    testType: LabTestType;
    testName: string;
    result: string;
    unit?: string;
    referenceRange?: string;
    isAbnormal: boolean;
    performedBy?: string;
    performedAt: string;
    notes?: string;
    createdAt: string;
    patient?: {
        id: string;
        firstName: string;
        lastName: string;
    };
}

export interface CreateLabResultDTO {
    patientId: string;
    testType: LabTestType;
    testName: string;
    result: string;
    unit?: string;
    referenceRange?: string;
    isAbnormal?: boolean;
    performedBy?: string;
    performedAt?: string;
    notes?: string;
}

export interface UpdateLabResultDTO {
    testName?: string;
    result?: string;
    unit?: string;
    referenceRange?: string;
    isAbnormal?: boolean;
    performedBy?: string;
    performedAt?: string;
    notes?: string;
}

export const LabResultService = {
    async getByPatient(
        patientId: string,
        options?: { testType?: LabTestType; abnormal?: boolean }
    ): Promise<LabResult[]> {
        const response = await api.get(`/lab-results/patient/${patientId}`, {
            params: options,
        });
        return response.data.data.results;
    },

    async getById(id: string): Promise<LabResult> {
        const response = await api.get(`/lab-results/${id}`);
        return response.data.data.result;
    },

    async create(data: CreateLabResultDTO): Promise<LabResult> {
        const response = await api.post('/lab-results', data);
        return response.data.data.result;
    },

    async update(id: string, data: UpdateLabResultDTO): Promise<LabResult> {
        const response = await api.put(`/lab-results/${id}`, data);
        return response.data.data.result;
    },

    async delete(id: string): Promise<void> {
        await api.delete(`/lab-results/${id}`);
    },

    async getRecentByType(testType: LabTestType, limit = 10): Promise<LabResult[]> {
        const response = await api.get(`/lab-results/recent/${testType}`, {
            params: { limit },
        });
        return response.data.data.results;
    },
};

import api from '@/lib/api';

export interface Diagnosis {
    id: string;
    patientId: string;
    doctorId?: string;
    disease: string;
    icd10Code?: string;
    severity?: string;
    status: string;
    diagnosedAt: string;
    resolvedAt?: string;
    notes?: string;
    createdAt: string;
    updatedAt: string;
    patient?: {
        id: string;
        firstName: string;
        lastName: string;
    };
    doctor?: {
        id: string;
        name: string;
        email: string;
    };
}

export interface CreateDiagnosisDTO {
    patientId: string;
    doctorId?: string;
    disease: string;
    icd10Code?: string;
    severity?: string;
    status?: string;
    diagnosedAt?: string;
    notes?: string;
}

export interface UpdateDiagnosisDTO {
    disease?: string;
    icd10Code?: string;
    severity?: string;
    status?: string;
    resolvedAt?: string;
    notes?: string;
}

export const DiagnosisService = {
    async getByPatient(patientId: string, activeOnly = false): Promise<Diagnosis[]> {
        const response = await api.get(`/diagnoses/patient/${patientId}`, {
            params: { active: activeOnly },
        });
        return response.data.data.diagnoses;
    },

    async getById(id: string): Promise<Diagnosis> {
        const response = await api.get(`/diagnoses/${id}`);
        return response.data.data.diagnosis;
    },

    async create(data: CreateDiagnosisDTO): Promise<Diagnosis> {
        const response = await api.post('/diagnoses', data);
        return response.data.data.diagnosis;
    },

    async update(id: string, data: UpdateDiagnosisDTO): Promise<Diagnosis> {
        const response = await api.put(`/diagnoses/${id}`, data);
        return response.data.data.diagnosis;
    },

    async resolve(id: string): Promise<Diagnosis> {
        const response = await api.patch(`/diagnoses/${id}/resolve`);
        return response.data.data.diagnosis;
    },

    async delete(id: string): Promise<void> {
        await api.delete(`/diagnoses/${id}`);
    },

    async search(disease: string): Promise<Diagnosis[]> {
        const response = await api.get('/diagnoses/search', {
            params: { disease },
        });
        return response.data.data.diagnoses;
    },
};

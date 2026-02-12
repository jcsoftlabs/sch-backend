import api from '@/lib/api';

export interface Prescription {
    id: string;
    patientId: string;
    doctorId?: string;
    medication: string;
    dosage: string;
    frequency: string;
    duration: string;
    instructions?: string;
    startDate: string;
    endDate?: string;
    status: 'ACTIVE' | 'COMPLETED' | 'CANCELLED' | 'EXPIRED';
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

export interface CreatePrescriptionDTO {
    patientId: string;
    doctorId?: string;
    medication: string;
    dosage: string;
    frequency: string;
    duration: string;
    instructions?: string;
    startDate?: string;
    endDate?: string;
    status?: 'ACTIVE' | 'COMPLETED' | 'CANCELLED' | 'EXPIRED';
    notes?: string;
}

export interface UpdatePrescriptionDTO {
    medication?: string;
    dosage?: string;
    frequency?: string;
    duration?: string;
    instructions?: string;
    endDate?: string;
    status?: 'ACTIVE' | 'COMPLETED' | 'CANCELLED' | 'EXPIRED';
    notes?: string;
}

export const PrescriptionService = {
    async getByPatient(patientId: string, activeOnly = false): Promise<Prescription[]> {
        const response = await api.get(`/prescriptions/patient/${patientId}`, {
            params: { active: activeOnly },
        });
        return response.data.data.prescriptions;
    },

    async getById(id: string): Promise<Prescription> {
        const response = await api.get(`/prescriptions/${id}`);
        return response.data.data.prescription;
    },

    async create(data: CreatePrescriptionDTO): Promise<Prescription> {
        const response = await api.post('/prescriptions', data);
        return response.data.data.prescription;
    },

    async update(id: string, data: UpdatePrescriptionDTO): Promise<Prescription> {
        const response = await api.put(`/prescriptions/${id}`, data);
        return response.data.data.prescription;
    },

    async updateStatus(id: string, status: Prescription['status']): Promise<Prescription> {
        const response = await api.patch(`/prescriptions/${id}/status`, { status });
        return response.data.data.prescription;
    },

    async delete(id: string): Promise<void> {
        await api.delete(`/prescriptions/${id}`);
    },
};

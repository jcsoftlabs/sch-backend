import api from '@/lib/api';

export interface EmergencyContact {
    id: string;
    patientId: string;
    name: string;
    relationship: string;
    phone: string;
    address?: string;
    isPrimary: boolean;
    createdAt: string;
    updatedAt: string;
    patient?: {
        id: string;
        firstName: string;
        lastName: string;
    };
}

export interface CreateEmergencyContactDTO {
    patientId: string;
    name: string;
    relationship: string;
    phone: string;
    address?: string;
    isPrimary?: boolean;
}

export interface UpdateEmergencyContactDTO {
    name?: string;
    relationship?: string;
    phone?: string;
    address?: string;
    isPrimary?: boolean;
}

export const EmergencyContactService = {
    async getByPatient(patientId: string): Promise<EmergencyContact[]> {
        const response = await api.get(`/emergency-contacts/patient/${patientId}`);
        return response.data.data.contacts;
    },

    async getPrimary(patientId: string): Promise<EmergencyContact | null> {
        const response = await api.get(`/emergency-contacts/patient/${patientId}/primary`);
        return response.data.data.contact;
    },

    async getById(id: string): Promise<EmergencyContact> {
        const response = await api.get(`/emergency-contacts/${id}`);
        return response.data.data.contact;
    },

    async create(data: CreateEmergencyContactDTO): Promise<EmergencyContact> {
        const response = await api.post('/emergency-contacts', data);
        return response.data.data.contact;
    },

    async update(id: string, data: UpdateEmergencyContactDTO): Promise<EmergencyContact> {
        const response = await api.put(`/emergency-contacts/${id}`, data);
        return response.data.data.contact;
    },

    async setPrimary(id: string): Promise<EmergencyContact> {
        const response = await api.patch(`/emergency-contacts/${id}/primary`);
        return response.data.data.contact;
    },

    async delete(id: string): Promise<void> {
        await api.delete(`/emergency-contacts/${id}`);
    },
};

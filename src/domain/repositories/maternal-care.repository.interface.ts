import { MaternalCare } from '@prisma/client';

export interface IMaternalCareRepository {
    create(data: Omit<MaternalCare, 'id' | 'createdAt' | 'updatedAt'>): Promise<MaternalCare>;
    findById(id: string): Promise<MaternalCare | null>;
    findByPatientId(patientId: string): Promise<MaternalCare[]>;
    findHighRisk(): Promise<MaternalCare[]>;
    findAll(): Promise<MaternalCare[]>;
    update(id: string, data: Partial<MaternalCare>): Promise<MaternalCare>;
    delete(id: string): Promise<MaternalCare>;
}

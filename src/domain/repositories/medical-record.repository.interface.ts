import { MedicalRecord } from '@prisma/client';

export interface IMedicalRecordRepository {
    create(data: Omit<MedicalRecord, 'id' | 'createdAt' | 'updatedAt'>): Promise<MedicalRecord>;
    findById(id: string): Promise<MedicalRecord | null>;
    findByPatientId(patientId: string): Promise<MedicalRecord | null>;
    update(id: string, data: Partial<MedicalRecord>): Promise<MedicalRecord>;
    delete(id: string): Promise<MedicalRecord>;
}

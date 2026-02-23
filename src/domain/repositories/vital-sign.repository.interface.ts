import { VitalSign } from '@prisma/client';

export interface IVitalSignRepository {
    create(data: Omit<VitalSign, 'id' | 'recordedAt'>): Promise<VitalSign>;
    findById(id: string): Promise<VitalSign | null>;
    findByMedicalRecordId(medicalRecordId: string): Promise<VitalSign[]>;
    delete(id: string): Promise<VitalSign>;
}

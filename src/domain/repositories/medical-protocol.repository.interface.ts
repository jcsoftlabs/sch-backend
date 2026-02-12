import { MedicalProtocol } from '@prisma/client';

export interface IMedicalProtocolRepository {
    findAll(): Promise<MedicalProtocol[]>;
    findById(id: string): Promise<MedicalProtocol | null>;
    findByDisease(disease: string): Promise<MedicalProtocol[]>;
    create(data: Omit<MedicalProtocol, 'id' | 'createdAt' | 'updatedAt'>): Promise<MedicalProtocol>;
    update(id: string, data: Partial<MedicalProtocol>): Promise<MedicalProtocol>;
    delete(id: string): Promise<void>;
}

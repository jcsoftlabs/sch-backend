import { MedicalProtocol } from '@prisma/client';
import { MedicalProtocolRepository } from '../../infrastructure/repositories/medical-protocol.repository';

export class MedicalProtocolService {
    private repository = new MedicalProtocolRepository();

    async getAll(): Promise<MedicalProtocol[]> {
        return this.repository.findAll();
    }

    async getById(id: string): Promise<MedicalProtocol | null> {
        return this.repository.findById(id);
    }

    async getByDisease(disease: string): Promise<MedicalProtocol[]> {
        return this.repository.findByDisease(disease);
    }

    async create(data: Omit<MedicalProtocol, 'id' | 'createdAt' | 'updatedAt'>): Promise<MedicalProtocol> {
        return this.repository.create(data);
    }

    async update(id: string, data: Partial<MedicalProtocol>): Promise<MedicalProtocol> {
        return this.repository.update(id, data);
    }

    async delete(id: string): Promise<void> {
        return this.repository.delete(id);
    }
}

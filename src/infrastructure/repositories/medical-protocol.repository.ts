import { MedicalProtocol } from '@prisma/client';
import { prisma } from '../database/prisma';
import { IMedicalProtocolRepository } from '../../domain/repositories/medical-protocol.repository.interface';

export class MedicalProtocolRepository implements IMedicalProtocolRepository {
    async findAll(): Promise<MedicalProtocol[]> {
        return prisma.medicalProtocol.findMany({ orderBy: { name: 'asc' } });
    }

    async findById(id: string): Promise<MedicalProtocol | null> {
        return prisma.medicalProtocol.findUnique({ where: { id } });
    }

    async findByDisease(disease: string): Promise<MedicalProtocol[]> {
        return prisma.medicalProtocol.findMany({
            where: {
                OR: [
                    { name: { contains: disease, mode: 'insensitive' } },
                    { keywords: { has: disease } }
                ]
            },
        });
    }

    async create(data: Omit<MedicalProtocol, 'id' | 'createdAt' | 'updatedAt'>): Promise<MedicalProtocol> {
        return prisma.medicalProtocol.create({ data });
    }

    async update(id: string, data: Partial<MedicalProtocol>): Promise<MedicalProtocol> {
        return prisma.medicalProtocol.update({ where: { id }, data });
    }

    async delete(id: string): Promise<void> {
        await prisma.medicalProtocol.delete({ where: { id } });
    }
}

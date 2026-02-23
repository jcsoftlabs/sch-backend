import { VitalSign } from '@prisma/client';
import { prisma } from '../database/prisma';
import { IVitalSignRepository } from '../../domain/repositories/vital-sign.repository.interface';

export class VitalSignRepository implements IVitalSignRepository {
    async create(data: Omit<VitalSign, 'id' | 'recordedAt'>): Promise<VitalSign> {
        return prisma.vitalSign.create({ data });
    }

    async findById(id: string): Promise<VitalSign | null> {
        return prisma.vitalSign.findUnique({ where: { id } });
    }

    async findByMedicalRecordId(medicalRecordId: string): Promise<VitalSign[]> {
        return prisma.vitalSign.findMany({
            where: { medicalRecordId },
            orderBy: { recordedAt: 'desc' },
            include: { agent: true }
        });
    }

    async delete(id: string): Promise<VitalSign> {
        return prisma.vitalSign.delete({ where: { id } });
    }
}

import { MaternalCare } from '@prisma/client';
import { prisma } from '../database/prisma';
import { IMaternalCareRepository } from '../../domain/repositories/maternal-care.repository.interface';

export class MaternalCareRepository implements IMaternalCareRepository {
    async create(data: Omit<MaternalCare, 'id' | 'createdAt' | 'updatedAt'>): Promise<MaternalCare> {
        return prisma.maternalCare.create({ data });
    }
    async findById(id: string): Promise<MaternalCare | null> {
        return prisma.maternalCare.findUnique({ where: { id }, include: { patient: true } });
    }
    async findByPatientId(patientId: string): Promise<MaternalCare[]> {
        return prisma.maternalCare.findMany({
            where: { patientId },
            orderBy: { createdAt: 'desc' },
            include: { patient: true }
        });
    }
    async findHighRisk(): Promise<MaternalCare[]> {
        return prisma.maternalCare.findMany({
            where: { riskLevel: { in: ['HIGH', 'CRITICAL'] }, deliveryDate: null },
            include: { patient: true },
            orderBy: { expectedDelivery: 'asc' }
        });
    }
    async findAll(): Promise<MaternalCare[]> {
        return prisma.maternalCare.findMany({ include: { patient: true }, orderBy: { createdAt: 'desc' } });
    }
    async update(id: string, data: Partial<MaternalCare>): Promise<MaternalCare> {
        return prisma.maternalCare.update({ where: { id }, data });
    }
    async delete(id: string): Promise<MaternalCare> {
        return prisma.maternalCare.delete({ where: { id } });
    }
}

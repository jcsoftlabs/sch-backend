import { HealthCenter, Prisma } from '@prisma/client';
import { prisma } from '../database/prisma';
import { IHealthCenterRepository } from '../../domain/repositories/health-center.repository.interface';

export class HealthCenterRepository implements IHealthCenterRepository {
    async create(data: Prisma.HealthCenterCreateInput): Promise<HealthCenter> {
        return prisma.healthCenter.create({ data });
    }

    async findAll(): Promise<HealthCenter[]> {
        return prisma.healthCenter.findMany();
    }

    async findById(id: string): Promise<HealthCenter | null> {
        return prisma.healthCenter.findUnique({ where: { id } });
    }

    async update(id: string, data: Prisma.HealthCenterUpdateInput): Promise<HealthCenter> {
        return prisma.healthCenter.update({ where: { id }, data });
    }

    async delete(id: string): Promise<HealthCenter> {
        return prisma.healthCenter.delete({ where: { id } });
    }
}

import { EpidemiologicalAlert, AlertStatus } from '@prisma/client';
import { prisma } from '../database/prisma';
import { IEpidemiologicalAlertRepository } from '../../domain/repositories/epidemiological-alert.repository.interface';

export class EpidemiologicalAlertRepository implements IEpidemiologicalAlertRepository {
    async findAll(): Promise<EpidemiologicalAlert[]> {
        return prisma.epidemiologicalAlert.findMany({ orderBy: { createdAt: 'desc' } });
    }

    async findById(id: string): Promise<EpidemiologicalAlert | null> {
        return prisma.epidemiologicalAlert.findUnique({ where: { id } });
    }

    async findActive(): Promise<EpidemiologicalAlert[]> {
        return prisma.epidemiologicalAlert.findMany({
            where: { status: 'ACTIVE' },
            orderBy: { severity: 'desc' },
        });
    }

    async findByZone(zone: string): Promise<EpidemiologicalAlert[]> {
        return prisma.epidemiologicalAlert.findMany({
            where: { zone: { contains: zone, mode: 'insensitive' } },
            orderBy: { createdAt: 'desc' },
        });
    }

    async create(data: Omit<EpidemiologicalAlert, 'id' | 'createdAt' | 'updatedAt'>): Promise<EpidemiologicalAlert> {
        return prisma.epidemiologicalAlert.create({ data });
    }

    async update(id: string, data: Partial<EpidemiologicalAlert>): Promise<EpidemiologicalAlert> {
        return prisma.epidemiologicalAlert.update({ where: { id }, data });
    }

    async updateStatus(id: string, status: AlertStatus): Promise<EpidemiologicalAlert> {
        return prisma.epidemiologicalAlert.update({ where: { id }, data: { status } });
    }

    async delete(id: string): Promise<void> {
        await prisma.epidemiologicalAlert.delete({ where: { id } });
    }
}

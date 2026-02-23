import { Vaccination } from '@prisma/client';
import { prisma } from '../database/prisma';
import { IVaccinationRepository } from '../../domain/repositories/vaccination.repository.interface';

export class VaccinationRepository implements IVaccinationRepository {
    async create(data: Omit<Vaccination, 'id' | 'createdAt'>): Promise<Vaccination> {
        return prisma.vaccination.create({ data });
    }
    async findById(id: string): Promise<Vaccination | null> {
        return prisma.vaccination.findUnique({ where: { id }, include: { patient: true, agent: true } });
    }
    async findByPatientId(patientId: string): Promise<Vaccination[]> {
        return prisma.vaccination.findMany({
            where: { patientId },
            orderBy: { dateGiven: 'desc' },
            include: { agent: true }
        });
    }
    async findDueVaccinations(beforeDate: Date): Promise<Vaccination[]> {
        return prisma.vaccination.findMany({
            where: { nextDueDate: { lte: beforeDate, not: null } },
            include: { patient: true, agent: true }
        });
    }

    async getDashboardStats(): Promise<any> {
        const totalGiven = await prisma.vaccination.count();

        const today = new Date();
        const startOfToday = new Date(today.getFullYear(), today.getMonth(), today.getDate());
        const endOfToday = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 1);

        const dueToday = await prisma.vaccination.count({
            where: {
                nextDueDate: {
                    gte: startOfToday,
                    lt: endOfToday
                }
            }
        });

        const overdue = await prisma.vaccination.count({
            where: {
                nextDueDate: {
                    lt: startOfToday
                }
            }
        });

        const vaccinesWithAgent = await prisma.vaccination.findMany({
            include: { agent: true }
        });

        const zoneCounts: Record<string, number> = {};
        for (const v of vaccinesWithAgent) {
            const zone = v.agent.zone || 'Zone Inconnue';
            zoneCounts[zone] = (zoneCounts[zone] || 0) + 1;
        }

        const coverageByZone = Object.keys(zoneCounts).map(zone => ({
            zone,
            count: zoneCounts[zone]
        }));

        // Sort by counts
        coverageByZone.sort((a, b) => b.count - a.count);

        const recentVaccinations = await prisma.vaccination.findMany({
            take: 10,
            orderBy: { createdAt: 'desc' },
            include: { patient: true, agent: true }
        });

        return {
            totalGiven,
            dueToday,
            overdue,
            coverageByZone,
            recentVaccinations
        };
    }

    async findAll(): Promise<Vaccination[]> {
        return prisma.vaccination.findMany({ include: { patient: true, agent: true } });
    }
    async update(id: string, data: Partial<Vaccination>): Promise<Vaccination> {
        return prisma.vaccination.update({ where: { id }, data });
    }
    async delete(id: string): Promise<Vaccination> {
        return prisma.vaccination.delete({ where: { id } });
    }
}

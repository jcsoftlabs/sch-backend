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

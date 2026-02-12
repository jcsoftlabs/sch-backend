import { Patient, Prisma } from '@prisma/client';
import { prisma } from '../database/prisma';
import { IPatientRepository } from '../../domain/repositories/patient.repository.interface';

export class PatientRepository implements IPatientRepository {
    async create(data: Prisma.PatientCreateInput): Promise<Patient> {
        return prisma.patient.create({ data });
    }

    async findAll(): Promise<Patient[]> {
        return prisma.patient.findMany();
    }

    async findById(id: string): Promise<Patient | null> {
        return prisma.patient.findUnique({ where: { id } });
    }

    async update(id: string, data: Prisma.PatientUpdateInput): Promise<Patient> {
        return prisma.patient.update({ where: { id }, data });
    }

    async delete(id: string): Promise<Patient> {
        return prisma.patient.delete({ where: { id } });
    }
}

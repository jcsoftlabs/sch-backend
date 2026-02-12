import { Consultation, Prisma } from '@prisma/client';
import { prisma } from '../database/prisma';
import { IConsultationRepository } from '../../domain/repositories/consultation.repository.interface';

export class ConsultationRepository implements IConsultationRepository {
    async create(data: Prisma.ConsultationCreateInput): Promise<Consultation> {
        return prisma.consultation.create({ data });
    }

    async findAll(): Promise<Consultation[]> {
        return prisma.consultation.findMany({ include: { patient: true, doctor: true } });
    }

    async findById(id: string): Promise<Consultation | null> {
        return prisma.consultation.findUnique({ where: { id }, include: { patient: true, doctor: true } });
    }

    async update(id: string, data: Prisma.ConsultationUpdateInput): Promise<Consultation> {
        return prisma.consultation.update({ where: { id }, data });
    }
}

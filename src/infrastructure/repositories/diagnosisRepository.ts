import { prisma } from '../database/prisma';
import { Diagnosis } from '@prisma/client';

export interface CreateDiagnosisDTO {
    patientId: string;
    doctorId?: string;
    disease: string;
    icd10Code?: string;
    severity?: string;
    status?: string;
    diagnosedAt?: Date;
    notes?: string;
}

export interface UpdateDiagnosisDTO {
    disease?: string;
    icd10Code?: string;
    severity?: string;
    status?: string;
    resolvedAt?: Date;
    notes?: string;
}

export class DiagnosisRepository {
    async findByPatientId(patientId: string): Promise<Diagnosis[]> {
        return prisma.diagnosis.findMany({
            where: { patientId },
            include: {
                patient: {
                    select: {
                        id: true,
                        firstName: true,
                        lastName: true,
                    },
                },
                doctor: {
                    select: {
                        id: true,
                        name: true,
                        email: true,
                    },
                },
            },
            orderBy: { diagnosedAt: 'desc' },
        });
    }

    async findActiveByPatientId(patientId: string): Promise<Diagnosis[]> {
        return prisma.diagnosis.findMany({
            where: {
                patientId,
                status: 'ACTIVE',
            },
            include: {
                doctor: {
                    select: {
                        id: true,
                        name: true,
                    },
                },
            },
            orderBy: { diagnosedAt: 'desc' },
        });
    }

    async findById(id: string): Promise<Diagnosis | null> {
        return prisma.diagnosis.findUnique({
            where: { id },
            include: {
                patient: true,
                doctor: true,
            },
        });
    }

    async create(data: CreateDiagnosisDTO): Promise<Diagnosis> {
        return prisma.diagnosis.create({
            data,
            include: {
                patient: true,
                doctor: true,
            },
        });
    }

    async update(id: string, data: UpdateDiagnosisDTO): Promise<Diagnosis> {
        return prisma.diagnosis.update({
            where: { id },
            data,
            include: {
                patient: true,
                doctor: true,
            },
        });
    }

    async resolve(id: string): Promise<Diagnosis> {
        return prisma.diagnosis.update({
            where: { id },
            data: {
                status: 'RESOLVED',
                resolvedAt: new Date(),
            },
        });
    }

    async delete(id: string): Promise<void> {
        await prisma.diagnosis.delete({
            where: { id },
        });
    }

    async findByDisease(disease: string): Promise<Diagnosis[]> {
        return prisma.diagnosis.findMany({
            where: {
                disease: {
                    contains: disease,
                    mode: 'insensitive',
                },
            },
            include: {
                patient: {
                    select: {
                        id: true,
                        firstName: true,
                        lastName: true,
                    },
                },
            },
        });
    }
}

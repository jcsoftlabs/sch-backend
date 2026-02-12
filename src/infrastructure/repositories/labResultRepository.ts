import { prisma } from '../database/prisma';
import { LabResult, LabTestType } from '@prisma/client';

export interface CreateLabResultDTO {
    patientId: string;
    testType: LabTestType;
    testName: string;
    result: string;
    unit?: string;
    referenceRange?: string;
    isAbnormal?: boolean;
    performedBy?: string;
    performedAt?: Date;
    notes?: string;
}

export interface UpdateLabResultDTO {
    testName?: string;
    result?: string;
    unit?: string;
    referenceRange?: string;
    isAbnormal?: boolean;
    performedBy?: string;
    performedAt?: Date;
    notes?: string;
}

export class LabResultRepository {
    async findByPatientId(patientId: string): Promise<LabResult[]> {
        return prisma.labResult.findMany({
            where: { patientId },
            include: {
                patient: {
                    select: {
                        id: true,
                        firstName: true,
                        lastName: true,
                    },
                },
            },
            orderBy: { performedAt: 'desc' },
        });
    }

    async findByPatientIdAndType(
        patientId: string,
        testType: LabTestType
    ): Promise<LabResult[]> {
        return prisma.labResult.findMany({
            where: {
                patientId,
                testType,
            },
            orderBy: { performedAt: 'desc' },
        });
    }

    async findAbnormalByPatientId(patientId: string): Promise<LabResult[]> {
        return prisma.labResult.findMany({
            where: {
                patientId,
                isAbnormal: true,
            },
            orderBy: { performedAt: 'desc' },
        });
    }

    async findById(id: string): Promise<LabResult | null> {
        return prisma.labResult.findUnique({
            where: { id },
            include: {
                patient: true,
            },
        });
    }

    async create(data: CreateLabResultDTO): Promise<LabResult> {
        return prisma.labResult.create({
            data,
            include: {
                patient: true,
            },
        });
    }

    async update(id: string, data: UpdateLabResultDTO): Promise<LabResult> {
        return prisma.labResult.update({
            where: { id },
            data,
            include: {
                patient: true,
            },
        });
    }

    async delete(id: string): Promise<void> {
        await prisma.labResult.delete({
            where: { id },
        });
    }

    async findRecentByType(
        testType: LabTestType,
        limit: number = 10
    ): Promise<LabResult[]> {
        return prisma.labResult.findMany({
            where: { testType },
            include: {
                patient: {
                    select: {
                        id: true,
                        firstName: true,
                        lastName: true,
                    },
                },
            },
            orderBy: { performedAt: 'desc' },
            take: limit,
        });
    }
}

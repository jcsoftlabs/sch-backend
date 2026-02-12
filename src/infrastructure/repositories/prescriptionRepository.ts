import { prisma } from '../database/prisma';
import { Prescription, PrescriptionStatus } from '@prisma/client';

export interface CreatePrescriptionDTO {
    patientId: string;
    doctorId?: string;
    medication: string;
    dosage: string;
    frequency: string;
    duration: string;
    instructions?: string;
    startDate?: Date;
    endDate?: Date;
    status?: PrescriptionStatus;
    notes?: string;
}

export interface UpdatePrescriptionDTO {
    medication?: string;
    dosage?: string;
    frequency?: string;
    duration?: string;
    instructions?: string;
    endDate?: Date;
    status?: PrescriptionStatus;
    notes?: string;
}

export class PrescriptionRepository {
    async findByPatientId(patientId: string): Promise<Prescription[]> {
        return prisma.prescription.findMany({
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
            orderBy: { createdAt: 'desc' },
        });
    }

    async findById(id: string): Promise<Prescription | null> {
        return prisma.prescription.findUnique({
            where: { id },
            include: {
                patient: true,
                doctor: true,
            },
        });
    }

    async findActiveByPatientId(patientId: string): Promise<Prescription[]> {
        return prisma.prescription.findMany({
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
            orderBy: { startDate: 'desc' },
        });
    }

    async create(data: CreatePrescriptionDTO): Promise<Prescription> {
        return prisma.prescription.create({
            data,
            include: {
                patient: true,
                doctor: true,
            },
        });
    }

    async update(id: string, data: UpdatePrescriptionDTO): Promise<Prescription> {
        return prisma.prescription.update({
            where: { id },
            data,
            include: {
                patient: true,
                doctor: true,
            },
        });
    }

    async updateStatus(id: string, status: PrescriptionStatus): Promise<Prescription> {
        return prisma.prescription.update({
            where: { id },
            data: { status },
        });
    }

    async delete(id: string): Promise<void> {
        await prisma.prescription.delete({
            where: { id },
        });
    }

    async markExpiredPrescriptions(): Promise<number> {
        const result = await prisma.prescription.updateMany({
            where: {
                status: 'ACTIVE',
                endDate: {
                    lt: new Date(),
                },
            },
            data: {
                status: 'EXPIRED',
            },
        });

        return result.count;
    }
}

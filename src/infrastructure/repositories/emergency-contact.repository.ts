import { prisma } from '../database/prisma';
import { EmergencyContact } from '@prisma/client';

export interface CreateEmergencyContactDTO {
    patientId: string;
    name: string;
    relationship: string;
    phone: string;
    address?: string;
    isPrimary?: boolean;
}

export interface UpdateEmergencyContactDTO {
    name?: string;
    relationship?: string;
    phone?: string;
    address?: string;
    isPrimary?: boolean;
}

export class EmergencyContactRepository {
    async findByPatientId(patientId: string): Promise<EmergencyContact[]> {
        return prisma.emergencyContact.findMany({
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
            orderBy: [
                { isPrimary: 'desc' },
                { createdAt: 'asc' },
            ],
        });
    }

    async findById(id: string): Promise<EmergencyContact | null> {
        return prisma.emergencyContact.findUnique({
            where: { id },
            include: {
                patient: true,
            },
        });
    }

    async findPrimaryByPatientId(patientId: string): Promise<EmergencyContact | null> {
        return prisma.emergencyContact.findFirst({
            where: {
                patientId,
                isPrimary: true,
            },
        });
    }

    async create(data: CreateEmergencyContactDTO): Promise<EmergencyContact> {
        // If this is set as primary, unset other primary contacts for this patient
        if (data.isPrimary) {
            await prisma.emergencyContact.updateMany({
                where: {
                    patientId: data.patientId,
                    isPrimary: true,
                },
                data: {
                    isPrimary: false,
                },
            });
        }

        return prisma.emergencyContact.create({
            data,
            include: {
                patient: true,
            },
        });
    }

    async update(id: string, data: UpdateEmergencyContactDTO): Promise<EmergencyContact> {
        const contact = await this.findById(id);

        // If setting as primary, unset other primary contacts
        if (data.isPrimary && contact) {
            await prisma.emergencyContact.updateMany({
                where: {
                    patientId: contact.patientId,
                    isPrimary: true,
                    id: { not: id },
                },
                data: {
                    isPrimary: false,
                },
            });
        }

        return prisma.emergencyContact.update({
            where: { id },
            data,
            include: {
                patient: true,
            },
        });
    }

    async setPrimary(id: string): Promise<EmergencyContact> {
        const contact = await this.findById(id);

        if (contact) {
            // Unset other primary contacts
            await prisma.emergencyContact.updateMany({
                where: {
                    patientId: contact.patientId,
                    isPrimary: true,
                    id: { not: id },
                },
                data: {
                    isPrimary: false,
                },
            });
        }

        return prisma.emergencyContact.update({
            where: { id },
            data: { isPrimary: true },
        });
    }

    async delete(id: string): Promise<void> {
        await prisma.emergencyContact.delete({
            where: { id },
        });
    }
}

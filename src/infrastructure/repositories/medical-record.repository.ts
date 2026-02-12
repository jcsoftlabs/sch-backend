import { MedicalRecord } from '@prisma/client';
import { prisma } from '../database/prisma';
import { IMedicalRecordRepository } from '../../domain/repositories/medical-record.repository.interface';

export class MedicalRecordRepository implements IMedicalRecordRepository {
    async create(data: Omit<MedicalRecord, 'id' | 'createdAt' | 'updatedAt'>): Promise<MedicalRecord> {
        return prisma.medicalRecord.create({ data });
    }
    async findById(id: string): Promise<MedicalRecord | null> {
        return prisma.medicalRecord.findUnique({
            where: { id },
            include: { vitalSigns: { orderBy: { recordedAt: 'desc' }, take: 10 }, patient: true }
        });
    }
    async findByPatientId(patientId: string): Promise<MedicalRecord | null> {
        return prisma.medicalRecord.findUnique({
            where: { patientId },
            include: { vitalSigns: { orderBy: { recordedAt: 'desc' }, take: 10 }, patient: true }
        });
    }
    async update(id: string, data: Partial<MedicalRecord>): Promise<MedicalRecord> {
        return prisma.medicalRecord.update({ where: { id }, data });
    }
    async delete(id: string): Promise<MedicalRecord> {
        return prisma.medicalRecord.delete({ where: { id } });
    }
}

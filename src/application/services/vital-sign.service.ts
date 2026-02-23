import { VitalSignRepository } from '../../infrastructure/repositories/vital-sign.repository';
import { prisma } from '../../infrastructure/database/prisma';
import { AppError } from '../../utils/AppError';

export class VitalSignService {
    constructor(private repo: VitalSignRepository) { }

    async getOrCreateMedicalRecord(patientId: string) {
        let record = await prisma.medicalRecord.findUnique({
            where: { patientId }
        });

        if (!record) {
            record = await prisma.medicalRecord.create({
                data: { patientId }
            });
        }
        return record;
    }

    async createVitalSign(patientId: string, data: any) {
        const record = await this.getOrCreateMedicalRecord(patientId);
        return this.repo.create({ ...data, medicalRecordId: record.id });
    }

    async getVitalSignsByPatient(patientId: string) {
        const record = await prisma.medicalRecord.findUnique({
            where: { patientId }
        });

        if (!record) return [];

        return this.repo.findByMedicalRecordId(record.id);
    }

    async deleteVitalSign(id: string) {
        const vitalSign = await this.repo.findById(id);
        if (!vitalSign) throw new AppError('Vital sign record not found', 404);
        return this.repo.delete(id);
    }
}

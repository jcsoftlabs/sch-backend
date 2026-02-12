import { MedicalRecordRepository } from '../../infrastructure/repositories/medical-record.repository';
import { AppError } from '../../utils/AppError';

export class MedicalRecordService {
    constructor(private repo: MedicalRecordRepository) { }

    async createRecord(data: any) {
        // Check if patient already has a medical record
        const existing = await this.repo.findByPatientId(data.patientId);
        if (existing) throw new AppError('Patient already has a medical record', 409);
        return this.repo.create(data);
    }

    async getRecordById(id: string) {
        const record = await this.repo.findById(id);
        if (!record) throw new AppError('Medical record not found', 404);
        return record;
    }

    async getRecordByPatientId(patientId: string) {
        const record = await this.repo.findByPatientId(patientId);
        if (!record) throw new AppError('Medical record not found for this patient', 404);
        return record;
    }

    async updateRecord(id: string, data: any) {
        await this.getRecordById(id);
        return this.repo.update(id, data);
    }

    async deleteRecord(id: string) {
        await this.getRecordById(id);
        return this.repo.delete(id);
    }
}

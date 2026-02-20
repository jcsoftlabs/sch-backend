import {
    PrescriptionRepository,
    CreatePrescriptionDTO,
    UpdatePrescriptionDTO,
} from '../../infrastructure/repositories/prescription.repository';
import { Prescription, PrescriptionStatus } from '@prisma/client';
import { AppError } from '../../utils/AppError';

export class PrescriptionService {
    constructor(private prescriptionRepo: PrescriptionRepository) { }

    async getPrescriptionsByPatient(patientId: string): Promise<Prescription[]> {
        return this.prescriptionRepo.findByPatientId(patientId);
    }

    async getActivePrescriptionsByPatient(patientId: string): Promise<Prescription[]> {
        return this.prescriptionRepo.findActiveByPatientId(patientId);
    }

    async getPrescriptionById(id: string): Promise<Prescription> {
        const prescription = await this.prescriptionRepo.findById(id);
        if (!prescription) {
            throw new AppError('Prescription not found', 404);
        }
        return prescription;
    }

    async createPrescription(data: CreatePrescriptionDTO): Promise<Prescription> {
        // Calculate end date if not provided
        if (!data.endDate && data.duration) {
            const startDate = data.startDate || new Date();
            data.endDate = this.calculateEndDate(startDate, data.duration);
        }

        return this.prescriptionRepo.create(data);
    }

    async updatePrescription(
        id: string,
        data: UpdatePrescriptionDTO
    ): Promise<Prescription> {
        await this.getPrescriptionById(id); // Verify exists

        // Recalculate end date if duration changed
        if (data.duration) {
            const prescription = await this.prescriptionRepo.findById(id);
            if (prescription) {
                data.endDate = this.calculateEndDate(
                    prescription.startDate,
                    data.duration
                );
            }
        }

        return this.prescriptionRepo.update(id, data);
    }

    async updatePrescriptionStatus(
        id: string,
        status: PrescriptionStatus
    ): Promise<Prescription> {
        await this.getPrescriptionById(id); // Verify exists
        return this.prescriptionRepo.updateStatus(id, status);
    }

    async deletePrescription(id: string): Promise<void> {
        await this.getPrescriptionById(id); // Verify exists
        await this.prescriptionRepo.delete(id);
    }

    async markExpiredPrescriptions(): Promise<number> {
        return this.prescriptionRepo.markExpiredPrescriptions();
    }

    private calculateEndDate(startDate: Date, duration: string): Date {
        const endDate = new Date(startDate);

        // Parse duration (e.g., "7 jours", "2 semaines", "1 mois")
        const match = duration.match(/(\d+)\s*(jour|semaine|mois)/i);

        if (match) {
            const value = parseInt(match[1]);
            const unit = match[2].toLowerCase();

            switch (unit) {
                case 'jour':
                    endDate.setDate(endDate.getDate() + value);
                    break;
                case 'semaine':
                    endDate.setDate(endDate.getDate() + value * 7);
                    break;
                case 'mois':
                    endDate.setMonth(endDate.getMonth() + value);
                    break;
            }
        }

        return endDate;
    }
}

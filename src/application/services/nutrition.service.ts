import { NutritionRepository } from '../../infrastructure/repositories/nutrition.repository';
import { AppError } from '../../utils/AppError';
import { NutritionStatus } from '@prisma/client';

export class NutritionService {
    constructor(private repo: NutritionRepository) { }

    private calculateNutritionStatus(muac: number | null): NutritionStatus {
        if (muac === null || muac === undefined) return NutritionStatus.NORMAL;

        // MUAC scale logic (in mm) typically used for children 6-59 months
        // ≥ 125mm -> Normal
        // 115 - 124mm -> MAM (Moderate Acute Malnutrition)
        // < 115mm -> MAS (Severe Acute Malnutrition)
        if (muac < 115) return NutritionStatus.MAS;
        if (muac < 125) return NutritionStatus.MAM;
        return NutritionStatus.NORMAL;
    }

    async createNutritionRecord(data: any) {
        data.status = this.calculateNutritionStatus(data.muac);
        return this.repo.create(data);
    }

    async getNutritionRecordById(id: string) {
        const record = await this.repo.findById(id);
        if (!record) throw new AppError('Nutrition record not found', 404);
        return record;
    }

    async getNutritionRecordsByPatient(patientId: string) {
        return this.repo.findByPatientId(patientId);
    }

    async updateNutritionRecord(id: string, data: any) {
        await this.getNutritionRecordById(id);

        if (data.muac !== undefined) {
            data.status = this.calculateNutritionStatus(data.muac);
        }
        return this.repo.update(id, data);
    }

    async deleteNutritionRecord(id: string) {
        await this.getNutritionRecordById(id);
        return this.repo.delete(id);
    }
}

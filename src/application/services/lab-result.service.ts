import {
    LabResultRepository,
    CreateLabResultDTO,
    UpdateLabResultDTO,
} from '../../infrastructure/repositories/labResultRepository';
import { LabResult, LabTestType } from '@prisma/client';
import { AppError } from '../../utils/AppError';

export class LabResultService {
    constructor(private labResultRepo: LabResultRepository) { }

    async getResultsByPatient(patientId: string): Promise<LabResult[]> {
        return this.labResultRepo.findByPatientId(patientId);
    }

    async getResultsByPatientAndType(
        patientId: string,
        testType: LabTestType
    ): Promise<LabResult[]> {
        return this.labResultRepo.findByPatientIdAndType(patientId, testType);
    }

    async getAbnormalResults(patientId: string): Promise<LabResult[]> {
        return this.labResultRepo.findAbnormalByPatientId(patientId);
    }

    async getResultById(id: string): Promise<LabResult> {
        const result = await this.labResultRepo.findById(id);
        if (!result) {
            throw new AppError('Lab result not found', 404);
        }
        return result;
    }

    async createLabResult(data: CreateLabResultDTO): Promise<LabResult> {
        // Auto-detect abnormal results based on reference range
        if (!data.isAbnormal && data.referenceRange && data.result) {
            data.isAbnormal = this.detectAbnormal(
                data.result,
                data.referenceRange,
                data.testType
            );
        }

        return this.labResultRepo.create(data);
    }

    async updateLabResult(id: string, data: UpdateLabResultDTO): Promise<LabResult> {
        await this.getResultById(id); // Verify exists

        // Re-detect abnormal if result or reference range changed
        if (data.result || data.referenceRange) {
            const existing = await this.labResultRepo.findById(id);
            if (existing) {
                const result = data.result || existing.result;
                const refRange = data.referenceRange || existing.referenceRange;

                if (refRange) {
                    data.isAbnormal = this.detectAbnormal(
                        result,
                        refRange,
                        existing.testType
                    );
                }
            }
        }

        return this.labResultRepo.update(id, data);
    }

    async deleteLabResult(id: string): Promise<void> {
        await this.getResultById(id); // Verify exists
        await this.labResultRepo.delete(id);
    }

    async getRecentResultsByType(
        testType: LabTestType,
        limit: number = 10
    ): Promise<LabResult[]> {
        return this.labResultRepo.findRecentByType(testType, limit);
    }

    private detectAbnormal(
        result: string,
        referenceRange: string,
        testType: LabTestType
    ): boolean {
        // For RDT tests (Rapid Diagnostic Tests)
        if (
            testType === 'MALARIA_RDT' ||
            testType === 'HIV_RDT' ||
            testType === 'PREGNANCY_TEST'
        ) {
            const normalizedResult = result.toLowerCase();
            return normalizedResult.includes('positif') || normalizedResult.includes('positive');
        }

        // For numeric results
        const numericResult = parseFloat(result);
        if (isNaN(numericResult)) {
            return false; // Can't determine if non-numeric
        }

        // Parse reference range (e.g., "12-16 g/dL", "70-110 mg/dL")
        const rangeMatch = referenceRange.match(/(\d+\.?\d*)\s*-\s*(\d+\.?\d*)/);
        if (rangeMatch) {
            const min = parseFloat(rangeMatch[1]);
            const max = parseFloat(rangeMatch[2]);
            return numericResult < min || numericResult > max;
        }

        return false;
    }
}

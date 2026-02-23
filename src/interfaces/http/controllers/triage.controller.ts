import { Request, Response } from 'express';
import { AppError } from '../../../utils/AppError';
import { TriageAIService } from '../../../application/services/triage-ai.service';

const triageAIService = new TriageAIService();

export class TriageController {
    /**
     * POST /api/triage/analyze
     * Analyze symptoms and return clinical assessment and urgency level
     */
    async analyzeSymptom(req: Request, res: Response) {
        try {
            const { symptoms } = req.body;

            if (!symptoms || typeof symptoms !== 'string') {
                throw new AppError('Symptoms text is required', 400);
            }

            const analysis = await triageAIService.analyzeSymptoms(symptoms);

            res.json({
                status: 'success',
                data: analysis
            });
        } catch (error) {
            console.error('Triage Analysis error:', error);
            if (error instanceof AppError) {
                throw error;
            }
            throw new AppError('Failed to analyze symptoms', 500);
        }
    }
}

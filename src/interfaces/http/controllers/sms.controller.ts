import { Request, Response, NextFunction } from 'express';
import { SMSService } from '../../../application/services/sms.service';

const smsService = new SMSService();

/**
 * Send SMS
 */
export const sendSMS = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { to, message, patientId } = req.body;
        const agentId = (req as any).user?.id;

        const sms = await smsService.sendSMS(to, message, agentId, patientId);

        res.status(201).json(sms);
    } catch (error) {
        next(error);
    }
};

/**
 * Webhook for incoming SMS from Vonage
 */
export const handleWebhook = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const result = await smsService.handleIncomingSMS(req.body);

        // Vonage expects 200 OK
        res.status(200).json({ success: true, result });
    } catch (error) {
        console.error('Webhook error:', error);
        // Still return 200 to avoid Vonage retries
        res.status(200).json({ success: false, error: 'Internal error' });
    }
};

/**
 * Get SMS history for a patient
 */
export const getPatientHistory = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { patientId } = req.params;
        const history = await smsService.getPatientHistory(patientId as string);

        res.json(history);
    } catch (error) {
        next(error);
    }
};

/**
 * Get SMS history for current agent
 */
export const getMyHistory = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const agentId = (req as any).user?.id;
        const history = await smsService.getAgentHistory(agentId);

        res.json(history);
    } catch (error) {
        next(error);
    }
};

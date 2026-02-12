import { z } from 'zod';

export const sendSMSSchema = z.object({
    body: z.object({
        to: z.string().regex(/^\+?509\d{8}$/, 'Invalid Haiti phone number format'),
        message: z.string().min(1).max(1600),
        patientId: z.string().uuid().optional(),
    }),
});

export const webhookSchema = z.object({
    body: z.object({
        msisdn: z.string(),
        to: z.string(),
        text: z.string(),
        messageId: z.string(),
        timestamp: z.string(),
    }),
});

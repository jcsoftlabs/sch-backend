import { z } from 'zod';

export const createVaccinationSchema = z.object({
    body: z.object({
        patientId: z.string().uuid(),
        vaccine: z.string().min(2),
        doseNumber: z.number().int().positive(),
        dateGiven: z.string().datetime(),
        nextDueDate: z.string().datetime().optional(),
        batchNumber: z.string().optional(),
        agentId: z.string().uuid(),
        notes: z.string().optional(),
    }),
});

export const updateVaccinationSchema = z.object({
    params: z.object({
        id: z.string().uuid(),
    }),
    body: z.object({
        vaccine: z.string().min(2).optional(),
        doseNumber: z.number().int().positive().optional(),
        dateGiven: z.string().datetime().optional(),
        nextDueDate: z.string().datetime().optional(),
        batchNumber: z.string().optional(),
        notes: z.string().optional(),
    }),
});

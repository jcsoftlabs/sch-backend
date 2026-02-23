import { z } from 'zod';

export const createNutritionSchema = z.object({
    body: z.object({
        patientId: z.string().uuid(),
        agentId: z.string().uuid(),
        weight: z.number().positive(),
        height: z.number().positive(),
        muac: z.number().positive().optional(),
        notes: z.string().optional(),
    }),
});

export const updateNutritionSchema = z.object({
    params: z.object({
        id: z.string().uuid(),
    }),
    body: z.object({
        weight: z.number().positive().optional(),
        height: z.number().positive().optional(),
        muac: z.number().positive().optional(),
        notes: z.string().optional(),
    }),
});

import { z } from 'zod';
import { RiskLevel } from '@prisma/client';

export const createMaternalCareSchema = z.object({
    body: z.object({
        patientId: z.string().uuid(),
        agentId: z.string().uuid(),
        pregnancyStart: z.string().datetime().optional(),
        expectedDelivery: z.string().datetime().optional(),
        riskLevel: z.nativeEnum(RiskLevel).optional(),
        notes: z.string().optional(),
    }),
});

export const updateMaternalCareSchema = z.object({
    params: z.object({
        id: z.string().uuid(),
    }),
    body: z.object({
        pregnancyStart: z.string().datetime().optional(),
        expectedDelivery: z.string().datetime().optional(),
        prenatalVisits: z.number().int().min(0).optional(),
        riskLevel: z.nativeEnum(RiskLevel).optional(),
        deliveryDate: z.string().datetime().optional(),
        deliveryType: z.string().optional(),
        outcome: z.string().optional(),
        newbornWeight: z.number().positive().optional(),
        notes: z.string().optional(),
    }),
});

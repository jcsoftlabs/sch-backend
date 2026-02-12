import { z } from 'zod';
import { UrgencyLevel } from '@prisma/client';

export const createMedicalProtocolSchema = z.object({
    body: z.object({
        name: z.string().min(3),
        nameKr: z.string().optional(),
        keywords: z.array(z.string()).min(1),
        steps: z.string().min(10), // JSON string
        urgencyLevel: z.nativeEnum(UrgencyLevel).optional(),
        category: z.string().optional(),
    }),
});

export const updateMedicalProtocolSchema = z.object({
    params: z.object({
        id: z.string().uuid(),
    }),
    body: z.object({
        name: z.string().min(3).optional(),
        nameKr: z.string().optional(),
        keywords: z.array(z.string()).min(1).optional(),
        steps: z.string().min(10).optional(),
        urgencyLevel: z.nativeEnum(UrgencyLevel).optional(),
        category: z.string().optional(),
        isActive: z.boolean().optional(),
    }),
});

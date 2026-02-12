import { z } from 'zod';
import { AlertSeverity } from '@prisma/client';

export const createEpidemiologicalAlertSchema = z.object({
    body: z.object({
        title: z.string().min(5),
        description: z.string().min(10),
        disease: z.string().min(2),
        zone: z.string().min(2),
        caseCount: z.number().int().min(1),
        threshold: z.number().int().min(1),
    }),
});

export const updateEpidemiologicalAlertSchema = z.object({
    params: z.object({
        id: z.string().uuid(),
    }),
    body: z.object({
        title: z.string().min(5).optional(),
        description: z.string().min(10).optional(),
        disease: z.string().min(2).optional(),
        zone: z.string().min(2).optional(),
        caseCount: z.number().int().min(1).optional(),
        threshold: z.number().int().min(1).optional(),
        severity: z.nativeEnum(AlertSeverity).optional(),
    }),
});

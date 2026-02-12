import { z } from 'zod';
import { UrgencyLevel, CaseChannel } from '@prisma/client';

export const createCaseReportSchema = z.object({
    body: z.object({
        agentId: z.string().uuid(),
        patientId: z.string().uuid().optional(),
        symptoms: z.string().min(5),
        urgency: z.nativeEnum(UrgencyLevel).optional(),
        channel: z.nativeEnum(CaseChannel).optional(),
        imageUrl: z.string().url().optional(),
    }),
});

export const updateCaseReportSchema = z.object({
    params: z.object({
        id: z.string().uuid(),
    }),
    body: z.object({
        symptoms: z.string().min(5).optional(),
        urgency: z.nativeEnum(UrgencyLevel).optional(),
        notes: z.string().optional(),
    }),
});

export const resolveCaseReportSchema = z.object({
    params: z.object({
        id: z.string().uuid(),
    }),
    body: z.object({
        response: z.string().min(5),
        referral: z.boolean().optional(),
    }),
});

export const assignDoctorSchema = z.object({
    params: z.object({
        id: z.string().uuid(),
    }),
    body: z.object({
        doctorId: z.string().uuid(),
    }),
});

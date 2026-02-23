import { z } from 'zod';
import { AppointmentStatus } from '@prisma/client';

export const createAppointmentSchema = z.object({
    body: z.object({
        patientId: z.string().uuid(),
        agentId: z.string().uuid(),
        doctorId: z.string().uuid().optional(),
        healthCenterId: z.string().uuid().optional(),
        scheduledAt: z.string().datetime(),
        duration: z.number().int().positive().optional(),
        reason: z.string().optional(),
        notes: z.string().optional(),
    }),
});

export const updateAppointmentSchema = z.object({
    params: z.object({
        id: z.string().uuid(),
    }),
    body: z.object({
        scheduledAt: z.string().datetime().optional(),
        duration: z.number().int().positive().optional(),
        reason: z.string().optional(),
        status: z.nativeEnum(AppointmentStatus).optional(),
        notes: z.string().optional(),
    }),
});

export const completeAppointmentSchema = z.object({
    params: z.object({
        id: z.string().uuid(),
    }),
    body: z.object({
        notes: z.string().optional(),
    }),
});

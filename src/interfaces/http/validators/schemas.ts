import { z } from 'zod';

export const registerSchema = z.object({
    body: z.object({
        email: z.string().email(),
        password: z.string().min(8),
        name: z.string().min(2),
        role: z.enum(['ADMIN', 'AGENT', 'DOCTOR']).optional(),
    }),
});

export const loginSchema = z.object({
    body: z.object({
        email: z.string().email(),
        password: z.string(),
    }),
});

export const refreshSchema = z.object({
    body: z.object({
        refreshToken: z.string(),
    }),
});

export const createPatientSchema = z.object({
    body: z.object({
        firstName: z.string().min(2),
        lastName: z.string().min(2),
        dateOfBirth: z.string().datetime(),
        gender: z.string(),
        address: z.string(),
        phone: z.string().optional(),
        healthCenterId: z.string().uuid().optional(),
    }),
});

export const createHealthCenterSchema = z.object({
    body: z.object({
        name: z.string().min(2),
        address: z.string().min(5),
        phone: z.string().optional(),
    }),
});

export const requestConsultationSchema = z.object({
    body: z.object({
        patientId: z.string().uuid(),
        notes: z.string().optional(),
    }),
});

export const updateStatusSchema = z.object({
    body: z.object({
        status: z.enum(['PENDING', 'ACCEPTED', 'COMPLETED', 'CANCELLED']),
    }),
    params: z.object({
        id: z.string().uuid(),
    }),
});

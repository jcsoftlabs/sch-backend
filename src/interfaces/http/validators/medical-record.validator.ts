import { z } from 'zod';

export const createMedicalRecordSchema = z.object({
    body: z.object({
        patientId: z.string().uuid(),
        bloodType: z.enum(['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']).optional(),
        allergies: z.string().optional(),
        height: z.number().positive().optional(),
        weight: z.number().positive().optional(),
        conditions: z.string().optional(),
        notes: z.string().optional(),
    }),
});

export const updateMedicalRecordSchema = z.object({
    params: z.object({
        id: z.string().uuid(),
    }),
    body: z.object({
        bloodType: z.enum(['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']).optional(),
        allergies: z.string().optional(),
        height: z.number().positive().optional(),
        weight: z.number().positive().optional(),
        conditions: z.string().optional(),
        notes: z.string().optional(),
    }),
});

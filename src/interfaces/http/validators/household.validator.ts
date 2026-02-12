import { z } from 'zod';

export const createHouseholdSchema = z.object({
    params: z.object({}),
    query: z.object({}),
    body: z.object({
        address: z.string().min(3),
        gpsLat: z.number().optional(),
        gpsLng: z.number().optional(),
        zone: z.string().min(2),
        agentId: z.string().uuid(),
    }),
});

export const updateHouseholdSchema = z.object({
    params: z.object({
        id: z.string().uuid(),
    }),
    body: z.object({
        address: z.string().min(3).optional(),
        gpsLat: z.number().optional(),
        gpsLng: z.number().optional(),
        zone: z.string().min(2).optional(),
        agentId: z.string().uuid().optional(),
    }),
});

import { z } from 'zod';

export const createVitalSignSchema = z.object({
    body: z.object({
        temperature: z.number().optional(),
        bloodPressureSys: z.number().int().optional(),
        bloodPressureDia: z.number().int().optional(),
        heartRate: z.number().int().optional(),
        respiratoryRate: z.number().int().optional(),
        oxygenSaturation: z.number().optional(),
        agentId: z.string().uuid({ message: "agentId doit être un UUID valide" }),
    }).refine(data =>
        Object.keys(data).length > 1, // Au moins agentId + 1 constante
        { message: "Au moins une constante vitale doit être renseignée" }
    )
});

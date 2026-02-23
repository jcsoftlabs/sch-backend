import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export class NutritionRepository {
    async create(data: any) {
        return prisma.nutritionRecord.create({
            data,
            include: { agent: true }
        });
    }

    async findById(id: string) {
        return prisma.nutritionRecord.findUnique({
            where: { id },
            include: { patient: true, agent: true }
        });
    }

    async findByPatientId(patientId: string) {
        return prisma.nutritionRecord.findMany({
            where: { patientId },
            orderBy: { date: 'desc' },
            include: { agent: true }
        });
    }

    async update(id: string, data: any) {
        return prisma.nutritionRecord.update({
            where: { id },
            data,
            include: { agent: true }
        });
    }

    async delete(id: string) {
        return prisma.nutritionRecord.delete({
            where: { id }
        });
    }
}

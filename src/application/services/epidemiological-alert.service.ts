import { EpidemiologicalAlert, AlertStatus, AlertSeverity } from '@prisma/client';
import { EpidemiologicalAlertRepository } from '../../infrastructure/repositories/epidemiological-alert.repository';
import { prisma } from '../../infrastructure/database/prisma';

export class EpidemiologicalAlertService {
    private repository = new EpidemiologicalAlertRepository();

    async getAll(): Promise<EpidemiologicalAlert[]> {
        return this.repository.findAll();
    }

    async getById(id: string): Promise<EpidemiologicalAlert | null> {
        return this.repository.findById(id);
    }

    async getActive(): Promise<EpidemiologicalAlert[]> {
        return this.repository.findActive();
    }

    async getByZone(zone: string): Promise<EpidemiologicalAlert[]> {
        return this.repository.findByZone(zone);
    }

    async create(data: Omit<EpidemiologicalAlert, 'id' | 'createdAt' | 'updatedAt'>): Promise<EpidemiologicalAlert> {
        // Auto-set severity based on case count threshold
        const severity = await this.calculateSeverity(data.caseCount, data.disease);
        return this.repository.create({ ...data, severity });
    }

    async update(id: string, data: Partial<EpidemiologicalAlert>): Promise<EpidemiologicalAlert> {
        return this.repository.update(id, data);
    }

    async resolve(id: string): Promise<EpidemiologicalAlert> {
        return this.repository.updateStatus(id, 'RESOLVED');
    }

    async delete(id: string): Promise<void> {
        return this.repository.delete(id);
    }

    async getConfig(): Promise<any> {
        const config = await prisma.alertConfiguration.findFirst({
            orderBy: { updatedAt: 'desc' }
        });

        if (!config) {
            // Return default if no config exists
            return {
                diseases: [
                    {
                        name: 'Cholera',
                        thresholds: { low: 5, medium: 10, high: 20, critical: 30 }
                    },
                    {
                        name: 'Dengue',
                        thresholds: { low: 3, medium: 7, high: 15, critical: 25 }
                    },
                    {
                        name: 'Malaria',
                        thresholds: { low: 10, medium: 20, high: 40, critical: 60 }
                    },
                    {
                        name: 'COVID-19',
                        thresholds: { low: 5, medium: 15, high: 30, critical: 50 }
                    }
                ]
            };
        }

        return JSON.parse(config.config);
    }

    async updateConfig(newConfig: any, userId?: string): Promise<any> {
        return prisma.alertConfiguration.create({
            data: {
                config: JSON.stringify(newConfig),
                updatedBy: userId
            }
        });
    }

    // Automatic severity calculation based on case count
    private async calculateSeverity(caseCount: number, diseaseName: string): Promise<AlertSeverity> {
        const config = await this.getConfig();
        const diseaseConfig = config.diseases.find((d: any) => d.name.toLowerCase() === diseaseName.toLowerCase());

        if (!diseaseConfig) return 'INFO';

        const { thresholds } = diseaseConfig;

        if (caseCount >= thresholds.critical) return 'CRITICAL';
        if (caseCount >= thresholds.high) return 'CRITICAL'; // Map high to critical for severity enum or handle otherwise
        if (caseCount >= thresholds.medium) return 'WARNING';
        return 'INFO';
    }
}

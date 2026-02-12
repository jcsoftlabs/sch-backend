import { HouseholdRepository } from '../../infrastructure/repositories/household.repository';
import { AppError } from '../../utils/AppError';

export class HouseholdService {
    constructor(private householdRepo: HouseholdRepository) { }

    async createHousehold(data: any) {
        return this.householdRepo.create(data);
    }

    async getAllHouseholds() {
        return this.householdRepo.findAll();
    }

    async getHouseholdById(id: string) {
        const household = await this.householdRepo.findById(id);
        if (!household) throw new AppError('Household not found', 404);
        return household;
    }

    async getHouseholdsByAgent(agentId: string) {
        return this.householdRepo.findByAgent(agentId);
    }

    async getHouseholdsByZone(zone: string) {
        return this.householdRepo.findByZone(zone);
    }

    async updateHousehold(id: string, data: any) {
        await this.getHouseholdById(id);
        return this.householdRepo.update(id, data);
    }

    async deleteHousehold(id: string) {
        await this.getHouseholdById(id);
        return this.householdRepo.delete(id);
    }
}

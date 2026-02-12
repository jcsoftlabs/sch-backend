import { Request, Response, NextFunction } from 'express';
import { HouseholdService } from '../../../application/services/household.service';
import { HouseholdRepository } from '../../../infrastructure/repositories/household.repository';

const repo = new HouseholdRepository();
const service = new HouseholdService(repo);

export const getAll = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const households = await service.getAllHouseholds();
        res.status(200).json({ status: 'success', data: { households } });
    } catch (error) { next(error); }
};

export const getById = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const household = await service.getHouseholdById(req.params.id as string);
        res.status(200).json({ status: 'success', data: { household } });
    } catch (error) { next(error); }
};

export const getByAgent = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const households = await service.getHouseholdsByAgent(req.params.agentId as string);
        res.status(200).json({ status: 'success', data: { households } });
    } catch (error) { next(error); }
};

export const getByZone = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const households = await service.getHouseholdsByZone(req.params.zone as string);
        res.status(200).json({ status: 'success', data: { households } });
    } catch (error) { next(error); }
};

export const create = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const household = await service.createHousehold(req.body);
        res.status(201).json({ status: 'success', data: { household } });
    } catch (error) { next(error); }
};

export const update = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const household = await service.updateHousehold(req.params.id as string, req.body);
        res.status(200).json({ status: 'success', data: { household } });
    } catch (error) { next(error); }
};

export const remove = async (req: Request, res: Response, next: NextFunction) => {
    try {
        await service.deleteHousehold(req.params.id as string);
        res.status(204).send();
    } catch (error) { next(error); }
};

import { Request, Response, NextFunction } from 'express';
import { MedicalProtocolService } from '../../../application/services/medical-protocol.service';

const service = new MedicalProtocolService();

export const getAll = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const protocols = await service.getAll();
        res.json(protocols);
    } catch (error) {
        next(error);
    }
};

export const getById = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const protocol = await service.getById(req.params.id as string);
        if (!protocol) return res.status(404).json({ message: 'Protocol not found' });
        res.json(protocol);
    } catch (error) {
        next(error);
    }
};

export const getByDisease = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const protocols = await service.getByDisease(req.params.disease as string);
        res.json(protocols);
    } catch (error) {
        next(error);
    }
};

export const create = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const protocol = await service.create(req.body);
        res.status(201).json(protocol);
    } catch (error) {
        next(error);
    }
};

export const update = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const protocol = await service.update(req.params.id as string, req.body);
        res.json(protocol);
    } catch (error) {
        next(error);
    }
};

export const remove = async (req: Request, res: Response, next: NextFunction) => {
    try {
        await service.delete(req.params.id as string);
        res.status(204).send();
    } catch (error) {
        next(error);
    }
};

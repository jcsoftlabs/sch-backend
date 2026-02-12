import { Request, Response, NextFunction } from 'express';
import { AppointmentService } from '../../../application/services/appointment.service';
import { AppointmentRepository } from '../../../infrastructure/repositories/appointment.repository';

const repo = new AppointmentRepository();
const service = new AppointmentService(repo);

export const getAll = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const appointments = await service.getAllAppointments();
        res.status(200).json({ status: 'success', data: { appointments } });
    } catch (error) { next(error); }
};

export const getById = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const appointment = await service.getAppointmentById(req.params.id as string as string);
        res.status(200).json({ status: 'success', data: { appointment } });
    } catch (error) { next(error); }
};

export const getByPatient = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const appointments = await service.getAppointmentsByPatient(req.params.patientId as string);
        res.status(200).json({ status: 'success', data: { appointments } });
    } catch (error) { next(error); }
};

export const getUpcoming = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const appointments = await service.getUpcomingAppointments();
        res.status(200).json({ status: 'success', data: { appointments } });
    } catch (error) { next(error); }
};

export const create = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const appointment = await service.createAppointment(req.body);
        res.status(201).json({ status: 'success', data: { appointment } });
    } catch (error) { next(error); }
};

export const confirm = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const appointment = await service.confirmAppointment(req.params.id as string as string);
        res.status(200).json({ status: 'success', data: { appointment } });
    } catch (error) { next(error); }
};

export const cancel = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const appointment = await service.cancelAppointment(req.params.id as string as string);
        res.status(200).json({ status: 'success', data: { appointment } });
    } catch (error) { next(error); }
};

export const complete = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const appointment = await service.completeAppointment(req.params.id as string as string, req.body.notes);
        res.status(200).json({ status: 'success', data: { appointment } });
    } catch (error) { next(error); }
};

export const update = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const appointment = await service.updateAppointment(req.params.id as string as string, req.body);
        res.status(200).json({ status: 'success', data: { appointment } });
    } catch (error) { next(error); }
};

export const remove = async (req: Request, res: Response, next: NextFunction) => {
    try {
        await service.deleteAppointment(req.params.id as string as string);
        res.status(204).send();
    } catch (error) { next(error); }
};

import { Request, Response, NextFunction } from 'express';
import { CaseReportService } from '../../../application/services/case-report.service';
import { CaseReportRepository } from '../../../infrastructure/repositories/case-report.repository';

const repo = new CaseReportRepository();
const service = new CaseReportService(repo);

export const getAll = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const caseReports = await service.getAllCaseReports();
        res.status(200).json({ status: 'success', data: { caseReports } });
    } catch (error) { next(error); }
};

export const getById = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const caseReport = await service.getCaseReportById(req.params.id as string);
        res.status(200).json({ status: 'success', data: { caseReport } });
    } catch (error) { next(error); }
};

export const getByAgent = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const caseReports = await service.getCaseReportsByAgent(req.params.agentId as string);
        res.status(200).json({ status: 'success', data: { caseReports } });
    } catch (error) { next(error); }
};

export const getPending = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const caseReports = await service.getPendingCaseReports();
        res.status(200).json({ status: 'success', data: { caseReports } });
    } catch (error) { next(error); }
};

export const create = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const caseReport = await service.createCaseReport(req.body);
        res.status(201).json({ status: 'success', data: { caseReport } });
    } catch (error) { next(error); }
};

export const assignDoctor = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const caseReport = await service.assignDoctor(req.params.id as string, req.body.doctorId);
        res.status(200).json({ status: 'success', data: { caseReport } });
    } catch (error) { next(error); }
};

export const resolve = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const caseReport = await service.resolveCase(req.params.id as string, req.body.response, req.body.referral);
        res.status(200).json({ status: 'success', data: { caseReport } });
    } catch (error) { next(error); }
};

export const update = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const caseReport = await service.updateCaseReport(req.params.id as string, req.body);
        res.status(200).json({ status: 'success', data: { caseReport } });
    } catch (error) { next(error); }
};

export const remove = async (req: Request, res: Response, next: NextFunction) => {
    try {
        await service.deleteCaseReport(req.params.id as string);
        res.status(204).send();
    } catch (error) { next(error); }
};

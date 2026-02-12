import { Request, Response, NextFunction } from 'express';
import { UserService } from '../../application/services/user.service';
import { UserRepository } from '../../infrastructure/repositories/user.repository';

const userRepository = new UserRepository();
const userService = new UserService(userRepository);

export const getAllUsers = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const users = await userService.getAllUsers();
        // Remove passwords from response
        const sanitizedUsers = users.map((user: any) => {
            const { password, ...rest } = user;
            return rest;
        });
        res.status(200).json({ status: 'success', data: { users: sanitizedUsers } });
    } catch (error) {
        next(error);
    }
};

export const getUserById = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const user = await userService.getUserById(id);
        const { password, ...sanitizedUser } = user;
        res.status(200).json({ status: 'success', data: { user: sanitizedUser } });
    } catch (error) {
        next(error);
    }
};

export const createUser = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const user = await userService.createUser(req.body);
        const { password, ...sanitizedUser } = user;
        res.status(201).json({ status: 'success', data: { user: sanitizedUser } });
    } catch (error) {
        next(error);
    }
};

export const updateUser = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        const user = await userService.updateUser(id, req.body);
        const { password, ...sanitizedUser } = user;
        res.status(200).json({ status: 'success', data: { user: sanitizedUser } });
    } catch (error) {
        next(error);
    }
};

export const deleteUser = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { id } = req.params;
        await userService.deleteUser(id);
        res.status(204).send();
    } catch (error) {
        next(error);
    }
};

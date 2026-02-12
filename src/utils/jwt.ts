import jwt from 'jsonwebtoken';
import { config } from '../config';

export const signAccessToken = (payload: object) => {
    return jwt.sign(payload, config.jwtSecret, { expiresIn: '15m' });
};

export const signRefreshToken = (payload: object) => {
    return jwt.sign(payload, config.jwtRefreshSecret, { expiresIn: '7d' });
};

export const verifyAccessToken = (token: string) => {
    return jwt.verify(token, config.jwtSecret);
};

export const verifyRefreshToken = (token: string) => {
    return jwt.verify(token, config.jwtRefreshSecret);
};

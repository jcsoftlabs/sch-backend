export const logger = {
    info: (message: string) => console.log(`[INFO] ${message}`),
    error: (message: string, error?: any) => console.error(`[ERROR] ${message}`, error || ''),
    warn: (message: string) => console.warn(`[WARN] ${message}`),
    debug: (message: string) => {
        if (process.env.NODE_ENV === 'development') {
            console.debug(`[DEBUG] ${message}`);
        }
    },
};

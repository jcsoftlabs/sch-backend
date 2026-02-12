import axios from 'axios';

const api = axios.create({
    baseURL: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000/api',
    headers: {
        'Content-Type': 'application/json',
    },
});

import { useAuthStore } from "@/stores/auth.store";

api.interceptors.request.use((config) => {
    const token = useAuthStore.getState().token;
    console.log("Interceptor - Token from store:", token); // DEBUG
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
});

export default api;

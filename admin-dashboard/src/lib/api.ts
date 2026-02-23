import axios from 'axios';
import { useAuthStore } from "@/stores/auth.store";

const api = axios.create({
    baseURL: process.env.NEXT_PUBLIC_API_URL?.endsWith('/api')
        ? process.env.NEXT_PUBLIC_API_URL
        : `${process.env.NEXT_PUBLIC_API_URL}/api`,
    headers: {
        'Content-Type': 'application/json',
    },
});

api.interceptors.request.use((config) => {
    const token = useAuthStore.getState().token;
    // console.log("Interceptor -- Attaching token:", token ? "Yes" : "No");
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
}, (error) => {
    return Promise.reject(error);
});

api.interceptors.response.use(
    (response) => response,
    (error) => {
        if (error.response?.status === 401) {
            console.warn("Session expired or unauthorized (401). Logging out...");
            useAuthStore.getState().logout();

            if (typeof window !== "undefined") {
                window.location.href = "/login";
            }
        }
        return Promise.reject(error);
    }
);

export default api;

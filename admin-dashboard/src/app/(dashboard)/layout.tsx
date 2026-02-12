"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { useAuthStore } from "@/stores/auth.store";
import { Sidebar } from "@/components/dashboard/Sidebar";
import { Header } from "@/components/dashboard/Header";

export default function DashboardLayout({
    children,
}: {
    children: React.ReactNode;
}) {
    const { token } = useAuthStore();
    const router = useRouter();
    const [isHydrated, setIsHydrated] = useState(false);

    // Wait for Zustand to hydrate from localStorage
    useEffect(() => {
        setIsHydrated(true);
    }, []);

    // Protect routes - only after hydration
    useEffect(() => {
        if (isHydrated && !token) {
            router.push("/login");
        }
    }, [token, router, isHydrated]);

    // Show nothing during hydration to prevent flash
    if (!isHydrated) {
        return (
            <div className="flex items-center justify-center h-screen">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
            </div>
        );
    }

    // Don't render dashboard if no token
    if (!token) {
        return null;
    }

    return (
        <div className="h-full relative">
            <div className="hidden h-full md:flex md:w-72 md:flex-col md:fixed md:inset-y-0 z-[80] bg-gray-900">
                <Sidebar />
            </div>
            <main className="md:pl-72">
                <Header />
                <div className="p-8 pt-6 space-y-4">
                    {children}
                </div>
            </main>
        </div>
    );
}

"use client";

import { useEffect } from "react";
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

    // Protect routes
    useEffect(() => {
        if (!token) {
            router.push("/login");
        }
    }, [token, router]);

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

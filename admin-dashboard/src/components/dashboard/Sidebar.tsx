"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";
import {
    LayoutDashboard,
    Users,
    Building2,
    Video,
    LogOut,
    Menu,
    UserCog,
    Map,
    BarChart3,
    AlertTriangle,
    FileText,
    MessageSquare,
} from "lucide-react";
import { useAuthStore } from "@/stores/auth.store";
import { useRouter } from "next/navigation";
import { Sheet, SheetContent, SheetTrigger } from "@/components/ui/sheet";
import { useState } from "react";

const routes = [
    {
        label: "Vue d'ensemble",
        icon: LayoutDashboard,
        href: "/dashboard",
        color: "text-sky-500",
    },
    {
        label: "Patients",
        icon: Users,
        href: "/dashboard/patients",
        color: "text-violet-500",
    },
    {
        label: "Centres de Santé",
        icon: Building2,
        href: "/dashboard/centers",
        color: "text-pink-700",
    },
    {
        label: "Agents",
        icon: UserCog,
        href: "/dashboard/agents",
        color: "text-green-600",
    },
    {
        label: "Téléconsultations",
        icon: Video,
        href: "/dashboard/consultations",
        color: "text-orange-700",
    },
    {
        label: "Carte Interactive",
        icon: Map,
        href: "/dashboard/map",
        color: "text-blue-500",
    },
    {
        label: "KPIs Agents",
        icon: BarChart3,
        href: "/dashboard/agents-kpi",
        color: "text-cyan-500",
    },
    {
        label: "Alertes",
        icon: AlertTriangle,
        href: "/dashboard/alerts",
        color: "text-red-500",
    },
    {
        label: "Rapports",
        icon: FileText,
        href: "/dashboard/reports",
        color: "text-indigo-500",
    },
    {
        label: "Messages",
        icon: MessageSquare,
        href: "/dashboard/sms",
        color: "text-yellow-500",
    },
];

export function Sidebar() {
    const pathname = usePathname();

    return (
        <div className="space-y-4 py-4 flex flex-col h-full bg-slate-900 text-white">
            <div className="px-3 py-2 flex-1">
                <Link href="/dashboard" className="flex items-center pl-3 mb-14">
                    <h1 className="text-2xl font-bold">SCH Admin</h1>
                </Link>
                <div className="space-y-1">
                    {routes.map((route) => (
                        <Link
                            key={route.href}
                            href={route.href}
                            className={cn(
                                "text-sm group flex p-3 w-full justify-start font-medium cursor-pointer hover:text-white hover:bg-white/10 rounded-lg transition",
                                pathname === route.href ? "text-white bg-white/10" : "text-zinc-400"
                            )}
                        >
                            <div className="flex items-center flex-1">
                                <route.icon className={cn("h-5 w-5 mr-3", route.color)} />
                                {route.label}
                            </div>
                        </Link>
                    ))}
                </div>
            </div>
        </div>
    );
}

export function MobileSidebar() {
    const [open, setOpen] = useState(false);

    return (
        <Sheet open={open} onOpenChange={setOpen}>
            <SheetTrigger asChild>
                <Button variant="ghost" size="icon" className="md:hidden">
                    <Menu />
                </Button>
            </SheetTrigger>
            <SheetContent side="left" className="p-0 bg-slate-900 text-white border-none w-72">
                <Sidebar />
            </SheetContent>
        </Sheet>
    );
}

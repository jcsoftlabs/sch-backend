"use client";

import Link from "next/link";
import Image from "next/image";
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
    User,
    Map,
    BarChart3,
    AlertTriangle,
    FileText,
    MessageSquare,
    Activity,
    Pill,
} from "lucide-react";
import { useAuthStore } from "@/stores/auth.store";
import { useRouter } from "next/navigation";
import { Sheet, SheetContent, SheetTrigger } from "@/components/ui/sheet";
import { useState } from "react";

const navigationGroups = [
    {
        label: "Clinique",
        routes: [
            {
                label: "Vue d'ensemble",
                icon: LayoutDashboard,
                href: "/dashboard",
                color: "text-blue-400",
            },
            {
                label: "Patients",
                icon: Users,
                href: "/dashboard/patients",
                color: "text-violet-400",
            },
            {
                label: "Téléconsultations",
                icon: Video,
                href: "/dashboard/consultations",
                color: "text-orange-400",
            },
        ],
    },
    {
        label: "Administration",
        routes: [
            {
                label: "Centres de Santé",
                icon: Building2,
                href: "/dashboard/centers",
                color: "text-pink-400",
            },
            {
                label: "Agents de Terrain",
                icon: UserCog,
                href: "/dashboard/agents",
                color: "text-green-400",
            },
            {
                label: "Messages SMS",
                icon: MessageSquare,
                href: "/dashboard/sms",
                color: "text-yellow-400",
            },
        ],
    },
    {
        label: "Analytique",
        routes: [
            {
                label: "Carte Interactive",
                icon: Map,
                href: "/dashboard/map",
                color: "text-cyan-400",
            },
            {
                label: "KPIs Agents",
                icon: BarChart3,
                href: "/dashboard/agents-kpi",
                color: "text-indigo-400",
            },
            {
                label: "Alertes Épidémio.",
                icon: AlertTriangle,
                href: "/dashboard/alerts",
                color: "text-red-400",
            },
            {
                label: "Rapports",
                icon: FileText,
                href: "/dashboard/reports",
                color: "text-emerald-400",
            },
        ],
    },
];

export function Sidebar() {
    const pathname = usePathname();

    return (
        <div className="space-y-4 py-4 flex flex-col h-full gradient-sidebar text-white">
            {/* Logo Section */}
            <div className="px-6 py-4 border-b border-slate-700/50">
                <Link href="/dashboard" className="flex items-center gap-3">
                    <div className="w-12 h-12 rounded-lg bg-gradient-mspp flex items-center justify-center">
                        <Activity className="h-7 w-7 text-white" />
                    </div>
                    <div>
                        <h1 className="text-xl font-bold">MSPP</h1>
                        <p className="text-xs text-slate-400 leading-tight">
                            Système de Santé<br />Communautaire
                        </p>
                    </div>
                </Link>
            </div>

            {/* Navigation Groups */}
            <div className="flex-1 px-3 space-y-6 overflow-y-auto scrollbar-thin">
                {navigationGroups.map((group) => (
                    <div key={group.label} className="animate-fade-in">
                        <p className="px-3 text-xs font-semibold text-slate-400 uppercase tracking-wider mb-2">
                            {group.label}
                        </p>
                        <div className="space-y-1">
                            {group.routes.map((route) => (
                                <Link
                                    key={route.href}
                                    href={route.href}
                                    className={cn(
                                        "text-sm group flex p-3 w-full justify-start font-medium cursor-pointer hover:text-white hover:bg-white/10 rounded-lg transition-all duration-200",
                                        pathname === route.href
                                            ? "text-white bg-white/10 shadow-lg"
                                            : "text-slate-300"
                                    )}
                                >
                                    <div className="flex items-center flex-1">
                                        <route.icon className={cn("h-5 w-5 mr-3", route.color)} />
                                        {route.label}
                                    </div>
                                    {pathname === route.href && (
                                        <div className="w-1 h-6 bg-gradient-mspp rounded-full" />
                                    )}
                                </Link>
                            ))}
                        </div>
                    </div>
                ))}
            </div>

            {/* Footer */}
            <div className="px-6 py-4 border-t border-slate-700/50">
                <div className="text-xs text-slate-500 space-y-1">
                    <p className="font-medium">Version 1.0.0</p>
                    <p>© 2026 MSPP Haiti</p>
                    <p className="text-slate-600">Ministère de la Santé Publique</p>
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

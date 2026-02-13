"use client";

import { useAuthStore } from "@/stores/auth.store";
import { useRouter } from "next/navigation";
import { Button } from "@/components/ui/button";
import { LogOut, User, Settings } from "lucide-react";
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { MobileSidebar } from "./Sidebar";
import { Breadcrumbs } from "./Breadcrumbs";
import { NotificationBell } from "./NotificationBell";

export function Header() {
    const router = useRouter();
    const { user, logout } = useAuthStore();

    const handleLogout = () => {
        logout();
        router.push("/login");
    };

    const handleProfile = () => {
        router.push("/dashboard/profile");
    };

    return (
        <div className="border-b bg-white shadow-sm">
            <div className="flex h-16 items-center px-6 gap-4">
                <MobileSidebar />

                {/* Breadcrumbs */}
                <div className="hidden md:block">
                    <Breadcrumbs />
                </div>

                <div className="flex-1" />

                {/* Actions */}
                <div className="flex items-center gap-3">
                    {/* Notifications */}
                    <NotificationBell />

                    {/* User Menu */}
                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <Button variant="ghost" className="relative h-10 px-3 rounded-lg hover:bg-slate-100">
                                <div className="flex items-center gap-3">
                                    <Avatar className="h-8 w-8">
                                        <AvatarImage src="/avatars/01.png" alt="@user" />
                                        <AvatarFallback className="bg-gradient-mspp text-white">
                                            {user?.name?.charAt(0) || "A"}
                                        </AvatarFallback>
                                    </Avatar>
                                    <div className="hidden md:block text-left">
                                        <p className="text-sm font-medium leading-none">{user?.name || "Admin"}</p>
                                        <p className="text-xs text-slate-500 mt-1">
                                            {user?.role || "Administrateur"}
                                        </p>
                                    </div>
                                </div>
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent className="w-56" align="end" forceMount>
                            <DropdownMenuLabel className="font-normal">
                                <div className="flex flex-col space-y-2">
                                    <p className="text-sm font-medium leading-none">{user?.name || "Admin"}</p>
                                    <p className="text-xs leading-none text-muted-foreground">
                                        {user?.email || "admin@mspp.ht"}
                                    </p>
                                    <Badge variant="secondary" className="w-fit text-xs">
                                        {user?.role || "Administrateur"}
                                    </Badge>
                                </div>
                            </DropdownMenuLabel>
                            <DropdownMenuSeparator />
                            <DropdownMenuItem onClick={handleProfile} className="cursor-pointer">
                                <User className="mr-2 h-4 w-4" />
                                <span>Mon Profil</span>
                            </DropdownMenuItem>
                            <DropdownMenuItem className="cursor-pointer">
                                <Settings className="mr-2 h-4 w-4" />
                                <span>Paramètres</span>
                            </DropdownMenuItem>
                            <DropdownMenuSeparator />
                            <DropdownMenuItem onClick={handleLogout} className="text-red-600 focus:text-red-600 cursor-pointer">
                                <LogOut className="mr-2 h-4 w-4" />
                                <span>Se déconnecter</span>
                            </DropdownMenuItem>
                        </DropdownMenuContent>
                    </DropdownMenu>
                </div>
            </div>
        </div>
    );
}

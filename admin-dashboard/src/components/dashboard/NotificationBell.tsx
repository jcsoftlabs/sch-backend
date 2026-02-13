"use client";

import { Bell } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Badge } from "@/components/ui/badge";
import { ScrollArea } from "@/components/ui/scroll-area";

// Mock notifications - will be replaced with real data
const notifications = [
    {
        id: "1",
        title: "Nouvelle alerte épidémiologique",
        message: "Augmentation des cas de cholera dans le Sud",
        time: "Il y a 5 min",
        unread: true,
        type: "alert",
    },
    {
        id: "2",
        title: "Rapport mensuel disponible",
        message: "Le rapport de janvier est prêt à être consulté",
        time: "Il y a 1h",
        unread: true,
        type: "info",
    },
    {
        id: "3",
        title: "Nouveau patient enregistré",
        message: "Jean Baptiste a été ajouté au système",
        time: "Il y a 2h",
        unread: false,
        type: "success",
    },
];

export function NotificationBell() {
    const unreadCount = notifications.filter(n => n.unread).length;

    return (
        <DropdownMenu>
            <DropdownMenuTrigger asChild>
                <Button variant="ghost" size="icon" className="relative">
                    <Bell className="h-5 w-5" />
                    {unreadCount > 0 && (
                        <span className="absolute -top-1 -right-1 h-5 w-5 rounded-full bg-red-500 text-white text-xs flex items-center justify-center font-medium">
                            {unreadCount}
                        </span>
                    )}
                </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end" className="w-80">
                <DropdownMenuLabel className="flex items-center justify-between">
                    <span>Notifications</span>
                    {unreadCount > 0 && (
                        <Badge variant="secondary" className="ml-auto">
                            {unreadCount} nouveau{unreadCount > 1 ? "x" : ""}
                        </Badge>
                    )}
                </DropdownMenuLabel>
                <DropdownMenuSeparator />
                <ScrollArea className="h-[300px]">
                    {notifications.map((notif) => (
                        <DropdownMenuItem
                            key={notif.id}
                            className="flex items-start gap-3 p-3 cursor-pointer"
                        >
                            <div className={`w-2 h-2 rounded-full mt-2 ${notif.unread ? "bg-blue-500" : "bg-transparent"}`} />
                            <div className="flex-1">
                                <p className="text-sm font-medium">{notif.title}</p>
                                <p className="text-xs text-slate-500 mt-1">{notif.message}</p>
                                <p className="text-xs text-slate-400 mt-1">{notif.time}</p>
                            </div>
                        </DropdownMenuItem>
                    ))}
                </ScrollArea>
                <DropdownMenuSeparator />
                <DropdownMenuItem className="text-center justify-center text-sm text-blue-600 hover:text-blue-700 cursor-pointer">
                    Voir toutes les notifications
                </DropdownMenuItem>
            </DropdownMenuContent>
        </DropdownMenu>
    );
}

"use client";

import { Bell, Check, Trash2 } from "lucide-react";
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
import { useEffect, useState } from "react";
import { Notification, NotificationService } from "@/services/notification.service";
import { cn } from "@/lib/utils";
import { useToast } from "@/hooks/use-toast";

export function NotificationBell() {
    const [notifications, setNotifications] = useState<Notification[]>([]);
    const [loading, setLoading] = useState(true);
    const { toast } = useToast();

    const fetchNotifications = async () => {
        try {
            const data = await NotificationService.getAll();
            setNotifications(data);
        } catch (error) {
            console.error("Failed to load notifications", error);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchNotifications();
        // Optional: Poll every 30s
        const interval = setInterval(fetchNotifications, 30000);
        return () => clearInterval(interval);
    }, []);

    const handleMarkAsRead = async (id: string, e: React.MouseEvent) => {
        e.stopPropagation();
        try {
            await NotificationService.markAsRead(id);
            setNotifications(prev => prev.map(n => n.id === id ? { ...n, unread: false } : n));
        } catch (error) {
            console.error("Failed to mark as read", error);
        }
    };

    const handleMarkAllAsRead = async () => {
        try {
            await NotificationService.markAllAsRead();
            setNotifications(prev => prev.map(n => ({ ...n, unread: false })));
            toast({
                title: "Succès",
                description: "Toutes les notifications ont été marquées comme lues",
            });
        } catch (error) {
            console.error("Failed to mark all as read", error);
        }
    };

    const handleClear = async (id: string, e: React.MouseEvent) => {
        e.stopPropagation();
        try {
            await NotificationService.clear(id);
            setNotifications(prev => prev.filter(n => n.id !== id));
        } catch (error) {
            console.error("Failed to clear notification", error);
        }
    };

    const unreadCount = notifications.filter(n => n.unread).length;

    const getIconColor = (type: string) => {
        switch (type) {
            case "alert": return "bg-red-500";
            case "warning": return "bg-amber-500";
            case "success": return "bg-green-500";
            case "info": default: return "bg-blue-500";
        }
    };

    return (
        <DropdownMenu>
            <DropdownMenuTrigger asChild>
                <Button variant="ghost" size="icon" className="relative">
                    <Bell className="h-5 w-5" />
                    {unreadCount > 0 && (
                        <span className="absolute -top-1 -right-1 h-5 w-5 rounded-full bg-red-600 text-white text-[10px] flex items-center justify-center font-bold shadow-sm ring-1 ring-white">
                            {unreadCount}
                        </span>
                    )}
                </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end" className="w-80 md:w-96">
                <DropdownMenuLabel className="flex items-center justify-between py-3">
                    <span className="font-semibold text-base">Notifications</span>
                    <div className="flex items-center gap-2">
                        {unreadCount > 0 && (
                            <Button
                                variant="ghost"
                                size="sm"
                                className="h-6 text-xs px-2"
                                onClick={handleMarkAllAsRead}
                            >
                                <Check className="mr-1 h-3 w-3" /> Tout lire
                            </Button>
                        )}
                    </div>
                </DropdownMenuLabel>
                <DropdownMenuSeparator />
                <ScrollArea className="h-[350px]">
                    {notifications.length === 0 ? (
                        <div className="flex flex-col items-center justify-center h-40 text-center text-slate-500 p-4">
                            <Bell className="h-8 w-8 mb-2 opacity-20" />
                            <p className="text-sm">Aucune notification</p>
                        </div>
                    ) : (
                        notifications.map((notif) => (
                            <DropdownMenuItem
                                key={notif.id}
                                className={cn(
                                    "flex items-start gap-3 p-3 cursor-default focus:bg-accent/50 group relative pr-8",
                                    notif.unread ? "bg-slate-50 border-l-2 border-l-blue-500" : "opacity-80"
                                )}
                            >
                                <div className={cn("mt-1.5 h-2 w-2 rounded-full shrink-0", getIconColor(notif.type))} />
                                <div className="flex-1 space-y-1">
                                    <p className={cn("text-sm leading-none", notif.unread ? "font-semibold text-slate-900" : "font-medium text-slate-700")}>
                                        {notif.title}
                                    </p>
                                    <p className="text-xs text-slate-500 line-clamp-2">
                                        {notif.message}
                                    </p>
                                    <p className="text-[10px] text-slate-400 font-medium pt-1">
                                        {new Date(notif.time).toLocaleString(undefined, {
                                            hour: '2-digit', minute: '2-digit', day: 'numeric', month: 'short'
                                        })}
                                    </p>
                                </div>
                                <div className="absolute right-2 top-2 opacity-0 group-hover:opacity-100 transition-opacity flex flex-col gap-1">
                                    {notif.unread && (
                                        <Button
                                            variant="ghost"
                                            size="icon"
                                            className="h-6 w-6 hover:bg-blue-100 hover:text-blue-600"
                                            onClick={(e) => handleMarkAsRead(notif.id, e)}
                                            title="Marquer comme lu"
                                        >
                                            <div className="h-2 w-2 rounded-full bg-blue-600" />
                                        </Button>
                                    )}
                                    <Button
                                        variant="ghost"
                                        size="icon"
                                        className="h-6 w-6 hover:bg-red-100 hover:text-red-600"
                                        onClick={(e) => handleClear(notif.id, e)}
                                        title="Supprimer"
                                    >
                                        <Trash2 className="h-3 w-3" />
                                    </Button>
                                </div>
                            </DropdownMenuItem>
                        ))
                    )}
                </ScrollArea>
                <DropdownMenuSeparator />
                <DropdownMenuItem className="p-2 text-center justify-center">
                    <Button variant="link" className="h-auto p-0 text-xs text-slate-500 hover:text-primary">
                        Voir tout l'historique
                    </Button>
                </DropdownMenuItem>
            </DropdownMenuContent>
        </DropdownMenu>
    );
}

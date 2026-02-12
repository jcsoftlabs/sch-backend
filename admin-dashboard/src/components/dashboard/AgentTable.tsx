"use client";

import { ColumnDef } from "@tanstack/react-table";
import { Button } from "@/components/ui/button";
import { ArrowUpDown, MoreHorizontal, Pencil, Trash2 } from "lucide-react";
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Agent } from "@/services/agent.service";
import { Badge } from "@/components/ui/badge";

export type { Agent };

export const createColumns = (
    onEdit?: (agent: Agent) => void,
    onDelete?: (id: string) => void
): ColumnDef<Agent>[] => [
        {
            accessorKey: "name",
            header: ({ column }) => {
                return (
                    <Button
                        variant="ghost"
                        onClick={() => column.toggleSorting(column.getIsSorted() === "asc")}
                    >
                        Nom
                        <ArrowUpDown className="ml-2 h-4 w-4" />
                    </Button>
                )
            },
        },
        {
            accessorKey: "email",
            header: "Email",
        },
        {
            accessorKey: "role",
            header: "Rôle",
            cell: ({ row }) => {
                const role = row.getValue("role") as string;
                return <Badge variant="outline">{role}</Badge>;
            },
        },
        {
            accessorKey: "createdAt",
            header: "Date de création",
            cell: ({ row }) => {
                const date = row.getValue("createdAt") as string;
                return date ? new Date(date).toLocaleDateString() : "N/A";
            },
        },
        {
            id: "actions",
            cell: ({ row }) => {
                const agent = row.original

                return (
                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <Button variant="ghost" className="h-8 w-8 p-0">
                                <span className="sr-only">Ouvrir menu</span>
                                <MoreHorizontal className="h-4 w-4" />
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="end">
                            <DropdownMenuLabel>Actions</DropdownMenuLabel>
                            <DropdownMenuItem onClick={() => navigator.clipboard.writeText(agent.id)}>
                                Copier ID
                            </DropdownMenuItem>
                            <DropdownMenuSeparator />
                            {onEdit && (
                                <DropdownMenuItem onClick={() => onEdit(agent)}>
                                    <Pencil className="mr-2 h-4 w-4" />
                                    Modifier
                                </DropdownMenuItem>
                            )}
                            {onDelete && (
                                <DropdownMenuItem
                                    onClick={() => onDelete(agent.id)}
                                    className="text-destructive focus:text-destructive"
                                >
                                    <Trash2 className="mr-2 h-4 w-4" />
                                    Supprimer
                                </DropdownMenuItem>
                            )}
                        </DropdownMenuContent>
                    </DropdownMenu>
                )
            },
        },
    ];

export const columns = createColumns();

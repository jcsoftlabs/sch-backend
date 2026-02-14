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

export type HealthCenter = {
    id: string;
    name: string;
    address: string;
    phone?: string;
    capacity?: number;
    lat?: number;
    lng?: number;
};

export const createColumns = (
    onEdit?: (center: HealthCenter) => void,
    onDelete?: (id: string) => void
): ColumnDef<HealthCenter>[] => [
        {
            accessorKey: "name",
            header: ({ column }) => {
                return (
                    <Button
                        variant="ghost"
                        onClick={() => column.toggleSorting(column.getIsSorted() === "asc")}
                        className="font-bold text-slate-700 hover:text-slate-900"
                    >
                        Nom
                        <ArrowUpDown className="ml-2 h-4 w-4" />
                    </Button>
                )
            },
            cell: ({ row }) => <span className="font-medium text-slate-900">{row.getValue("name")}</span>
        },
        {
            accessorKey: "address",
            header: "Adresse",
        },
        {
            accessorKey: "phone",
            header: "Téléphone",
        },
        {
            accessorKey: "capacity",
            header: "Capacité",
        },
        {
            id: "actions",
            cell: ({ row }) => {
                const center = row.original

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
                            <DropdownMenuItem onClick={() => navigator.clipboard.writeText(center.id)}>
                                Copier ID
                            </DropdownMenuItem>
                            <DropdownMenuSeparator />
                            {onEdit && (
                                <DropdownMenuItem onClick={() => onEdit(center)}>
                                    <Pencil className="mr-2 h-4 w-4" />
                                    Modifier
                                </DropdownMenuItem>
                            )}
                            {onDelete && (
                                <DropdownMenuItem
                                    onClick={() => onDelete(center.id)}
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

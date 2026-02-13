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

export type Patient = {
    id: string;
    firstName: string;
    lastName: string;
    email: string;
    status: "Actif" | "Inactif";
    lastVisit: string;
    // Additional fields for patient details page
    dateOfBirth?: string;
    gender?: "MALE" | "FEMALE";
    phone?: string;
    address?: string;
    bloodType?: string;
    allergies?: string;
};

export const createColumns = (
    onEdit?: (patient: Patient) => void,
    onDelete?: (id: string) => void
): ColumnDef<Patient>[] => [
        {
            accessorKey: "firstName",
            header: "Prénom",
        },
        {
            accessorKey: "lastName",
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
            accessorKey: "status",
            header: "Statut",
            cell: ({ row }) => (
                <div className={row.getValue("status") === "Actif" ? "text-green-600" : "text-gray-500"}>
                    {row.getValue("status")}
                </div>
            )
        },
        {
            accessorKey: "lastVisit",
            header: "Dernière Visite",
        },
        {
            id: "actions",
            cell: ({ row }) => {
                const patient = row.original

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
                            <DropdownMenuItem onClick={() => navigator.clipboard.writeText(patient.id)}>
                                Copier ID
                            </DropdownMenuItem>
                            <DropdownMenuSeparator />
                            {onEdit && (
                                <DropdownMenuItem onClick={() => onEdit(patient)}>
                                    <Pencil className="mr-2 h-4 w-4" />
                                    Modifier
                                </DropdownMenuItem>
                            )}
                            {onDelete && (
                                <DropdownMenuItem
                                    onClick={() => onDelete(patient.id)}
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

// Default columns for backward compatibility
export const columns = createColumns();

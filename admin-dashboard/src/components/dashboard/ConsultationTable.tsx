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
import { Badge } from "@/components/ui/badge";
import { Consultation } from "@/services/consultation.service";

export const createColumns = (
    onEdit?: (consultation: Consultation) => void,
    onDelete?: (id: string) => void
): ColumnDef<Consultation>[] => [
        {
            accessorKey: "patient",
            header: "Patient",
            cell: ({ row }) => {
                const patient = row.original.patient;
                return patient ? `${patient.firstName} ${patient.lastName}` : "N/A";
            },
        },
        {
            accessorKey: "doctor",
            header: "Médecin",
            cell: ({ row }) => {
                const doctor = row.original.doctor;
                return doctor?.name || "Non assigné";
            },
        },
        {
            accessorKey: "status",
            header: "Statut",
            cell: ({ row }) => {
                const status = row.getValue("status") as string;
                const variants: Record<string, "default" | "secondary" | "destructive" | "outline"> = {
                    PENDING: "secondary",
                    ACCEPTED: "default",
                    COMPLETED: "outline",
                    CANCELLED: "destructive",
                };
                const labels: Record<string, string> = {
                    PENDING: "En attente",
                    ACCEPTED: "Acceptée",
                    COMPLETED: "Terminée",
                    CANCELLED: "Annulée",
                };
                return <Badge variant={variants[status] || "default"}>{labels[status] || status}</Badge>;
            },
        },
        {
            accessorKey: "createdAt",
            header: ({ column }) => {
                return (
                    <Button
                        variant="ghost"
                        onClick={() => column.toggleSorting(column.getIsSorted() === "asc")}
                    >
                        Date
                        <ArrowUpDown className="ml-2 h-4 w-4" />
                    </Button>
                )
            },
            cell: ({ row }) => {
                return new Date(row.getValue("createdAt")).toLocaleDateString();
            },
        },
        {
            id: "actions",
            cell: ({ row }) => {
                const consultation = row.original

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
                            <DropdownMenuItem onClick={() => navigator.clipboard.writeText(consultation.id)}>
                                Copier ID
                            </DropdownMenuItem>
                            <DropdownMenuSeparator />
                            {onEdit && (
                                <DropdownMenuItem onClick={() => onEdit(consultation)}>
                                    <Pencil className="mr-2 h-4 w-4" />
                                    Modifier
                                </DropdownMenuItem>
                            )}
                            {onDelete && (
                                <DropdownMenuItem
                                    onClick={() => onDelete(consultation.id)}
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

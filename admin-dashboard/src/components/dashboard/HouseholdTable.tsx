"use client";

import { ColumnDef } from "@tanstack/react-table";
import { Button } from "@/components/ui/button";
import { ArrowUpDown, Eye, Trash2 } from "lucide-react";

export type Household = {
    id: string;
    householdHeadName: string;
    address: string;
    commune?: string;
    phone?: string;
    latitude: number;
    longitude: number;
    createdAt: string;
    _count?: {
        members: number;
    };
};

export const createColumns = (
    onView?: (household: Household) => void,
    onDelete?: (id: string) => void
): ColumnDef<Household>[] => [
        {
            accessorKey: "householdHeadName",
            header: ({ column }) => {
                return (
                    <Button
                        variant="ghost"
                        onClick={() => column.toggleSorting(column.getIsSorted() === "asc")}
                        className="font-bold text-slate-700 hover:text-slate-900"
                    >
                        Chef de Ménage
                        <ArrowUpDown className="ml-2 h-4 w-4" />
                    </Button>
                );
            },
        },
        {
            accessorKey: "address",
            header: "Adresse",
            cell: ({ row }) => (
                <div className="max-w-[200px] truncate" title={row.getValue("address")}>
                    {row.getValue("address")}
                </div>
            )
        },
        {
            accessorKey: "commune",
            header: "Commune",
            cell: ({ row }) => <div>{row.getValue("commune") || "-"}</div>
        },
        {
            id: "members",
            header: "Membres",
            cell: ({ row }) => {
                const household = row.original;
                const count = household._count?.members ?? 0;
                return (
                    <div className="font-medium bg-blue-50 text-blue-700 px-2 py-1 rounded-full inline-flex items-center justify-center text-xs min-w-[24px]">
                        {count}
                    </div>
                );
            }
        },
        {
            accessorKey: "createdAt",
            header: "Date d'enregistrement",
            cell: ({ row }) => {
                const date = new Date(row.getValue("createdAt"));
                return <div>{date.toLocaleDateString('fr-FR')}</div>;
            }
        },
        {
            id: "actions",
            cell: ({ row }) => {
                const household = row.original;

                return (
                    <div className="flex justify-end gap-2">
                        {onView && (
                            <Button
                                variant="ghost"
                                size="icon"
                                onClick={() => onView(household)}
                                title="Voir les détails"
                            >
                                <Eye className="h-4 w-4 text-slate-500 hover:text-blue-600" />
                            </Button>
                        )}
                        {onDelete && (
                            <Button
                                variant="ghost"
                                size="icon"
                                onClick={() => onDelete(household.id)}
                                title="Supprimer"
                                className="hover:bg-red-50 hover:text-red-600"
                            >
                                <Trash2 className="h-4 w-4 text-red-500 hover:text-red-600" />
                            </Button>
                        )}
                    </div>
                );
            },
        },
    ];

export const columns = createColumns();

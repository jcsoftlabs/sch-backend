"use client";

import {
    ColumnDef,
    flexRender,
    getCoreRowModel,
    useReactTable,
    getPaginationRowModel,
    getSortedRowModel,
    SortingState,
} from "@tanstack/react-table";
import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from "@/components/ui/table";
import { Button } from "@/components/ui/button";
import { SMS } from "@/services/sms.service";
import { useState } from "react";
import { format } from "date-fns";
import { fr } from "date-fns/locale";
import { ArrowUpDown, MessageSquare, ArrowUpRight, ArrowDownLeft } from "lucide-react";
import { Badge } from "@/components/ui/badge";

interface SMSHistoryTableProps {
    data: SMS[];
}

export const columns: ColumnDef<SMS>[] = [
    {
        accessorKey: "direction",
        header: "Direction",
        cell: ({ row }) => {
            const direction = row.getValue("direction") as string;
            return (
                <div className="flex items-center">
                    {direction === "OUTBOUND" ? (
                        <ArrowUpRight className="h-4 w-4 text-blue-500 mr-2" />
                    ) : (
                        <ArrowDownLeft className="h-4 w-4 text-green-500 mr-2" />
                    )}
                    <span className="text-xs font-medium">
                        {direction === "OUTBOUND" ? "Envoyé" : "Reçu"}
                    </span>
                </div>
            );
        },
    },
    {
        accessorKey: "to",
        header: "Destinataire",
        cell: ({ row }) => {
            const patient = row.original.patient;
            return (
                <div>
                    <div className="font-medium">{row.getValue("to")}</div>
                    {patient && (
                        <div className="text-xs text-muted-foreground">
                            {patient.firstName} {patient.lastName}
                        </div>
                    )}
                </div>
            );
        },
    },
    {
        accessorKey: "message",
        header: "Message",
        cell: ({ row }) => (
            <div className="max-w-[300px] truncate" title={row.getValue("message")}>
                {row.getValue("message")}
            </div>
        ),
    },
    {
        accessorKey: "status",
        header: "Statut",
        cell: ({ row }) => {
            const status = row.getValue("status") as string;
            return (
                <Badge
                    variant={
                        status === "DELIVERED"
                            ? "default" // Using default (primary) for delivered instead of specific green
                            : status === "SENT"
                                ? "secondary"
                                : "destructive"
                    }
                >
                    {status === "DELIVERED" ? "Délivré" : status === "SENT" ? "Envoyé" : "Échec"}
                </Badge>
            );
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
            );
        },
        cell: ({ row }) => (
            <div className="text-sm">
                {format(new Date(row.getValue("createdAt")), "dd MMM yyyy HH:mm", { locale: fr })}
            </div>
        ),
    },
];

export function SMSHistoryTable({ data }: SMSHistoryTableProps) {
    const [sorting, setSorting] = useState<SortingState>([]);

    const table = useReactTable({
        data,
        columns,
        getCoreRowModel: getCoreRowModel(),
        getPaginationRowModel: getPaginationRowModel(),
        onSortingChange: setSorting,
        getSortedRowModel: getSortedRowModel(),
        state: {
            sorting,
        },
    });

    return (
        <div className="rounded-md border">
            <Table>
                <TableHeader>
                    {table.getHeaderGroups().map((headerGroup) => (
                        <TableRow key={headerGroup.id}>
                            {headerGroup.headers.map((header) => {
                                return (
                                    <TableHead key={header.id}>
                                        {header.isPlaceholder
                                            ? null
                                            : flexRender(
                                                header.column.columnDef.header,
                                                header.getContext()
                                            )}
                                    </TableHead>
                                );
                            })}
                        </TableRow>
                    ))}
                </TableHeader>
                <TableBody>
                    {table.getRowModel().rows?.length ? (
                        table.getRowModel().rows.map((row) => (
                            <TableRow
                                key={row.id}
                                data-state={row.getIsSelected() && "selected"}
                            >
                                {row.getVisibleCells().map((cell) => (
                                    <TableCell key={cell.id}>
                                        {flexRender(cell.column.columnDef.cell, cell.getContext())}
                                    </TableCell>
                                ))}
                            </TableRow>
                        ))
                    ) : (
                        <TableRow>
                            <TableCell colSpan={columns.length} className="h-24 text-center">
                                Aucune donnée disponible.
                            </TableCell>
                        </TableRow>
                    )}
                </TableBody>
            </Table>
            <div className="flex items-center justify-end space-x-2 py-4 px-4">
                <Button
                    variant="outline"
                    size="sm"
                    onClick={() => table.previousPage()}
                    disabled={!table.getCanPreviousPage()}
                >
                    Précédent
                </Button>
                <Button
                    variant="outline"
                    size="sm"
                    onClick={() => table.nextPage()}
                    disabled={!table.getCanNextPage()}
                >
                    Suivant
                </Button>
            </div>
        </div>
    );
}

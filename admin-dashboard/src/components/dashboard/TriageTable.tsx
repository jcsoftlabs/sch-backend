"use client";

import { ColumnDef } from "@tanstack/react-table";
import { Button } from "@/components/ui/button";
import { ArrowUpDown, Eye, CheckCircle2, XCircle, Clock } from "lucide-react";
import { TriageReport } from "@/services/triage.service";

export const getUrgencyColor = (level: string | null) => {
    switch (level) {
        case 'URGENT': return 'bg-red-100 text-red-700 border-red-200';
        case 'ELEVEE': return 'bg-orange-100 text-orange-700 border-orange-200';
        case 'MODEREE': return 'bg-yellow-100 text-yellow-700 border-yellow-200';
        case 'FAIBLE': return 'bg-green-100 text-green-700 border-green-200';
        case 'ROUTINE': return 'bg-blue-100 text-blue-700 border-blue-200';
        default: return 'bg-slate-100 text-slate-700 border-slate-200';
    }
};

const getValidationIcon = (status: string) => {
    switch (status) {
        case 'VALIDATED': return <CheckCircle2 className="h-4 w-4 text-green-500" />;
        case 'REJECTED': return <XCircle className="h-4 w-4 text-red-500" />;
        default: return <Clock className="h-4 w-4 text-amber-500" />;
    }
};

export const createColumns = (
    onView?: (report: TriageReport) => void
): ColumnDef<TriageReport>[] => [
        {
            accessorKey: "createdAt",
            header: ({ column }) => {
                return (
                    <Button
                        variant="ghost"
                        onClick={() => column.toggleSorting(column.getIsSorted() === "asc")}
                        className="font-bold text-slate-700 hover:text-slate-900"
                    >
                        Date
                        <ArrowUpDown className="ml-2 h-4 w-4" />
                    </Button>
                );
            },
            cell: ({ row }) => {
                const date = new Date(row.getValue("createdAt"));
                return <div>{date.toLocaleString('fr-FR', {
                    year: 'numeric',
                    month: 'short',
                    day: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit'
                })}</div>;
            }
        },
        {
            id: "patient",
            header: "Patient",
            cell: ({ row }) => {
                const patient = row.original.patient;
                return (
                    <div className="font-medium">
                        {patient ? `${patient.firstName} ${patient.lastName}` : <span className="text-slate-400 italic">Non lié (Anonyme)</span>}
                    </div>
                );
            }
        },
        {
            accessorKey: "aiDiagnosticName",
            header: "Diagnostic IA",
            cell: ({ row }) => (
                <div className="max-w-[250px] truncate font-medium text-slate-900" title={row.getValue("aiDiagnosticName") || 'N/A'}>
                    {row.getValue("aiDiagnosticName") || "Analyse en attente"}
                </div>
            )
        },
        {
            accessorKey: "urgencyLevel",
            header: "Niveau d'Urgence",
            cell: ({ row }) => {
                const urgency = row.getValue("urgencyLevel") as string | null;
                return (
                    <div className={`px-2.5 py-1 rounded-full text-xs font-semibold inline-flex items-center border ${getUrgencyColor(urgency)}`}>
                        {urgency || "NON DÉFINI"}
                    </div>
                );
            }
        },
        {
            accessorKey: "validationStatus",
            header: "Statut",
            cell: ({ row }) => {
                const status = row.getValue("validationStatus") as string;
                return (
                    <div className="flex items-center gap-1.5" title={status}>
                        {getValidationIcon(status)}
                    </div>
                );
            }
        },
        {
            id: "actions",
            cell: ({ row }) => {
                const report = row.original;
                return (
                    <div className="flex justify-end pr-4">
                        {onView && (
                            <Button
                                variant="ghost"
                                size="sm"
                                onClick={(e) => {
                                    e.stopPropagation();
                                    onView(report);
                                }}
                                className="text-blue-600 hover:text-blue-700 hover:bg-blue-50"
                            >
                                <Eye className="h-4 w-4 mr-2" />
                                Examiner
                            </Button>
                        )}
                    </div>
                );
            },
        },
    ];

export const columns = createColumns();

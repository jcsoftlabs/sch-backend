"use client";

import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { useRouter } from "next/navigation";

export function AgentHistory({ history }: { history: any[] }) {
    const router = useRouter();

    if (!history || history.length === 0) {
        return <div className="text-center py-8 text-slate-500">Aucune activité récente.</div>;
    }

    return (
        <div className="rounded-md border">
            <Table>
                <TableHeader>
                    <TableRow className="bg-slate-50">
                        <TableHead className="font-bold text-slate-700">Date</TableHead>
                        <TableHead className="font-bold text-slate-700">Patient</TableHead>
                        <TableHead className="font-bold text-slate-700">Type</TableHead>
                        <TableHead className="font-bold text-slate-700">Statut</TableHead>
                    </TableRow>
                </TableHeader>
                <TableBody>
                    {history.map((record) => (
                        <TableRow
                            key={record.id}
                            className="cursor-pointer hover:bg-slate-50"
                            onClick={() => router.push(`/dashboard/consultations/${record.id}`)}
                        >
                            <TableCell className="font-medium">{new Date(record.date).toLocaleDateString()}</TableCell>
                            <TableCell>{record.patientName}</TableCell>
                            <TableCell>{record.type}</TableCell>
                            <TableCell>
                                <Badge variant={record.status === "COMPLETED" ? "default" : "secondary"}>
                                    {record.status}
                                </Badge>
                            </TableCell>
                        </TableRow>
                    ))}
                </TableBody>
            </Table>
        </div>
    );
}

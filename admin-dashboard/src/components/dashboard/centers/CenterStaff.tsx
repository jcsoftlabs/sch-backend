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
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";

export function CenterStaff({ staff }: { staff: any[] }) {
    if (!staff || staff.length === 0) {
        return <div className="text-center py-8 text-slate-500">Aucun personnel assigné.</div>;
    }

    return (
        <div className="rounded-md border">
            <Table>
                <TableHeader>
                    <TableRow className="bg-slate-50">
                        <TableHead className="font-bold text-slate-700">Nom</TableHead>
                        <TableHead className="font-bold text-slate-700">Rôle</TableHead>
                        <TableHead className="font-bold text-slate-700">Contact</TableHead>
                        <TableHead className="font-bold text-slate-700">Statut</TableHead>
                    </TableRow>
                </TableHeader>
                <TableBody>
                    {staff.map((member) => (
                        <TableRow key={member.id}>
                            <TableCell className="flex items-center gap-3 font-medium">
                                <Avatar className="h-8 w-8">
                                    <AvatarFallback>{member.name.substring(0, 2).toUpperCase()}</AvatarFallback>
                                </Avatar>
                                {member.name}
                            </TableCell>
                            <TableCell>{member.role}</TableCell>
                            <TableCell>{member.phone}</TableCell>
                            <TableCell>
                                <Badge variant={member.status === "ACTIVE" ? "default" : "secondary"}>
                                    {member.status}
                                </Badge>
                            </TableCell>
                        </TableRow>
                    ))}
                </TableBody>
            </Table>
        </div>
    );
}

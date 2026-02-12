"use client";

import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from "@/components/ui/table";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { EpidemiologicalAlert } from "@/services/alert.service";
import { format } from "date-fns";
import { fr } from "date-fns/locale";

interface AlertHistoryTableProps {
    alerts: EpidemiologicalAlert[];
}

export function AlertHistoryTable({ alerts }: AlertHistoryTableProps) {
    const resolvedAlerts = alerts.filter((a) => a.status === "RESOLVED");

    const getSeverityBadge = (severity: string) => {
        switch (severity) {
            case "CRITICAL":
                return <Badge variant="destructive">{severity}</Badge>;
            case "HIGH":
                return <Badge className="bg-orange-500">{severity}</Badge>;
            case "MEDIUM":
                return <Badge className="bg-yellow-500">{severity}</Badge>;
            case "LOW":
                return <Badge variant="secondary">{severity}</Badge>;
            default:
                return <Badge variant="outline">{severity}</Badge>;
        }
    };

    return (
        <Card>
            <CardHeader>
                <CardTitle>Historique des Alertes</CardTitle>
            </CardHeader>
            <CardContent>
                {resolvedAlerts.length === 0 ? (
                    <p className="text-center py-8 text-muted-foreground">
                        Aucune alerte résolue
                    </p>
                ) : (
                    <Table>
                        <TableHeader>
                            <TableRow>
                                <TableHead>Maladie</TableHead>
                                <TableHead>Zone</TableHead>
                                <TableHead>Sévérité</TableHead>
                                <TableHead>Cas</TableHead>
                                <TableHead>Créée le</TableHead>
                                <TableHead>Résolue le</TableHead>
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                            {resolvedAlerts.map((alert) => (
                                <TableRow key={alert.id}>
                                    <TableCell className="font-medium">{alert.disease}</TableCell>
                                    <TableCell>{alert.zone}</TableCell>
                                    <TableCell>{getSeverityBadge(alert.severity)}</TableCell>
                                    <TableCell>
                                        {alert.currentCases}/{alert.threshold}
                                    </TableCell>
                                    <TableCell>
                                        {format(new Date(alert.createdAt), "dd/MM/yyyy", {
                                            locale: fr,
                                        })}
                                    </TableCell>
                                    <TableCell>
                                        {alert.resolvedAt &&
                                            format(new Date(alert.resolvedAt), "dd/MM/yyyy", {
                                                locale: fr,
                                            })}
                                    </TableCell>
                                </TableRow>
                            ))}
                        </TableBody>
                    </Table>
                )}
            </CardContent>
        </Card>
    );
}

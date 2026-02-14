"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { EpidemiologicalAlert } from "@/services/alert.service";
import { AlertTriangle, CheckCircle, Clock } from "lucide-react";
import { format } from "date-fns";
import { fr } from "date-fns/locale";

interface AlertTimelineProps {
    alerts: EpidemiologicalAlert[];
    onResolve: (id: string) => void;
}

export function AlertTimeline({ alerts, onResolve }: AlertTimelineProps) {
    const activeAlerts = alerts.filter((a) => a.status === "ACTIVE");

    const getSeverityColor = (severity: string) => {
        switch (severity) {
            case "CRITICAL":
                return "bg-red-100 text-red-800 border-red-300";
            case "HIGH":
                return "bg-orange-100 text-orange-800 border-orange-300";
            case "MEDIUM":
                return "bg-yellow-100 text-yellow-800 border-yellow-300";
            case "LOW":
                return "bg-blue-100 text-blue-800 border-blue-300";
            default:
                return "bg-gray-100 text-gray-800 border-gray-300";
        }
    };

    const getSeverityIcon = (severity: string) => {
        switch (severity) {
            case "CRITICAL":
            case "HIGH":
                return <AlertTriangle className="h-5 w-5 text-red-600" />;
            case "MEDIUM":
                return <Clock className="h-5 w-5 text-yellow-600" />;
            case "LOW":
                return <AlertTriangle className="h-5 w-5 text-blue-600" />;
            default:
                return null;
        }
    };

    return (
        <Card>
            <CardHeader>
                <CardTitle className="flex items-center gap-2">
                    <AlertTriangle className="h-5 w-5" />
                    Alertes Actives ({activeAlerts.length})
                </CardTitle>
            </CardHeader>
            <CardContent>
                {activeAlerts.length === 0 ? (
                    <div className="text-center py-8 text-slate-500">
                        <CheckCircle className="h-12 w-12 mx-auto mb-2 text-green-500" />
                        <p>Aucune alerte active</p>
                    </div>
                ) : (
                    <div className="space-y-4">
                        {activeAlerts.map((alert) => (
                            <div
                                key={alert.id}
                                className={`p-4 rounded-lg border-2 ${getSeverityColor(alert.severity)}`}
                            >
                                <div className="flex items-start justify-between">
                                    <div className="flex items-start gap-3 flex-1">
                                        {getSeverityIcon(alert.severity)}
                                        <div className="flex-1">
                                            <div className="flex items-center gap-2 mb-1">
                                                <h4 className="font-semibold text-slate-900">{alert.disease}</h4>
                                                <Badge variant="outline">{alert.severity}</Badge>
                                            </div>
                                            <p className="text-sm mb-2 text-slate-700">{alert.description}</p>
                                            <div className="flex items-center gap-4 text-xs text-slate-600">
                                                <span>Zone: {alert.zone}</span>
                                                <span>Cas: {alert.currentCases}/{alert.threshold}</span>
                                                <span>
                                                    {format(new Date(alert.createdAt), "dd MMM yyyy HH:mm", {
                                                        locale: fr,
                                                    })}
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div className="flex flex-col gap-2">
                                        <Button
                                            size="sm"
                                            variant="outline"
                                            onClick={() => onResolve(alert.id)}
                                            className="w-full"
                                        >
                                            <CheckCircle className="mr-2 h-4 w-4 text-green-600" />
                                            Résoudre
                                        </Button>
                                        <Button
                                            size="sm"
                                            variant="destructive"
                                            className="w-full bg-red-50 text-red-600 border-red-200 hover:bg-red-100 hover:text-red-700 hover:border-red-300"
                                            onClick={() => console.log("Escalate", alert.id)} // Mock action
                                        >
                                            <AlertTriangle className="mr-2 h-4 w-4" />
                                            Escalader
                                        </Button>
                                    </div>
                                </div>
                            </div>
                        ))}
                    </div>
                )}
            </CardContent>
        </Card>
    );
}

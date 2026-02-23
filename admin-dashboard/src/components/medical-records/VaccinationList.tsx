"use client";

import { useState, useEffect } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Syringe, Calendar } from "lucide-react";
import { vaccinationService, Vaccination } from "@/services/vaccination.service";
import { format } from "date-fns";
import { fr } from "date-fns/locale";

interface VaccinationListProps {
    patientId: string;
}

export function VaccinationList({ patientId }: VaccinationListProps) {
    const [vaccinations, setVaccinations] = useState<Vaccination[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        loadVaccinations();
    }, [patientId]);

    const loadVaccinations = async () => {
        try {
            setLoading(true);
            const data = await vaccinationService.getByPatient(patientId);
            setVaccinations(data.data?.vaccinations || data || []);
        } catch (error) {
            console.error("Error loading vaccinations:", error);
        } finally {
            setLoading(false);
        }
    };

    return (
        <Card>
            <CardHeader>
                <div>
                    <CardTitle>Vaccinations</CardTitle>
                    <CardDescription>
                        Historique des vaccins administrés
                    </CardDescription>
                </div>
            </CardHeader>
            <CardContent>
                {loading ? (
                    <p className="text-slate-500">Chargement...</p>
                ) : vaccinations.length === 0 ? (
                    <p className="text-slate-500">Aucun vaccin enregistré pour ce patient.</p>
                ) : (
                    <div className="space-y-4">
                        {vaccinations.map((vaccination) => (
                            <div
                                key={vaccination.id}
                                className="flex items-start justify-between p-4 border rounded-lg hover:bg-accent/50 transition-colors"
                            >
                                <div className="flex gap-3">
                                    <div className="mt-1">
                                        <div className="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center">
                                            <Syringe className="h-5 w-5 text-blue-600" />
                                        </div>
                                    </div>
                                    <div className="space-y-1">
                                        <div className="flex items-center gap-2">
                                            <p className="font-semibold text-slate-900">{vaccination.vaccine}</p>
                                            <span className="text-xs font-medium px-2 py-0.5 rounded-full bg-slate-100 text-slate-700 border border-slate-200">
                                                Dose {vaccination.doseNumber}
                                            </span>
                                        </div>
                                        {vaccination.notes && (
                                            <p className="text-sm text-slate-500 italic mt-1 mb-2">
                                                {vaccination.notes}
                                            </p>
                                        )}
                                        <div className="flex flex-col gap-1 mt-2">
                                            <span className="flex items-center gap-2 text-sm text-slate-600">
                                                <Calendar className="h-4 w-4" />
                                                Fait le {format(new Date(vaccination.dateGiven), "d MMMM yyyy", { locale: fr })}
                                            </span>
                                            {vaccination.nextDueDate && (
                                                <span className="flex items-center gap-2 text-sm text-amber-600 font-medium">
                                                    <Calendar className="h-4 w-4" />
                                                    Prochaine dose: {format(new Date(vaccination.nextDueDate), "d MMMM yyyy", { locale: fr })}
                                                </span>
                                            )}
                                        </div>
                                    </div>
                                </div>
                                <div className="text-right flex flex-col items-end">
                                    <span className="text-xs text-slate-500">
                                        Agent: {vaccination.Agent ? `${vaccination.Agent.firstName} ${vaccination.Agent.lastName}` : "Inconnu"}
                                    </span>
                                    {vaccination.batchNumber && (
                                        <span className="text-xs text-slate-400 mt-1">
                                            Lot: {vaccination.batchNumber}
                                        </span>
                                    )}
                                </div>
                            </div>
                        ))}
                    </div>
                )}
            </CardContent>
        </Card>
    );
}

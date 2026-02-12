"use client";

import { useState } from "react";
import { MapView } from "@/components/map/MapView";
import { MapFiltersComponent } from "@/components/map/MapFilters";
import { MapLegend } from "@/components/map/MapLegend";
import { useMapData } from "@/hooks/useMapData";
import { MapFilters } from "@/services/map.service";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";

export default function MapPage() {
    const [filters, setFilters] = useState<MapFilters>({});
    const { data, loading, error } = useMapData(filters);

    if (loading) {
        return (
            <div className="flex items-center justify-center h-screen">
                <div className="text-center">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div>
                    <p className="mt-4 text-muted-foreground">Chargement de la carte...</p>
                </div>
            </div>
        );
    }

    if (error) {
        return (
            <div className="flex items-center justify-center h-screen">
                <Card className="w-96">
                    <CardHeader>
                        <CardTitle className="text-destructive">Erreur</CardTitle>
                        <CardDescription>
                            Impossible de charger les données de la carte
                        </CardDescription>
                    </CardHeader>
                    <CardContent>
                        <p className="text-sm text-muted-foreground">{error.message}</p>
                    </CardContent>
                </Card>
            </div>
        );
    }

    return (
        <div className="space-y-6 p-6">
            <div>
                <h1 className="text-3xl font-bold">Carte Interactive</h1>
                <p className="text-muted-foreground">
                    Visualisation géographique des centres de santé et cas reportés
                </p>
            </div>

            <MapFiltersComponent onFiltersChange={setFilters} />

            <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
                <div className="lg:col-span-3">
                    <Card>
                        <CardContent className="p-0">
                            {data && (
                                <MapView
                                    healthCenters={data.healthCenters}
                                />
                            )}
                        </CardContent>
                    </Card>
                </div>

                <div className="space-y-4">
                    <MapLegend />

                    {data && (
                        <Card>
                            <CardHeader>
                                <CardTitle className="text-sm">Statistiques</CardTitle>
                            </CardHeader>
                            <CardContent className="space-y-2">
                                <div>
                                    <p className="text-2xl font-bold">{data.healthCenters.length}</p>
                                    <p className="text-xs text-muted-foreground">Centres de santé</p>
                                </div>
                                <div>
                                    <p className="text-2xl font-bold">{data.caseReports.length}</p>
                                    <p className="text-xs text-muted-foreground">Cas reportés</p>
                                </div>
                                <div>
                                    <p className="text-2xl font-bold">{data.heatmapData.length}</p>
                                    <p className="text-xs text-muted-foreground">Zones actives</p>
                                </div>
                            </CardContent>
                        </Card>
                    )}
                </div>
            </div>
        </div>
    );
}

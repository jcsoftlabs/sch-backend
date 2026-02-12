"use client";

import { useState } from "react";
import { useAlerts } from "@/hooks/useAlerts";
import { AlertTimeline } from "@/components/alerts/AlertTimeline";
import { AlertHistoryTable } from "@/components/alerts/AlertHistoryTable";
import { AlertConfigPanel } from "@/components/alerts/AlertConfigPanel";
import { CreateAlertDialog } from "@/components/alerts/CreateAlertDialog";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { AlertService } from "@/services/alert.service";
import { useToast } from "@/hooks/use-toast";
import { Plus } from "lucide-react";

export default function AlertsPage() {
    const { data: alerts, loading, error, refetch } = useAlerts();
    const { toast } = useToast();
    const [createDialogOpen, setCreateDialogOpen] = useState(false);

    const handleResolve = async (id: string) => {
        try {
            await AlertService.updateStatus(id, "RESOLVED");
            toast({
                title: "Alerte résolue",
                description: "L'alerte a été marquée comme résolue.",
            });
            refetch();
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible de résoudre l'alerte.",
                variant: "destructive",
            });
        }
    };

    if (loading) {
        return (
            <div className="flex items-center justify-center h-screen">
                <div className="text-center">
                    <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div>
                    <p className="mt-4 text-muted-foreground">Chargement des alertes...</p>
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
                            Impossible de charger les alertes épidémiologiques
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
            <div className="flex items-center justify-between">
                <div>
                    <h1 className="text-3xl font-bold">Alertes Épidémiologiques</h1>
                    <p className="text-muted-foreground">
                        Gestion et configuration des alertes sanitaires
                    </p>
                </div>
                <Button onClick={() => setCreateDialogOpen(true)}>
                    <Plus className="h-4 w-4 mr-2" />
                    Créer une Alerte
                </Button>
            </div>

            <Tabs defaultValue="active" className="space-y-6">
                <TabsList>
                    <TabsTrigger value="active">Alertes Actives</TabsTrigger>
                    <TabsTrigger value="history">Historique</TabsTrigger>
                    <TabsTrigger value="config">Configuration</TabsTrigger>
                </TabsList>

                <TabsContent value="active" className="space-y-6">
                    <AlertTimeline alerts={alerts} onResolve={handleResolve} />
                </TabsContent>

                <TabsContent value="history">
                    <AlertHistoryTable alerts={alerts} />
                </TabsContent>

                <TabsContent value="config">
                    <AlertConfigPanel />
                </TabsContent>
            </Tabs>

            <CreateAlertDialog
                open={createDialogOpen}
                onClose={() => setCreateDialogOpen(false)}
                onSuccess={refetch}
            />
        </div>
    );
}

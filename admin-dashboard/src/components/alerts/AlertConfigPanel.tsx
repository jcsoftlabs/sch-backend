"use client";

import { useState, useEffect } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { AlertService, AlertConfig, DiseaseConfig } from "@/services/alert.service";
import { useToast } from "@/hooks/use-toast";
import { Save, Plus, Trash2 } from "lucide-react";

export function AlertConfigPanel() {
    const { toast } = useToast();
    const [config, setConfig] = useState<AlertConfig | null>(null);
    const [loading, setLoading] = useState(true);
    const [saving, setSaving] = useState(false);

    useEffect(() => {
        const fetchConfig = async () => {
            try {
                const data = await AlertService.getConfig();
                setConfig(data);
            } catch (error) {
                console.error("Error fetching config:", error);
            } finally {
                setLoading(false);
            }
        };
        fetchConfig();
    }, []);

    const handleSave = async () => {
        if (!config) return;

        try {
            setSaving(true);
            await AlertService.updateConfig(config);
            toast({
                title: "Configuration sauvegardée",
                description: "Les seuils d'alerte ont été mis à jour.",
            });
        } catch (error) {
            toast({
                title: "Erreur",
                description: "Impossible de sauvegarder la configuration.",
                variant: "destructive",
            });
        } finally {
            setSaving(false);
        }
    };

    const updateThreshold = (
        diseaseIndex: number,
        level: keyof DiseaseConfig["thresholds"],
        value: number
    ) => {
        if (!config) return;

        const newConfig = { ...config };
        newConfig.diseases[diseaseIndex].thresholds[level] = value;
        setConfig(newConfig);
    };

    const addDisease = () => {
        if (!config) return;

        const newDisease: DiseaseConfig = {
            name: "Nouvelle Maladie",
            thresholds: {
                low: 5,
                medium: 10,
                high: 20,
                critical: 50,
            },
        };

        setConfig({
            ...config,
            diseases: [...config.diseases, newDisease],
        });
    };

    const removeDisease = (index: number) => {
        if (!config) return;

        setConfig({
            ...config,
            diseases: config.diseases.filter((_, i) => i !== index),
        });
    };

    if (loading) {
        return (
            <Card>
                <CardContent className="py-8">
                    <div className="flex items-center justify-center">
                        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
                    </div>
                </CardContent>
            </Card>
        );
    }

    return (
        <Card>
            <CardHeader>
                <div className="flex items-center justify-between">
                    <div>
                        <CardTitle>Configuration des Seuils</CardTitle>
                        <CardDescription>
                            Définir les seuils d'alerte pour chaque maladie
                        </CardDescription>
                    </div>
                    <div className="flex gap-2">
                        <Button variant="outline" size="sm" onClick={addDisease}>
                            <Plus className="h-4 w-4 mr-2" />
                            Ajouter
                        </Button>
                        <Button size="sm" onClick={handleSave} disabled={saving}>
                            <Save className="h-4 w-4 mr-2" />
                            {saving ? "Sauvegarde..." : "Sauvegarder"}
                        </Button>
                    </div>
                </div>
            </CardHeader>
            <CardContent>
                <div className="space-y-6">
                    {config?.diseases.map((disease, index) => (
                        <div key={index} className="p-4 border rounded-lg space-y-4">
                            <div className="flex items-center justify-between">
                                <Input
                                    value={disease.name}
                                    onChange={(e) => {
                                        const newConfig = { ...config };
                                        newConfig.diseases[index].name = e.target.value;
                                        setConfig(newConfig);
                                    }}
                                    className="font-semibold max-w-xs"
                                />
                                <Button
                                    variant="ghost"
                                    size="sm"
                                    onClick={() => removeDisease(index)}
                                >
                                    <Trash2 className="h-4 w-4 text-red-500" />
                                </Button>
                            </div>

                            <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                                <div className="space-y-2">
                                    <Label className="text-blue-600">Faible</Label>
                                    <Input
                                        type="number"
                                        value={disease.thresholds.low}
                                        onChange={(e) =>
                                            updateThreshold(index, "low", parseInt(e.target.value))
                                        }
                                    />
                                </div>
                                <div className="space-y-2">
                                    <Label className="text-yellow-600">Moyenne</Label>
                                    <Input
                                        type="number"
                                        value={disease.thresholds.medium}
                                        onChange={(e) =>
                                            updateThreshold(index, "medium", parseInt(e.target.value))
                                        }
                                    />
                                </div>
                                <div className="space-y-2">
                                    <Label className="text-orange-600">Élevée</Label>
                                    <Input
                                        type="number"
                                        value={disease.thresholds.high}
                                        onChange={(e) =>
                                            updateThreshold(index, "high", parseInt(e.target.value))
                                        }
                                    />
                                </div>
                                <div className="space-y-2">
                                    <Label className="text-red-600">Critique</Label>
                                    <Input
                                        type="number"
                                        value={disease.thresholds.critical}
                                        onChange={(e) =>
                                            updateThreshold(index, "critical", parseInt(e.target.value))
                                        }
                                    />
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
            </CardContent>
        </Card>
    );
}

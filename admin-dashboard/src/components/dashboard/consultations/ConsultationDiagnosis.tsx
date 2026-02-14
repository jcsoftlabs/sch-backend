import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Stethoscope, AlertTriangle } from "lucide-react";
import { Badge } from "@/components/ui/badge";

export function ConsultationDiagnosis({ diagnosis, symptoms }: { diagnosis: string, symptoms: string[] }) {
    return (
        <Card>
            <CardHeader>
                <CardTitle className="flex items-center gap-2">
                    <Stethoscope className="h-5 w-5 text-purple-600" />
                    Diagnostic & Symptômes
                </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
                <div>
                    <h4 className="text-sm font-medium text-slate-500 mb-2">Symptômes Signalés</h4>
                    <div className="flex flex-wrap gap-2">
                        {symptoms && symptoms.length > 0 ? (
                            symptoms.map((s, i) => (
                                <Badge key={i} variant="secondary" className="px-3 py-1 bg-slate-100 text-slate-700 hover:bg-slate-200">
                                    {s}
                                </Badge>
                            ))
                        ) : (
                            <span className="text-sm text-slate-400 italic">Aucun symptôme enregistré</span>
                        )}
                    </div>
                </div>

                <div className="mt-4 p-4 bg-purple-50 rounded-lg border border-purple-100">
                    <h4 className="text-xs font-bold text-purple-700 uppercase mb-1">Diagnostic Principal</h4>
                    <p className="text-lg font-semibold text-slate-900">{diagnosis || "En attente de diagnostic"}</p>
                </div>
            </CardContent>
        </Card>
    );
}

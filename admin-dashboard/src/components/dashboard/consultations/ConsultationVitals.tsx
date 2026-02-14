import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Activity, Thermometer, Heart, Scale } from "lucide-react";

export function ConsultationVitals({ vitals }: { vitals: any }) {
    if (!vitals) return <div className="p-4 border rounded bg-slate-50 text-slate-500 italic text-center">Aucune constante prise.</div>;

    return (
        <Card>
            <CardHeader>
                <CardTitle className="flex items-center gap-2">
                    <Activity className="h-5 w-5 text-blue-600" />
                    Signes Vitaux
                </CardTitle>
            </CardHeader>
            <CardContent>
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                    <div className="p-3 bg-red-50 rounded-lg">
                        <div className="flex items-center gap-2 text-red-600 mb-1">
                            <Heart className="h-4 w-4" />
                            <span className="text-xs font-bold uppercase">Pouls</span>
                        </div>
                        <p className="text-2xl font-bold text-slate-900">{vitals.heartRate} <span className="text-sm font-normal text-slate-500">bpm</span></p>
                    </div>
                    <div className="p-3 bg-blue-50 rounded-lg">
                        <div className="flex items-center gap-2 text-blue-600 mb-1">
                            <Activity className="h-4 w-4" />
                            <span className="text-xs font-bold uppercase">Tension</span>
                        </div>
                        <p className="text-2xl font-bold text-slate-900">{vitals.bloodPressure} <span className="text-sm font-normal text-slate-500">mmHg</span></p>
                    </div>
                    <div className="p-3 bg-amber-50 rounded-lg">
                        <div className="flex items-center gap-2 text-amber-600 mb-1">
                            <Thermometer className="h-4 w-4" />
                            <span className="text-xs font-bold uppercase">Temp.</span>
                        </div>
                        <p className="text-2xl font-bold text-slate-900">{vitals.temperature}°C</p>
                    </div>
                    <div className="p-3 bg-slate-50 rounded-lg">
                        <div className="flex items-center gap-2 text-slate-600 mb-1">
                            <Scale className="h-4 w-4" />
                            <span className="text-xs font-bold uppercase">Poids</span>
                        </div>
                        <p className="text-2xl font-bold text-slate-900">{vitals.weight} <span className="text-sm font-normal text-slate-500">kg</span></p>
                    </div>
                </div>
            </CardContent>
        </Card>
    );
}

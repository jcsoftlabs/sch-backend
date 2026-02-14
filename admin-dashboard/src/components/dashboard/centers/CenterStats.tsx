import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Users, Activity, Bed, Thermometer } from "lucide-react";

export function CenterStats({ stats }: { stats: any }) {
    if (!stats) return null;

    return (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <Card className="shadow-sm">
                <CardContent className="p-4 flex items-center space-x-4">
                    <div className="p-2 bg-blue-100 rounded-full">
                        <Users className="h-5 w-5 text-blue-600" />
                    </div>
                    <div>
                        <p className="text-xs font-medium text-slate-500">Patients/Mois</p>
                        <h3 className="text-xl font-bold">{stats.monthlyPatients}</h3>
                    </div>
                </CardContent>
            </Card>

            <Card className="shadow-sm">
                <CardContent className="p-4 flex items-center space-x-4">
                    <div className="p-2 bg-green-100 rounded-full">
                        <Activity className="h-5 w-5 text-green-600" />
                    </div>
                    <div>
                        <p className="text-xs font-medium text-slate-500">Consultations</p>
                        <h3 className="text-xl font-bold">{stats.totalConsultations}</h3>
                    </div>
                </CardContent>
            </Card>

            <Card className="shadow-sm">
                <CardContent className="p-4 flex items-center space-x-4">
                    <div className="p-2 bg-purple-100 rounded-full">
                        <Bed className="h-5 w-5 text-purple-600" />
                    </div>
                    <div>
                        <p className="text-xs font-medium text-slate-500">Lits Disponibles</p>
                        <h3 className="text-xl font-bold">{stats.availableBeds} <span className="text-xs text-slate-500 font-normal">/ {stats.totalBeds}</span></h3>
                    </div>
                </CardContent>
            </Card>

            <Card className="shadow-sm">
                <CardContent className="p-4 flex items-center space-x-4">
                    <div className="p-2 bg-amber-100 rounded-full">
                        <Thermometer className="h-5 w-5 text-amber-600" />
                    </div>
                    <div>
                        <p className="text-xs font-medium text-slate-500">Cas Critiques</p>
                        <h3 className="text-xl font-bold">{stats.criticalCases}</h3>
                    </div>
                </CardContent>
            </Card>
        </div>
    );
}

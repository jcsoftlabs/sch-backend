import { Card, CardContent } from "@/components/ui/card";
import { Users, ClipboardCheck, Activity, Star } from "lucide-react";

export function AgentStats({ stats }: { stats: any }) {
    if (!stats) return null;

    return (
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <Card className="stat-card border-l-blue-500">
                <CardContent className="p-4 flex items-center justify-between">
                    <div>
                        <p className="text-xs font-medium text-slate-500 uppercase">Consultations</p>
                        <h3 className="text-2xl font-bold text-slate-900">{stats.totalConsultations}</h3>
                    </div>
                    <div className="h-10 w-10 rounded-full bg-blue-100 flex items-center justify-center">
                        <ClipboardCheck className="h-5 w-5 text-blue-600" />
                    </div>
                </CardContent>
            </Card>

            <Card className="stat-card border-l-green-500">
                <CardContent className="p-4 flex items-center justify-between">
                    <div>
                        <p className="text-xs font-medium text-slate-500 uppercase">Patients Uniques</p>
                        <h3 className="text-2xl font-bold text-slate-900">{stats.uniquePatients}</h3>
                    </div>
                    <div className="h-10 w-10 rounded-full bg-green-100 flex items-center justify-center">
                        <Users className="h-5 w-5 text-green-600" />
                    </div>
                </CardContent>
            </Card>

            <Card className="stat-card border-l-purple-500">
                <CardContent className="p-4 flex items-center justify-between">
                    <div>
                        <p className="text-xs font-medium text-slate-500 uppercase">Jours Actifs</p>
                        <h3 className="text-2xl font-bold text-slate-900">{stats.activeDays}j <span className="text-xs font-normal text-slate-500">/ 30</span></h3>
                    </div>
                    <div className="h-10 w-10 rounded-full bg-purple-100 flex items-center justify-center">
                        <Activity className="h-5 w-5 text-purple-600" />
                    </div>
                </CardContent>
            </Card>

            <Card className="stat-card border-l-amber-500">
                <CardContent className="p-4 flex items-center justify-between">
                    <div>
                        <p className="text-xs font-medium text-slate-500 uppercase">Note Qualité</p>
                        <h3 className="text-2xl font-bold text-slate-900">{stats.qualityScore}/5</h3>
                    </div>
                    <div className="h-10 w-10 rounded-full bg-amber-100 flex items-center justify-center">
                        <Star className="h-5 w-5 text-amber-600" />
                    </div>
                </CardContent>
            </Card>
        </div>
    );
}

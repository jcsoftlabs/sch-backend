import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { User, Calendar, MapPin, Phone } from "lucide-react";
import { Badge } from "@/components/ui/badge";

export function ConsultationPatientInfo({ patient }: { patient: any }) {
    if (!patient) return null;

    return (
        <Card className="h-full">
            <CardHeader className="pb-2">
                <CardTitle className="text-sm font-medium text-slate-500 uppercase tracking-wider">Patient</CardTitle>
            </CardHeader>
            <CardContent>
                <div className="flex items-start space-x-4">
                    <div className="h-12 w-12 rounded-full bg-slate-100 flex items-center justify-center">
                        <User className="h-6 w-6 text-slate-500" />
                    </div>
                    <div className="space-y-1">
                        <h3 className="font-bold text-lg text-slate-900">{patient.firstName} {patient.lastName}</h3>
                        <div className="flex items-center text-sm text-slate-600 space-x-2">
                            <span className="font-mono bg-slate-100 px-1 rounded text-xs">{patient.id}</span>
                            <span>•</span>
                            <span>{patient.age} ans</span>
                            <span>•</span>
                            <span>{patient.gender === "MALE" ? "Homme" : "Femme"}</span>
                        </div>
                        <div className="pt-2 space-y-1 text-sm text-slate-500">
                            <div className="flex items-center gap-2">
                                <Phone className="h-3 w-3" /> {patient.phone}
                            </div>
                            <div className="flex items-center gap-2">
                                <MapPin className="h-3 w-3" /> {patient.address}
                            </div>
                        </div>
                    </div>
                </div>
            </CardContent>
        </Card>
    );
}

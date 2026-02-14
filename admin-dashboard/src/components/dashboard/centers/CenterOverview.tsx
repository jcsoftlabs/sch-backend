import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Building2, MapPin, Phone, Mail } from "lucide-react";

export function CenterOverview({ center }: { center: any }) {
    if (!center) return null;

    return (
        <Card className="h-full">
            <CardHeader>
                <CardTitle>Informations Générales</CardTitle>
            </CardHeader>
            <CardContent className="space-y-6">
                <div className="flex items-start space-x-4">
                    <div className="h-16 w-16 rounded-lg bg-blue-100 flex items-center justify-center flex-shrink-0">
                        <Building2 className="h-8 w-8 text-blue-600" />
                    </div>
                    <div>
                        <h3 className="text-lg font-bold text-slate-800">{center.name}</h3>
                        <Badge variant="outline" className="mt-1">{center.type}</Badge>
                    </div>
                </div>

                <div className="space-y-3 pt-2">
                    <div className="flex items-center space-x-3 text-sm">
                        <MapPin className="h-4 w-4 text-slate-400" />
                        <span className="text-slate-600">{center.address}</span>
                    </div>
                    <div className="flex items-center space-x-3 text-sm">
                        <Phone className="h-4 w-4 text-slate-400" />
                        <span className="text-slate-600">{center.phone}</span>
                    </div>
                    <div className="flex items-center space-x-3 text-sm">
                        <Mail className="h-4 w-4 text-slate-400" />
                        <span className="text-slate-600">{center.email}</span>
                    </div>
                </div>
            </CardContent>
        </Card>
    );
}

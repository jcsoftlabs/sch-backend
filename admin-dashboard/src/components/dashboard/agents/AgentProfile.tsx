import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { UserCog, MapPin, Phone, Mail, FileText, Calendar, Smartphone } from "lucide-react";

export function AgentProfile({ agent }: { agent: any }) {
    if (!agent) return null;

    return (
        <Card className="h-full border-l-4 border-l-blue-500 shadow-md">
            <CardContent className="p-6">
                <div className="flex flex-col items-center text-center space-y-4">
                    <div className="h-24 w-24 rounded-full bg-blue-100 flex items-center justify-center border-4 border-white shadow-sm">
                        <UserCog className="h-12 w-12 text-blue-600" />
                    </div>
                    <div>
                        <h2 className="text-2xl font-bold text-slate-800">{agent.userId}</h2>
                        <Badge variant={agent.status === "ACTIVE" ? "default" : "secondary"} className="mt-2">
                            {agent.status}
                        </Badge>
                    </div>
                </div>

                <div className="mt-8 space-y-4">
                    <div className="flex items-center space-x-3 text-sm">
                        <MapPin className="h-4 w-4 text-slate-400" />
                        <span className="text-slate-600 font-medium">Zone: {agent.assignedZone}</span>
                    </div>
                    <div className="flex items-center space-x-3 text-sm">
                        <Smartphone className="h-4 w-4 text-slate-400" />
                        <span className="text-slate-600">Device ID: <span className="font-mono text-xs bg-slate-100 px-2 py-0.5 rounded">{agent.deviceId}</span></span>
                    </div>
                    <div className="flex items-center space-x-3 text-sm">
                        <Calendar className="h-4 w-4 text-slate-400" />
                        <span className="text-slate-600">Dernière synchro: {new Date(agent.lastSync).toLocaleString()}</span>
                    </div>
                </div>
            </CardContent>
        </Card>
    );
}

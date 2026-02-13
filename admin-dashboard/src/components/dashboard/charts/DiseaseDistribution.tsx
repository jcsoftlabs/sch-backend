"use client";

import { PieChart, Pie, Cell, ResponsiveContainer, Legend, Tooltip } from "recharts";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";

const data = [
    { name: "Choléra", value: 35, color: "#EF4444" }, // Red
    { name: "Paludisme", value: 25, color: "#F59E0B" }, // Amber
    { name: "Grippe", value: 20, color: "#3B82F6" },   // Blue
    { name: "Diabète", value: 15, color: "#10B981" },  // Green
    { name: "Autre", value: 5, color: "#64748B" },     // Slate
];

export function DiseaseDistribution() {
    return (
        <Card className="col-span-3 animate-fade-in card-elevated" style={{ animationDelay: '0.1s' }}>
            <CardHeader className="pb-4">
                <CardTitle className="text-base font-semibold text-slate-900">Distribution des Pathologies</CardTitle>
                <CardDescription className="text-sm text-slate-500">
                    Répartition des cas diagnostiqués ce mois
                </CardDescription>
            </CardHeader>
            <CardContent>
                <div className="h-[300px] w-full">
                    <ResponsiveContainer width="100%" height="100%">
                        <PieChart>
                            <Pie
                                data={data}
                                cx="50%"
                                cy="50%"
                                innerRadius={60}
                                outerRadius={80}
                                paddingAngle={5}
                                dataKey="value"
                            >
                                {data.map((entry, index) => (
                                    <Cell key={`cell-${index}`} fill={entry.color} strokeWidth={0} />
                                ))}
                            </Pie>
                            <Tooltip
                                contentStyle={{
                                    backgroundColor: '#fff',
                                    borderRadius: '8px',
                                    border: '1px solid #e2e8f0',
                                    boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)'
                                }}
                                itemStyle={{ color: '#0f172a', fontSize: '12px', fontWeight: '600' }}
                            />
                            <Legend
                                verticalAlign="bottom"
                                height={36}
                                iconType="circle"
                                formatter={(value) => <span className="text-xs text-slate-600 ml-1">{value}</span>}
                            />
                        </PieChart>
                    </ResponsiveContainer>
                </div>
            </CardContent>
        </Card>
    );
}

"use client";

import { Bar, BarChart, CartesianGrid, ResponsiveContainer, Tooltip, XAxis, YAxis, Cell } from "recharts";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";

const data = [
    { name: "Jean Baptiste", consultations: 145, efficiency: 98 },
    { name: "Marie Claire", consultations: 132, efficiency: 95 },
    { name: "Pierre Louis", consultations: 118, efficiency: 92 },
    { name: "Sarah Michel", consultations: 98, efficiency: 96 },
    { name: "David Joseph", consultations: 85, efficiency: 90 },
];

export function AgentPerformance() {
    return (
        <Card className="col-span-4 animate-fade-in card-elevated" style={{ animationDelay: '0.2s' }}>
            <CardHeader className="pb-4">
                <CardTitle className="text-base font-semibold text-slate-900">Performance des Agents</CardTitle>
                <CardDescription className="text-sm text-slate-500">
                    Top 5 des agents par volume de consultations
                </CardDescription>
            </CardHeader>
            <CardContent>
                <div className="h-[250px] w-full">
                    <ResponsiveContainer width="100%" height="100%">
                        <BarChart data={data} layout="vertical" margin={{ top: 0, right: 30, left: 0, bottom: 0 }}>
                            <CartesianGrid strokeDasharray="3 3" horizontal={false} stroke="#e2e8f0" />
                            <XAxis type="number" hide />
                            <YAxis
                                dataKey="name"
                                type="category"
                                width={100}
                                tickLine={false}
                                axisLine={false}
                                style={{ fontSize: '12px', fill: '#64748b' }}
                            />
                            <Tooltip
                                cursor={{ fill: 'transparent' }}
                                contentStyle={{
                                    backgroundColor: '#fff',
                                    borderRadius: '8px',
                                    border: '1px solid #e2e8f0',
                                    boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)'
                                }}
                                itemStyle={{ color: '#0f172a', fontSize: '12px', fontWeight: '600' }}
                                labelStyle={{ color: '#64748b', fontSize: '12px', marginBottom: '4px' }}
                            />
                            <Bar dataKey="consultations" radius={[0, 4, 4, 0]} barSize={20}>
                                {data.map((entry, index) => (
                                    <Cell key={`cell-${index}`} fill={index === 0 ? '#0066CC' : '#94a3b8'} />
                                ))}
                            </Bar>
                        </BarChart>
                    </ResponsiveContainer>
                </div>
            </CardContent>
        </Card>
    );
}

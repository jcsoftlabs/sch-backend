"use client";

import { Area, AreaChart, CartesianGrid, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { useState } from "react";

const data = [
    { date: "Lun", consultations: 12 },
    { date: "Mar", consultations: 19 },
    { date: "Mer", consultations: 15 },
    { date: "Jeu", consultations: 22 },
    { date: "Ven", consultations: 28 },
    { date: "Sam", consultations: 14 },
    { date: "Dim", consultations: 8 },
];

export function ConsultationTrends() {
    const [timeRange, setTimeRange] = useState("week");

    return (
        <Card className="col-span-4 animate-fade-in card-elevated">
            <CardHeader className="flex flex-row items-center justify-between pb-4">
                <div className="space-y-1">
                    <CardTitle className="text-base font-semibold text-slate-900">Tendances des Consultations</CardTitle>
                    <CardDescription className="text-sm text-slate-500">
                        Nombre de consultations sur la période sélectionnée
                    </CardDescription>
                </div>
                <Select defaultValue={timeRange} onValueChange={setTimeRange}>
                    <SelectTrigger className="w-[140px] h-8 text-xs">
                        <SelectValue placeholder="Période" />
                    </SelectTrigger>
                    <SelectContent>
                        <SelectItem value="week">7 derniers jours</SelectItem>
                        <SelectItem value="month">30 derniers jours</SelectItem>
                        <SelectItem value="quarter">3 derniers mois</SelectItem>
                    </SelectContent>
                </Select>
            </CardHeader>
            <CardContent className="pl-0">
                <div className="h-[300px] w-full">
                    <ResponsiveContainer width="100%" height="100%">
                        <AreaChart data={data} margin={{ top: 10, right: 30, left: 0, bottom: 0 }}>
                            <defs>
                                <linearGradient id="colorConsultations" x1="0" y1="0" x2="0" y2="1">
                                    <stop offset="5%" stopColor="#0066CC" stopOpacity={0.3} />
                                    <stop offset="95%" stopColor="#0066CC" stopOpacity={0} />
                                </linearGradient>
                            </defs>
                            <XAxis
                                dataKey="date"
                                stroke="#64748b"
                                fontSize={12}
                                tickLine={false}
                                axisLine={false}
                                dy={10}
                            />
                            <YAxis
                                stroke="#64748b"
                                fontSize={12}
                                tickLine={false}
                                axisLine={false}
                                dx={-10}
                            />
                            <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#e2e8f0" />
                            <Tooltip
                                contentStyle={{
                                    backgroundColor: '#fff',
                                    borderRadius: '8px',
                                    border: '1px solid #e2e8f0',
                                    boxShadow: '0 4px 6px -1px rgb(0 0 0 / 0.1)'
                                }}
                                itemStyle={{ color: '#0f172a', fontSize: '12px', fontWeight: '600' }}
                                labelStyle={{ color: '#64748b', fontSize: '12px', marginBottom: '4px' }}
                            />
                            <Area
                                type="monotone"
                                dataKey="consultations"
                                stroke="#0066CC"
                                strokeWidth={3}
                                fillOpacity={1}
                                fill="url(#colorConsultations)"
                                activeDot={{ r: 6, strokeWidth: 0, fill: '#0066CC' }}
                            />
                        </AreaChart>
                    </ResponsiveContainer>
                </div>
            </CardContent>
        </Card>
    );
}

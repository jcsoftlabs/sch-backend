"use client";

import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from "@/components/ui/table";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Eye } from "lucide-react";
import { TopPerformer } from "@/services/agent.service";

interface AgentRankingTableProps {
    topPerformers: TopPerformer[];
    onViewDetails: (agentId: string) => void;
}

export function AgentRankingTable({ topPerformers, onViewDetails }: AgentRankingTableProps) {
    return (
        <Card>
            <CardHeader>
                <CardTitle>Top 10 Performers</CardTitle>
            </CardHeader>
            <CardContent>
                <Table>
                    <TableHeader>
                        <TableRow>
                            <TableHead className="w-12">#</TableHead>
                            <TableHead>Nom</TableHead>
                            <TableHead className="text-right">Visites</TableHead>
                            <TableHead className="text-right">Cas Résolus</TableHead>
                            <TableHead className="text-right">Temps Réponse</TableHead>
                            <TableHead className="text-right">Actions</TableHead>
                        </TableRow>
                    </TableHeader>
                    <TableBody>
                        {topPerformers.map((agent, index) => (
                            <TableRow key={agent.id}>
                                <TableCell className="font-medium">
                                    {index === 0 && <Badge variant="default">🥇</Badge>}
                                    {index === 1 && <Badge variant="secondary">🥈</Badge>}
                                    {index === 2 && <Badge variant="outline">🥉</Badge>}
                                    {index > 2 && <span className="text-muted-foreground">{index + 1}</span>}
                                </TableCell>
                                <TableCell className="font-medium">{agent.name}</TableCell>
                                <TableCell className="text-right">{agent.visitsThisMonth}</TableCell>
                                <TableCell className="text-right">{agent.casesResolved}</TableCell>
                                <TableCell className="text-right">{agent.avgResponseTime} min</TableCell>
                                <TableCell className="text-right">
                                    <Button
                                        variant="ghost"
                                        size="sm"
                                        onClick={() => onViewDetails(agent.id)}
                                    >
                                        <Eye className="h-4 w-4" />
                                    </Button>
                                </TableCell>
                            </TableRow>
                        ))}
                    </TableBody>
                </Table>
            </CardContent>
        </Card>
    );
}

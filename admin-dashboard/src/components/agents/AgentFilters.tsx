"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { AgentFilters } from "@/services/agent.service";

interface AgentFiltersComponentProps {
    onFiltersChange: (filters: AgentFilters) => void;
}

export function AgentFiltersComponent({ onFiltersChange }: AgentFiltersComponentProps) {
    const [startDate, setStartDate] = useState("");
    const [endDate, setEndDate] = useState("");
    const [zone, setZone] = useState("");

    const handleApplyFilters = () => {
        const filters: AgentFilters = {};
        if (startDate) filters.startDate = startDate;
        if (endDate) filters.endDate = endDate;
        if (zone) filters.zone = zone;

        onFiltersChange(filters);
    };

    const handleReset = () => {
        setStartDate("");
        setEndDate("");
        setZone("");
        onFiltersChange({});
    };

    return (
        <div className="bg-white p-4 rounded-lg shadow space-y-4">
            <h3 className="font-semibold text-lg">Filtres</h3>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="space-y-2">
                    <Label htmlFor="startDate">Date début</Label>
                    <Input
                        id="startDate"
                        type="date"
                        value={startDate}
                        onChange={(e) => setStartDate(e.target.value)}
                    />
                </div>

                <div className="space-y-2">
                    <Label htmlFor="endDate">Date fin</Label>
                    <Input
                        id="endDate"
                        type="date"
                        value={endDate}
                        onChange={(e) => setEndDate(e.target.value)}
                    />
                </div>

                <div className="space-y-2">
                    <Label htmlFor="zone">Zone</Label>
                    <Input
                        id="zone"
                        placeholder="Ex: Port-au-Prince"
                        value={zone}
                        onChange={(e) => setZone(e.target.value)}
                    />
                </div>
            </div>

            <div className="flex gap-2">
                <Button onClick={handleApplyFilters}>Appliquer</Button>
                <Button variant="outline" onClick={handleReset}>Réinitialiser</Button>
            </div>
        </div>
    );
}

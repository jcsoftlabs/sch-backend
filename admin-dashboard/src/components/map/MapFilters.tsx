"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from "@/components/ui/select";
import { MapFilters } from "@/services/map.service";

interface MapFiltersProps {
    onFiltersChange: (filters: MapFilters) => void;
}

export function MapFiltersComponent({ onFiltersChange }: MapFiltersProps) {
    const [startDate, setStartDate] = useState("");
    const [endDate, setEndDate] = useState("");
    const [disease, setDisease] = useState("");
    const [zone, setZone] = useState("");
    const [urgency, setUrgency] = useState<"NORMAL" | "URGENT" | "CRITICAL" | "">("");

    const handleApplyFilters = () => {
        const filters: MapFilters = {};
        if (startDate) filters.startDate = startDate;
        if (endDate) filters.endDate = endDate;
        if (disease) filters.disease = disease;
        if (zone) filters.zone = zone;
        if (urgency) filters.urgency = urgency as "NORMAL" | "URGENT" | "CRITICAL";

        onFiltersChange(filters);
    };

    const handleReset = () => {
        setStartDate("");
        setEndDate("");
        setDisease("");
        setZone("");
        setUrgency("");
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

                <div className="space-y-2">
                    <Label htmlFor="disease">Maladie</Label>
                    <Input
                        id="disease"
                        placeholder="Ex: Cholera"
                        value={disease}
                        onChange={(e) => setDisease(e.target.value)}
                    />
                </div>

                <div className="space-y-2">
                    <Label htmlFor="urgency">Urgence</Label>
                    <Select value={urgency} onValueChange={(value) => setUrgency(value as any)}>
                        <SelectTrigger id="urgency">
                            <SelectValue placeholder="Sélectionner" />
                        </SelectTrigger>
                        <SelectContent>
                            <SelectItem value="NORMAL">Normal</SelectItem>
                            <SelectItem value="URGENT">Urgent</SelectItem>
                            <SelectItem value="CRITICAL">Critique</SelectItem>
                        </SelectContent>
                    </Select>
                </div>
            </div>

            <div className="flex gap-2">
                <Button onClick={handleApplyFilters}>Appliquer</Button>
                <Button variant="outline" onClick={handleReset}>Réinitialiser</Button>
            </div>
        </div>
    );
}

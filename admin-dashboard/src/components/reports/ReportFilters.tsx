"use client";

import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
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

interface ReportFiltersProps {
    onFiltersChange: (filters: {
        startDate: string;
        endDate: string;
        zone: string;
        format: "PDF" | "CSV";
    }) => void;
}

export function ReportFilters({ onFiltersChange }: ReportFiltersProps) {
    const [startDate, setStartDate] = useState("");
    const [endDate, setEndDate] = useState("");
    const [zone, setZone] = useState("");
    const [format, setFormat] = useState<"PDF" | "CSV">("PDF");

    const handleApply = () => {
        onFiltersChange({ startDate, endDate, zone, format });
    };

    return (
        <Card>
            <CardHeader>
                <CardTitle>Paramètres du Rapport</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div className="space-y-2">
                        <Label htmlFor="startDate">Date début *</Label>
                        <Input
                            id="startDate"
                            type="date"
                            value={startDate}
                            onChange={(e) => setStartDate(e.target.value)}
                            required
                        />
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="endDate">Date fin *</Label>
                        <Input
                            id="endDate"
                            type="date"
                            value={endDate}
                            onChange={(e) => setEndDate(e.target.value)}
                            required
                        />
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="zone">Zone (optionnel)</Label>
                        <Input
                            id="zone"
                            placeholder="Ex: Port-au-Prince"
                            value={zone}
                            onChange={(e) => setZone(e.target.value)}
                        />
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="format">Format *</Label>
                        <Select value={format} onValueChange={(value: "PDF" | "CSV") => setFormat(value)}>
                            <SelectTrigger id="format">
                                <SelectValue />
                            </SelectTrigger>
                            <SelectContent>
                                <SelectItem value="PDF">PDF</SelectItem>
                                <SelectItem value="CSV">CSV</SelectItem>
                            </SelectContent>
                        </Select>
                    </div>
                </div>
            </CardContent>
        </Card>
    );
}

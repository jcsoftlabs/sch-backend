"use client";

import { useEffect, useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import dynamic from "next/dynamic";

// Dynamic import for Leaflet map to avoid SSR issues
const MapWithNoSSR = dynamic(
    () => import("@/components/dashboard/map/HaitiMap"),
    {
        ssr: false,
        loading: () => <Skeleton className="h-[600px] w-full rounded-lg" />,
    }
);

export default function MapPage() {
    return (
        <div className="flex-1 space-y-4 p-4 md:p-8 pt-6">
            <div className="flex items-center justify-between space-y-2">
                <h2 className="text-3xl font-bold tracking-tight">Carte Interactive</h2>
            </div>

            <Card className="card-elevated">
                <CardHeader>
                    <CardTitle>Couverture Sanitaire Nationale</CardTitle>
                </CardHeader>
                <CardContent className="p-0">
                    <div className="h-[600px] w-full relative z-0">
                        <MapWithNoSSR />
                    </div>
                </CardContent>
            </Card>
        </div>
    );
}

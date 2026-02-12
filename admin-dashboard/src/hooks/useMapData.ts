"use client";

import { useEffect, useState } from "react";
import { MapService, MapData, MapFilters } from "@/services/map.service";

export function useMapData(filters?: MapFilters) {
    const [data, setData] = useState<MapData | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<Error | null>(null);

    useEffect(() => {
        const fetchData = async () => {
            try {
                setLoading(true);
                const mapData = await MapService.getMapData(filters);
                setData(mapData);
                setError(null);
            } catch (err) {
                setError(err as Error);
            } finally {
                setLoading(false);
            }
        };

        fetchData();
    }, [filters?.startDate, filters?.endDate, filters?.disease, filters?.zone, filters?.urgency]);

    return { data, loading, error };
}

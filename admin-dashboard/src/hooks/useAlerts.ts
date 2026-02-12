"use client";

import { useEffect, useState } from "react";
import { AlertService, EpidemiologicalAlert } from "@/services/alert.service";

export function useAlerts() {
    const [data, setData] = useState<EpidemiologicalAlert[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<Error | null>(null);

    const fetchAlerts = async () => {
        try {
            setLoading(true);
            const alerts = await AlertService.getAlerts();
            setData(alerts);
            setError(null);
        } catch (err) {
            setError(err as Error);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchAlerts();
    }, []);

    return { data, loading, error, refetch: fetchAlerts };
}

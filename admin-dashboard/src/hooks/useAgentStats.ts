"use client";

import { useEffect, useState } from "react";
import { AgentService, AgentStats, AgentFilters } from "@/services/agent.service";

export function useAgentStats(filters?: AgentFilters) {
    const [data, setData] = useState<AgentStats | null>(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<Error | null>(null);

    useEffect(() => {
        const fetchData = async () => {
            try {
                setLoading(true);
                const stats = await AgentService.getAgentStats(filters);
                setData(stats);
                setError(null);
            } catch (err) {
                setError(err as Error);
            } finally {
                setLoading(false);
            }
        };

        fetchData();
    }, [filters?.startDate, filters?.endDate, filters?.zone]);

    return { data, loading, error };
}

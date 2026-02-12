"use client";

import { useEffect, useState } from "react";
import { ReportService, ReportTemplate } from "@/services/report.service";

export function useReportTemplates() {
    const [data, setData] = useState<ReportTemplate[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<Error | null>(null);

    useEffect(() => {
        const fetchTemplates = async () => {
            try {
                setLoading(true);
                const templates = await ReportService.getTemplates();
                setData(templates);
                setError(null);
            } catch (err) {
                setError(err as Error);
            } finally {
                setLoading(false);
            }
        };
        fetchTemplates();
    }, []);

    return { data, loading, error };
}

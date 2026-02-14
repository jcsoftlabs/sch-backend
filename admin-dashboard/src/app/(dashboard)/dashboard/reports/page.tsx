import { ReportBuilder } from "@/components/reports/ReportBuilder";

export default function ReportsPage() {
    return (
        <div className="flex-1 space-y-8 p-8 pt-6">
            <div className="flex items-center justify-between space-y-2">
                <div>
                    <h2 className="text-3xl font-bold tracking-tight text-slate-900">Rapports & Analyses</h2>
                    <p className="text-slate-500">
                        Générez et exportez des rapports détaillés sur les activités, les stocks et la santé publique.
                    </p>
                </div>
            </div>

            <ReportBuilder />
        </div>
    );
}

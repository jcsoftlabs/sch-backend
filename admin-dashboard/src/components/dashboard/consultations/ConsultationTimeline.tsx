import { CheckCircle2, Circle, Clock } from "lucide-react";
import { cn } from "@/lib/utils";

interface TimelineEvent {
    id: string;
    title: string;
    description?: string;
    time: string;
    status: "completed" | "current" | "pending";
}

export function ConsultationTimeline({ events }: { events: TimelineEvent[] }) {
    return (
        <div className="space-y-6">
            <h3 className="text-sm font-medium text-slate-500 uppercase tracking-wider mb-4">Chronologie</h3>
            <div className="relative border-l border-slate-200 ml-3 space-y-8 pb-4">
                {events.map((event, idx) => (
                    <div key={event.id} className="relative pl-6">
                        <span className={cn(
                            "absolute -left-2.5 top-0 h-5 w-5 rounded-full border-2 bg-white flex items-center justify-center",
                            event.status === "completed" ? "border-blue-600 text-blue-600" :
                                event.status === "current" ? "border-blue-600 bg-blue-50 text-blue-600" :
                                    "border-slate-300 text-slate-300"
                        )}>
                            {event.status === "completed" ? <CheckCircle2 className="h-3 w-3" /> : <Circle className="h-3 w-3 fill-current" />}
                        </span>
                        <div className="flex flex-col">
                            <span className="text-xs font-semibold text-slate-500 mb-0.5 flex items-center gap-1">
                                <Clock className="h-3 w-3" /> {event.time}
                            </span>
                            <h4 className={cn("text-sm font-bold", event.status === "pending" ? "text-slate-500" : "text-slate-900")}>
                                {event.title}
                            </h4>
                            {event.description && (
                                <p className="text-xs text-slate-500 mt-1">{event.description}</p>
                            )}
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
}

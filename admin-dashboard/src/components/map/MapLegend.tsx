"use client";

export function MapLegend() {
    const legendItems = [
        { color: "red", label: "Hôpital", type: "HOSPITAL" },
        { color: "blue", label: "Clinique", type: "CLINIC" },
        { color: "green", label: "Dispensaire", type: "DISPENSARY" },
        { color: "yellow", label: "Poste de santé", type: "HEALTH_POST" },
    ];

    return (
        <div className="bg-white p-4 rounded-lg shadow">
            <h3 className="font-semibold text-sm mb-3">Légende</h3>
            <div className="space-y-2">
                {legendItems.map((item) => (
                    <div key={item.type} className="flex items-center gap-2">
                        <div
                            className="w-4 h-4 rounded-full"
                            style={{ backgroundColor: item.color }}
                        />
                        <span className="text-sm">{item.label}</span>
                    </div>
                ))}
            </div>
        </div>
    );
}

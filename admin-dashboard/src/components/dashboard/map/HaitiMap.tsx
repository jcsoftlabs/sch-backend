"use client";

import { MapContainer, TileLayer, Marker, Popup, CircleMarker } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import L from "leaflet";
import { HealthCenter } from "../HealthCenterTable";

// Fix for default marker icon in Next.js
const iconUrl = "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png";
const iconRetinaUrl = "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png";
const shadowUrl = "https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png";

const customIcon = new L.Icon({
    iconUrl: iconUrl,
    iconRetinaUrl: iconRetinaUrl,
    shadowUrl: shadowUrl,
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
    shadowSize: [41, 41]
});

interface HaitiMapProps {
    centers?: HealthCenter[];
}

export default function HaitiMap({ centers = [] }: HaitiMapProps) {
    // Filter centers that have coordinates
    const validCenters = centers.filter(c => c.lat && c.lng);

    return (
        <MapContainer
            center={[19.0, -72.5]} // Centers roughly on Haiti
            zoom={8}
            style={{ height: "100%", width: "100%", borderRadius: "0.5rem" }}
            scrollWheelZoom={false}
        >
            <TileLayer
                attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            />

            {validCenters.map((center) => (
                <Marker
                    key={center.id}
                    position={[center.lat!, center.lng!]}
                    icon={customIcon}
                >
                    <Popup>
                        <div className="p-1">
                            <h3 className="font-bold text-sm text-slate-900">{center.name}</h3>
                            <p className="text-xs text-slate-600 font-medium">{center.address}</p>
                            {center.phone && <p className="text-xs text-slate-500">{center.phone}</p>}
                            <div className="mt-2 flex items-center justify-between">
                                <span className={`text-xs font-bold px-2 py-0.5 rounded-full bg-blue-100 text-blue-700`}>
                                    Capacité: {center.capacity || '?'}
                                </span>
                            </div>
                        </div>
                    </Popup>
                </Marker>
            ))}
        </MapContainer>
    );
}

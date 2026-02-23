"use client";

import { MapContainer, TileLayer, Marker, Popup } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import L from "leaflet";

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

interface HouseholdMapProps {
    location: {
        lat: number;
        lng: number;
        name: string;
        address?: string;
    } | null;
}

export default function HouseholdMap({ location }: HouseholdMapProps) {
    if (!location || !location.lat || !location.lng) {
        return <div className="h-full w-full bg-slate-100 flex items-center justify-center text-slate-500 rounded-lg">Coordonnées GPS non disponibles</div>;
    }

    return (
        <MapContainer
            center={[location.lat, location.lng]}
            zoom={15}
            style={{ height: "100%", width: "100%", borderRadius: "0.5rem", zIndex: 10 }}
            scrollWheelZoom={false}
        >
            <TileLayer
                attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            />

            <Marker
                position={[location.lat, location.lng]}
                icon={customIcon}
            >
                <Popup>
                    <div className="p-1">
                        <h3 className="font-bold text-sm text-slate-900">{location.name}</h3>
                        {location.address && <p className="text-xs text-slate-600 font-medium">{location.address}</p>}
                    </div>
                </Popup>
            </Marker>
        </MapContainer>
    );
}

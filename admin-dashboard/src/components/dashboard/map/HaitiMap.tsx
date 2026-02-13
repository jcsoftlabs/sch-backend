"use client";

import { MapContainer, TileLayer, Marker, Popup, CircleMarker } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import L from "leaflet";
import { useEffect } from "react";

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

// Mock Data for Health Centers
const healthCenters = [
    { id: 1, name: "Hôpital de l'Université d'État d'Haïti", lat: 18.5392, lng: -72.3350, type: "Hôpital", cases: 45 },
    { id: 2, name: "Hôpital Universitaire de Mirebalais", lat: 18.8346, lng: -72.1037, type: "Hôpital", cases: 32 },
    { id: 3, name: "Hôpital Justinien (Cap-Haïtien)", lat: 19.7595, lng: -72.2045, type: "Hôpital", cases: 28 },
    { id: 4, name: "Centre de Santé de Carrefour", lat: 18.5358, lng: -72.4042, type: "Centre", cases: 15 },
    { id: 5, name: "Hôpital Immaculée Conception (Les Cayes)", lat: 18.1936, lng: -73.7483, type: "Hôpital", cases: 22 },
    { id: 6, name: "Hôpital Saint-Michel (Jacmel)", lat: 18.2355, lng: -72.5367, type: "Hôpital", cases: 18 },
    { id: 7, name: "Centre de Santé de Gonaïves", lat: 19.4526, lng: -72.6791, type: "Centre", cases: 35 },
    { id: 8, name: "Dispensaire de Hinche", lat: 19.1446, lng: -72.0088, type: "Dispensaire", cases: 12 },
    { id: 9, name: "Centre Médical de Port-de-Paix", lat: 19.9389, lng: -72.8306, type: "Centre", cases: 10 },
    { id: 10, name: "Hôpital Saint-Antoine (Jérémie)", lat: 18.6441, lng: -74.1130, type: "Hôpital", cases: 14 }
];

export default function HaitiMap() {
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

            {healthCenters.map((center) => (
                <Marker
                    key={center.id}
                    position={[center.lat, center.lng]}
                    icon={customIcon}
                >
                    <Popup>
                        <div className="p-1">
                            <h3 className="font-bold text-sm text-slate-900">{center.name}</h3>
                            <p className="text-xs text-slate-600 font-medium">{center.type}</p>
                            <div className="mt-2 flex items-center justify-between">
                                <span className="text-xs text-slate-500">Cas actifs:</span>
                                <span className={`text-xs font-bold px-2 py-0.5 rounded-full ${center.cases > 30 ? 'bg-red-100 text-red-700' : 'bg-green-100 text-green-700'}`}>
                                    {center.cases}
                                </span>
                            </div>
                        </div>
                    </Popup>
                </Marker>
            ))}

            {/* Heatmap simulation using CircleMarkers */}
            {healthCenters.map((center) => (
                <CircleMarker
                    key={`circle-${center.id}`}
                    center={[center.lat, center.lng]}
                    pathOptions={{
                        fillColor: center.cases > 30 ? 'red' : 'blue',
                        color: center.cases > 30 ? 'red' : 'blue',
                        opacity: 0.1,
                        fillOpacity: 0.2
                    }}
                    radius={center.cases * 1.5}
                    stroke={false}
                />
            ))}
        </MapContainer>
    );
}

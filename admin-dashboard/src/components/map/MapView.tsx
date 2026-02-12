"use client";

import { GoogleMap, LoadScript, Marker, InfoWindow } from "@react-google-maps/api";
import { useState } from "react";
import { HealthCenter } from "@/services/map.service";

interface MapViewProps {
    healthCenters: HealthCenter[];
    center?: { lat: number; lng: number };
    zoom?: number;
}

const containerStyle = {
    width: "100%",
    height: "600px",
};

const defaultCenter = {
    lat: 18.5944, // Port-au-Prince, Haiti
    lng: -72.3074,
};

export function MapView({ healthCenters, center = defaultCenter, zoom = 10 }: MapViewProps) {
    const [selectedCenter, setSelectedCenter] = useState<HealthCenter | null>(null);
    const apiKey = process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY || "";

    return (
        <LoadScript googleMapsApiKey={apiKey}>
            <GoogleMap
                mapContainerStyle={containerStyle}
                center={center}
                zoom={zoom}
                options={{
                    streetViewControl: false,
                    mapTypeControl: true,
                }}
            >
                {healthCenters.map((healthCenter) => (
                    <Marker
                        key={healthCenter.id}
                        position={{
                            lat: healthCenter.latitude,
                            lng: healthCenter.longitude,
                        }}
                        onClick={() => setSelectedCenter(healthCenter)}
                        icon={{
                            url: getMarkerIcon(healthCenter.type),
                            scaledSize: new window.google.maps.Size(40, 40),
                        }}
                    />
                ))}

                {selectedCenter && (
                    <InfoWindow
                        position={{
                            lat: selectedCenter.latitude,
                            lng: selectedCenter.longitude,
                        }}
                        onCloseClick={() => setSelectedCenter(null)}
                    >
                        <div className="p-2">
                            <h3 className="font-bold text-lg">{selectedCenter.name}</h3>
                            <p className="text-sm text-gray-600">{selectedCenter.type}</p>
                            <div className="mt-2 space-y-1">
                                <p className="text-sm">
                                    <span className="font-semibold">Agents actifs:</span>{" "}
                                    {selectedCenter.activeAgents}
                                </p>
                                <p className="text-sm">
                                    <span className="font-semibold">Consultations:</span>{" "}
                                    {selectedCenter.totalConsultations}
                                </p>
                            </div>
                        </div>
                    </InfoWindow>
                )}
            </GoogleMap>
        </LoadScript>
    );
}

function getMarkerIcon(type: string): string {
    const baseUrl = "http://maps.google.com/mapfiles/ms/icons/";
    switch (type.toUpperCase()) {
        case "HOSPITAL":
            return `${baseUrl}red-dot.png`;
        case "CLINIC":
            return `${baseUrl}blue-dot.png`;
        case "DISPENSARY":
            return `${baseUrl}green-dot.png`;
        case "HEALTH_POST":
            return `${baseUrl}yellow-dot.png`;
        default:
            return `${baseUrl}blue-dot.png`;
    }
}

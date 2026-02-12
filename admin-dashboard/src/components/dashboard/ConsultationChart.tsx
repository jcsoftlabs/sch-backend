"use client";

import {
    Chart as ChartJS,
    CategoryScale,
    LinearScale,
    BarElement,
    Title,
    Tooltip,
    Legend,
} from "chart.js";
import { Bar } from "react-chartjs-2";

ChartJS.register(
    CategoryScale,
    LinearScale,
    BarElement,
    Title,
    Tooltip,
    Legend
);

export const options = {
    responsive: true,
    plugins: {
        legend: {
            position: "top" as const,
        },
        title: {
            display: false,
            text: "Consultations par mois",
        },
    },
};

const labels = ["Jan", "Fev", "Mar", "Avr", "Mai", "Jun", "Jul"];

export const data = {
    labels,
    datasets: [
        {
            label: "Consultations",
            data: [120, 190, 300, 500, 200, 300, 450],
            backgroundColor: "rgba(53, 162, 235, 0.5)",
        },
        {
            label: "Patients",
            data: [80, 120, 150, 200, 150, 200, 300],
            backgroundColor: "rgba(75, 192, 192, 0.5)",
        }
    ],
};

export function ConsultationChart() {
    return <Bar options={options} data={data} />;
}

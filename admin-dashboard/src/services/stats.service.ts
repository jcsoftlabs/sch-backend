import api from "@/lib/api";

export interface DashboardStats {
    totalConsultations: number;
    activePatients: number;
    totalCenters: number;
    activeAgents: number;
    revenue: number; // Mocked for now if backend doesn't have it
}

export const StatsService = {
    getOverview: async (): Promise<DashboardStats> => {
        // If backend doesn't have a dedicated stats endpoint, we might need to fetch counts separately
        // For now, let's assume we might need to mock or fetch lists and count.
        // Ideally, backend should provide /analytics/overview
        try {
            // Check if we can get stats. If not, return mocks or calculated values
            const [patients, consultations, centers, users] = await Promise.all([
                api.get('/patients'),
                api.get('/consultations'),
                api.get('/centers'),
                api.get('/users')
            ]);

            // Backend returns {status, data: {patients: [...], consultations: [...], healthCenters: [...], users: [...]}}
            const patientsData = patients.data.data?.patients || patients.data.patients || patients.data.data || patients.data;
            const consultationsData = consultations.data.data?.consultations || consultations.data.consultations || consultations.data.data || consultations.data;
            const centersData = centers.data.data?.healthCenters || centers.data.healthCenters || centers.data.data || centers.data;
            const usersData = users.data.data?.users || users.data.users || users.data.data || users.data;

            // Filter agents (users with role AGENT)
            const agentsCount = usersData.filter((u: any) => u.role === "AGENT").length;

            return {
                totalConsultations: consultationsData.length,
                activePatients: patientsData.length,
                totalCenters: centersData.length,
                activeAgents: agentsCount,
                revenue: consultationsData.length * 25 // Mock revenue calculation
            };
        } catch (error) {
            console.error("Error fetching stats:", error);
            return {
                totalConsultations: 0,
                activePatients: 0,
                totalCenters: 0,
                activeAgents: 0,
                revenue: 0
            };
        }
    }
};


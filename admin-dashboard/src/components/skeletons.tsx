import { Skeleton } from "@/components/ui/skeleton"
import { Card, CardContent, CardHeader } from "@/components/ui/card"

export function DashboardSkeleton() {
    return (
        <div className="flex-1 space-y-4">
            <div className="flex items-center justify-between space-y-2">
                <Skeleton className="h-9 w-[200px]" />
            </div>

            {/* Stats Cards */}
            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
                {Array(4).fill(0).map((_, i) => (
                    <Card key={i}>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <Skeleton className="h-4 w-[100px]" />
                            <Skeleton className="h-4 w-4 rounded-full" />
                        </CardHeader>
                        <CardContent>
                            <Skeleton className="h-8 w-[60px] mb-2" />
                            <Skeleton className="h-3 w-[120px]" />
                        </CardContent>
                    </Card>
                ))}
            </div>

            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-7">
                {/* Chart Skeleton */}
                <Card className="col-span-4">
                    <CardHeader>
                        <Skeleton className="h-6 w-[150px]" />
                    </CardHeader>
                    <CardContent className="pl-2">
                        <Skeleton className="h-[350px] w-full" />
                    </CardContent>
                </Card>

                {/* Recent Consultations Skeleton */}
                <Card className="col-span-3">
                    <CardHeader>
                        <Skeleton className="h-6 w-[200px]" />
                    </CardHeader>
                    <CardContent>
                        <div className="space-y-8">
                            {Array(5).fill(0).map((_, i) => (
                                <div key={i} className="flex items-center">
                                    <div className="space-y-2">
                                        <Skeleton className="h-4 w-[150px]" />
                                        <Skeleton className="h-3 w-[100px]" />
                                    </div>
                                    <Skeleton className="ml-auto h-4 w-[80px]" />
                                </div>
                            ))}
                        </div>
                    </CardContent>
                </Card>
            </div>
        </div>
    )
}

export function TableSkeleton() {
    return (
        <div className="space-y-4">
            <div className="flex items-center justify-between">
                <Skeleton className="h-8 w-[250px]" />
                <Skeleton className="h-8 w-[100px]" />
            </div>
            <div className="rounded-md border p-4 space-y-4">
                <div className="flex items-center space-x-4 border-b pb-4">
                    <Skeleton className="h-4 w-[100px]" />
                    <Skeleton className="h-4 w-[150px]" />
                    <Skeleton className="h-4 flex-1" />
                    <Skeleton className="h-4 w-[80px]" />
                    <Skeleton className="h-4 w-[120px]" />
                </div>
                {Array(5).fill(0).map((_, i) => (
                    <div key={i} className="flex items-center space-x-4">
                        <Skeleton className="h-4 w-[100px]" />
                        <Skeleton className="h-4 w-[150px]" />
                        <Skeleton className="h-4 flex-1" />
                        <Skeleton className="h-4 w-[80px]" />
                        <Skeleton className="h-4 w-[120px]" />
                    </div>
                ))}
            </div>
        </div>
    )
}

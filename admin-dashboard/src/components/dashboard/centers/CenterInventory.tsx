"use client";

import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";

export function CenterInventory({ inventory }: { inventory: any[] }) {
    if (!inventory || inventory.length === 0) {
        return <div className="text-center py-8 text-slate-500">Inventaire non disponible.</div>;
    }

    return (
        <div className="rounded-md border">
            <Table>
                <TableHeader>
                    <TableRow className="bg-slate-50">
                        <TableHead className="font-bold text-slate-700">Article</TableHead>
                        <TableHead className="font-bold text-slate-700">Catégorie</TableHead>
                        <TableHead className="font-bold text-slate-700">Stock</TableHead>
                        <TableHead className="font-bold text-slate-700 w-[100px]">Niveau</TableHead>
                    </TableRow>
                </TableHeader>
                <TableBody>
                    {inventory.map((item) => (
                        <TableRow key={item.id}>
                            <TableCell className="font-medium">{item.name}</TableCell>
                            <TableCell>{item.category}</TableCell>
                            <TableCell>
                                <div className="flex items-center space-x-2">
                                    <span className={item.quantity < item.minThreshold ? "text-red-600 font-bold" : ""}>
                                        {item.quantity}
                                    </span>
                                    <span className="text-slate-500 text-xs">/ {item.unit}</span>
                                </div>
                            </TableCell>
                            <TableCell>
                                <Progress
                                    value={(item.quantity / item.maxCapacity) * 100}
                                    className={`h-2 ${item.quantity < item.minThreshold ? "bg-red-100" : ""}`}
                                // Note: Progress component might need custom color handling or className override for the indicator
                                />
                            </TableCell>
                        </TableRow>
                    ))}
                </TableBody>
            </Table>
        </div>
    );
}

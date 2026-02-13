"use client";

import { usePathname } from "next/navigation";
import Link from "next/link";
import { ChevronRight, Home } from "lucide-react";
import { Fragment } from "react";

export function Breadcrumbs() {
    const pathname = usePathname();

    // Parse pathname into breadcrumb segments
    const segments = pathname.split("/").filter(Boolean);

    // Create breadcrumb items
    const breadcrumbs = segments.map((segment, index) => {
        const href = "/" + segments.slice(0, index + 1).join("/");
        const label = segment
            .split("-")
            .map(word => word.charAt(0).toUpperCase() + word.slice(1))
            .join(" ");

        return { href, label };
    });

    return (
        <nav className="flex items-center space-x-2 text-sm">
            <Link
                href="/dashboard"
                className="flex items-center text-slate-600 hover:text-slate-900 transition-colors"
            >
                <Home className="h-4 w-4" />
            </Link>

            {breadcrumbs.map((crumb, index) => (
                <Fragment key={crumb.href}>
                    <ChevronRight className="h-4 w-4 text-slate-400" />
                    {index === breadcrumbs.length - 1 ? (
                        <span className="font-medium text-slate-900">{crumb.label}</span>
                    ) : (
                        <Link
                            href={crumb.href}
                            className="text-slate-600 hover:text-slate-900 transition-colors"
                        >
                            {crumb.label}
                        </Link>
                    )}
                </Fragment>
            ))}
        </nav>
    );
}

import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/lib/utils";
import { Loader2 } from "lucide-react";

const buttonVariants = cva(
    "inline-flex items-center justify-center whitespace-nowrap rounded-lg text-sm font-medium ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 active:scale-95",
    {
        variants: {
            variant: {
                default: "bg-primary text-white hover:bg-blue-700 shadow-lg shadow-blue-500/25",
                destructive:
                    "bg-red-500 text-white hover:bg-red-600 shadow-lg shadow-red-500/25",
                outline:
                    "border border-input bg-background hover:bg-slate-100 hover:text-slate-900",
                secondary:
                    "bg-secondary text-white hover:bg-cyan-600 shadow-lg shadow-cyan-500/25",
                ghost: "hover:bg-slate-100 hover:text-slate-900",
                link: "text-primary underline-offset-4 hover:underline",
                white: "bg-white text-primary hover:bg-slate-50 shadow-lg shadow-slate-200/20",
            },
            size: {
                default: "h-10 px-4 py-2",
                sm: "h-9 rounded-md px-3",
                lg: "h-12 rounded-lg px-8 text-base",
                icon: "h-10 w-10",
            },
        },
        defaultVariants: {
            variant: "default",
            size: "default",
        },
    }
);

/* 
 * Need smooth install of cva + manual impl if not using shadcn
 * Actually I forgot to install class-variance-authority. 
 * I will install it in the next step or just rewrite this to not use cva if I want to save a step.
 * But CVA is cleaner. I will use standard props for now to be fast and dependency-light if I didn't install CVA.
 * Wait, I didn't install `class-variance-authority`. 
 * I will use a simpler implementation to avoid extra install unless I install it. 
 * I'll install it, it's worth it for "Production Ready".
*/
export interface ButtonProps
    extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
    asChild?: boolean;
    isLoading?: boolean;
}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
    ({ className, variant, size, asChild = false, isLoading, children, ...props }, ref) => {
        return (
            <button
                className={cn(buttonVariants({ variant, size, className }))}
                ref={ref}
                disabled={isLoading || props.disabled}
                {...props}
            >
                {isLoading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                {children}
            </button>
        );
    }
);
Button.displayName = "Button";

export { Button, buttonVariants };

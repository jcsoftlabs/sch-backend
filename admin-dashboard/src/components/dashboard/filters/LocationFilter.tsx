"use client"

import * as React from "react"
import { Check, ChevronsUpDown, MapPin } from "lucide-react"

import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"
import {
    Command,
    CommandEmpty,
    CommandGroup,
    CommandInput,
    CommandItem,
    CommandList,
} from "@/components/ui/command"
import {
    Popover,
    PopoverContent,
    PopoverTrigger,
} from "@/components/ui/popover"

const locations = [
    {
        value: "ouest",
        label: "Ouest (Port-au-Prince)",
    },
    {
        value: "nord",
        label: "Nord (Cap-Haïtien)",
    },
    {
        value: "artibonite",
        label: "Artibonite (Gonaïves)",
    },
    {
        value: "sud",
        label: "Sud (Les Cayes)",
    },
    {
        value: "centre",
        label: "Centre (Hinche)",
    },
]

export function LocationFilter() {
    const [open, setOpen] = React.useState(false)
    const [value, setValue] = React.useState("")

    return (
        <Popover open={open} onOpenChange={setOpen}>
            <PopoverTrigger asChild>
                <Button
                    variant="outline"
                    role="combobox"
                    aria-expanded={open}
                    className="w-[200px] justify-between border-slate-300"
                >
                    <div className="flex items-center gap-2">
                        <MapPin className="h-4 w-4 shrink-0 opacity-50" />
                        {value
                            ? locations.find((framework) => framework.value === value)?.label
                            : "Département..."}
                    </div>
                    <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                </Button>
            </PopoverTrigger>
            <PopoverContent className="w-[200px] p-0">
                <Command>
                    <CommandInput placeholder="Rechercher..." />
                    <CommandList>
                        <CommandEmpty>Aucun département trouvé.</CommandEmpty>
                        <CommandGroup>
                            {locations.map((framework) => (
                                <CommandItem
                                    key={framework.value}
                                    value={framework.value}
                                    onSelect={(currentValue) => {
                                        setValue(currentValue === value ? "" : currentValue)
                                        setOpen(false)
                                    }}
                                >
                                    <Check
                                        className={cn(
                                            "mr-2 h-4 w-4",
                                            value === framework.value ? "opacity-100" : "opacity-0"
                                        )}
                                    />
                                    {framework.label}
                                </CommandItem>
                            ))}
                        </CommandGroup>
                    </CommandList>
                </Command>
            </PopoverContent>
        </Popover>
    )
}

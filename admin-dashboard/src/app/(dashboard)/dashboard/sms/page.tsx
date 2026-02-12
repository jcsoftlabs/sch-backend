"use client";

import { useEffect, useState } from "react";
import { useSMS } from "@/hooks/useSMS";
import { SMSHistoryTable } from "@/components/sms/SMSHistoryTable";
import { SendSMSDialog } from "@/components/sms/SendSMSDialog";
import { Button } from "@/components/ui/button";
import { MessageSquare, Plus } from "lucide-react";
import { TableSkeleton } from "@/components/skeletons";

export default function SMSPage() {
    const { messages, loading, fetchMyHistory, sendSMS } = useSMS();
    const [dialogOpen, setDialogOpen] = useState(false);

    useEffect(() => {
        fetchMyHistory();
    }, [fetchMyHistory]);

    return (
        <div className="hidden h-full flex-1 flex-col space-y-8 p-8 md:flex">
            <div className="flex items-center justify-between space-y-2">
                <div>
                    <h2 className="text-2xl font-bold tracking-tight">Messages SMS</h2>
                    <p className="text-muted-foreground">
                        Historique des communications et envoi de messages aux patients.
                    </p>
                </div>
                <Button onClick={() => setDialogOpen(true)}>
                    <Plus className="mr-2 h-4 w-4" />
                    Nouveau Message
                </Button>
            </div>

            <div className="rounded-md border bg-card text-card-foreground shadow-sm p-6">
                <div className="flex items-center space-x-2 mb-6">
                    <MessageSquare className="h-5 w-5 text-muted-foreground" />
                    <h3 className="text-lg font-medium">Historique Récent</h3>
                </div>

                {loading && messages.length === 0 ? (
                    <TableSkeleton />
                ) : (
                    <SMSHistoryTable data={messages} />
                )}
            </div>

            <SendSMSDialog
                open={dialogOpen}
                onOpenChange={setDialogOpen}
                onSubmit={async (data) => { await sendSMS(data); }}
                isLoading={loading}
            />
        </div>
    );
}

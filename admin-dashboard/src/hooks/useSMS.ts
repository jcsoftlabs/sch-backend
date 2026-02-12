"use client";

import { useState, useCallback } from "react";
import { SMSService, SMS, SendSMSRequest } from "@/services/sms.service";
import { useToast } from "@/hooks/use-toast";

export function useSMS() {
    const [messages, setMessages] = useState<SMS[]>([]);
    const [loading, setLoading] = useState(false);
    const { toast } = useToast();

    const fetchMyHistory = useCallback(async () => {
        setLoading(true);
        try {
            const data = await SMSService.getMyHistory();
            setMessages(data);
        } catch (error) {
            console.error(error);
            toast({
                title: "Erreur",
                description: "Impossible de charger l'historique des SMS",
                variant: "destructive",
            });
        } finally {
            setLoading(false);
        }
    }, [toast]);

    const sendSMS = async (data: SendSMSRequest) => {
        setLoading(true);
        try {
            await SMSService.send(data);
            toast({
                title: "Succès",
                description: "Message envoyé avec succès",
            });
            // Refresh history if we're viewing it
            fetchMyHistory();
            return true;
        } catch (error) {
            console.error(error);
            toast({
                title: "Erreur",
                description: "Échec de l'envoi du message",
                variant: "destructive",
            });
            return false;
        } finally {
            setLoading(false);
        }
    };

    return {
        messages,
        loading,
        fetchMyHistory,
        sendSMS
    };
}

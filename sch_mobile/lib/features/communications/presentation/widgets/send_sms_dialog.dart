import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/sms_request_model.dart';
import '../providers/sms_providers.dart';

class SendSmsDialog extends ConsumerStatefulWidget {
  final String patientId;
  final String patientName;
  final String phoneNumber;

  const SendSmsDialog({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.phoneNumber,
  });

  @override
  ConsumerState<SendSmsDialog> createState() => _SendSmsDialogState();
}

class _SendSmsDialogState extends ConsumerState<SendSmsDialog> {
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendViaApi() async {
    if (!_formKey.currentState!.validate()) return;

    final request = SmsRequestModel(
      to: widget.phoneNumber,
      message: _messageController.text,
      patientId: widget.patientId,
    );

    try {
      await ref.read(sendSmsProvider.notifier).sendSms(request);
      if (mounted) {
        HapticFeedback.lightImpact();
        Navigator.pop(context, true); // true = success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('SMS envoyé à ${widget.patientName} avec succès.'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        HapticFeedback.vibrate();
        _showNativeFallbackDialog(e.toString());
      }
    }
  }

  void _showNativeFallbackDialog(String errorMsg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.wifi_off, color: AppTheme.errorColor),
            SizedBox(width: 8),
            Text('Erreur Réseau'),
          ],
        ),
        content: Text(
            'Impossible de joindre le serveur ($errorMsg).\n\nVoulez-vous envoyer ce SMS en utilisant le forfait téléphonique de votre appareil (SMS Natif) ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx); // Close secondary dialog
              _launchNativeSms();
            },
            icon: const Icon(Icons.sms),
            label: const Text('Oui, SMS Natif'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchNativeSms() async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: widget.phoneNumber,
      queryParameters: <String, String>{
        'body': _messageController.text,
      },
    );

    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
        if (mounted) {
          Navigator.pop(context, true); // Close the main dialog
        }
      } else {
        throw 'Impossible de lancer l\'application SMS native.';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final smsState = ref.watch(sendSmsProvider);
    final isLoading = smsState is AsyncLoading;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nouveau SMS',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: AppTheme.primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Destinataire: ${widget.patientName}\nNuméro: ${widget.phoneNumber}',
                        style: TextStyle(color: Colors.blueGrey[800], fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                maxLength: 160,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Tapez votre message ici...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Le message ne peut pas être vide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _sendViaApi,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  label: Text(isLoading ? 'Envoi en cours...' : 'Envoyer via Système ASCP'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

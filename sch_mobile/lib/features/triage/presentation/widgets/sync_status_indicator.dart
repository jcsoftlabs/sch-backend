import 'package:flutter/material.dart';

/// Widget to display sync status indicator
class SyncStatusIndicator extends StatelessWidget {
  final String syncStatus;
  final bool isCompact;

  const SyncStatusIndicator({
    super.key,
    required this.syncStatus,
    this.isCompact = false,
  });

  IconData get _icon {
    switch (syncStatus.toLowerCase()) {
      case 'synced':
        return Icons.cloud_done;
      case 'pending':
        return Icons.cloud_upload;
      case 'error':
        return Icons.cloud_off;
      default:
        return Icons.cloud_queue;
    }
  }

  Color get _color {
    switch (syncStatus.toLowerCase()) {
      case 'synced':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'error':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String get _label {
    switch (syncStatus.toLowerCase()) {
      case 'synced':
        return 'Synchronisé';
      case 'pending':
        return 'En attente';
      case 'error':
        return 'Erreur';
      default:
        return 'Inconnu';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Icon(
        _icon,
        color: _color,
        size: 16,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _icon,
          color: _color,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          _label,
          style: TextStyle(
            color: _color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

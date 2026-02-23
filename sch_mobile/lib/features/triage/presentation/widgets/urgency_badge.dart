import 'package:flutter/material.dart';
import '../../data/models/case_report_model.dart';

/// Badge widget to display urgency level with appropriate color and icon
class UrgencyBadge extends StatelessWidget {
  final UrgencyLevel urgency;
  final bool showLabel;
  final double size;

  const UrgencyBadge({
    super.key,
    required this.urgency,
    this.showLabel = true,
    this.size = 24,
  });

  Color get _color {
    switch (urgency) {
      case UrgencyLevel.critical:
        return const Color(0xFFEF4444); // red-500
      case UrgencyLevel.urgent:
        return const Color(0xFFF59E0B); // amber-500
      case UrgencyLevel.normal:
        return const Color(0xFF10B981); // green-500
    }
  }

  String get _icon {
    switch (urgency) {
      case UrgencyLevel.critical:
        return '🚨';
      case UrgencyLevel.urgent:
        return '⚠️';
      case UrgencyLevel.normal:
        return '✅';
    }
  }

  String get _label {
    switch (urgency) {
      case UrgencyLevel.critical:
        return 'CRITIQUE';
      case UrgencyLevel.urgent:
        return 'URGENT';
      case UrgencyLevel.normal:
        return 'NORMAL';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!showLabel) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          _icon,
          style: TextStyle(fontSize: size),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _icon,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 6),
          Text(
            _label,
            style: TextStyle(
              color: _color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

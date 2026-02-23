import 'package:flutter/material.dart';
import '../../data/models/medical_protocol_model.dart';

/// Card widget to display medical protocol information
class ProtocolCard extends StatefulWidget {
  final MedicalProtocolModel protocol;
  final List<String> matchedKeywords;
  final bool isExpandable;

  const ProtocolCard({
    super.key,
    required this.protocol,
    this.matchedKeywords = const [],
    this.isExpandable = true,
  });

  @override
  State<ProtocolCard> createState() => _ProtocolCardState();
}

class _ProtocolCardState extends State<ProtocolCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF3B82F6),
              child: Icon(Icons.medical_services, color: Colors.white),
            ),
            title: Text(
              widget.protocol.displayName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: widget.protocol.category != null
                ? Text(
                    widget.protocol.category!,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  )
                : null,
            trailing: widget.isExpandable
                ? IconButton(
                    icon: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  )
                : null,
          ),
          if (widget.matchedKeywords.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: widget.matchedKeywords.map((keyword) {
                  return Chip(
                    label: Text(
                      keyword,
                      style: const TextStyle(fontSize: 11),
                    ),
                    backgroundColor: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                    side: const BorderSide(color: Color(0xFF3B82F6)),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
            ),
          if (_isExpanded) _buildExpandedContent(),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    final steps = widget.protocol.parsedSteps;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Étapes du protocole:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          if (steps != null) ...[
            if (steps.containsKey('diagnostic'))
              _buildStep('Diagnostic', steps['diagnostic']),
            if (steps.containsKey('traitement'))
              _buildStep('Traitement', steps['traitement']),
            if (steps.containsKey('surveillance'))
              _buildStep('Surveillance', steps['surveillance']),
            if (steps.containsKey('referral'))
              _buildStep('Référence', steps['referral']),
          ] else
            Text(
              widget.protocol.steps,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStep(String title, dynamic content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xFF3B82F6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content.toString(),
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

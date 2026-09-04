import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

class ServiceRequestWorkflowChip extends StatelessWidget {
  /// Creates a [ServiceRequestWorkflowChip] for the raw API [status] text.
  const ServiceRequestWorkflowChip({required this.status, super.key});

  /// Raw workflow status text from the API (e.g. "Pending Ops Review").
  final String? status;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final label = (status ?? '').trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: colors.statusInfoBg, borderRadius: BorderRadius.circular(4)),
      child: Text(
        label.isEmpty ? '—' : label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 15 / 10,
          color: colors.statusInfoText,
        ),
      ),
    );
  }
}

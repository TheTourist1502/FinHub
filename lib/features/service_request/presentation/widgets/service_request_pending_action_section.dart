import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_detail_section.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_workflow_chip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Absolute date format for the due date, matching the workflow rail's SLA
/// dates (e.g. "Jul 28, 2026").
final DateFormat _kDueDateFormat = DateFormat('MMM d, yyyy');

/// Section naming the action the request is currently waiting on.
///
/// Renders the workflow stage as a [ServiceRequestWorkflowChip], followed by a
/// `Due Date : …` line when the request carries one. A null/blank status falls
/// back to a localised "nothing pending" line.
class ServiceRequestPendingActionSection extends StatelessWidget {
  /// Creates a [ServiceRequestPendingActionSection] for [workflowStatus].
  const ServiceRequestPendingActionSection({required this.workflowStatus, this.dueDate, super.key});

  /// Raw workflow status from the API; null when nothing is pending.
  final String? workflowStatus;

  /// Date the request is due; null when the request carries no due date.
  ///
  /// Rendered as a plain calendar date with no time zone conversion — it
  /// carries no meaningful time of day, and shifting it could move the request
  /// to a different day.
  final DateTime? dueDate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = (workflowStatus ?? '').trim();

    if (status.isEmpty) {
      return ServiceRequestDetailSection(
        title: l10n.serviceRequestDetailActionPending,
        child: Text(
          l10n.serviceRequestDetailNoPendingAction,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 18 / 12,
            color: context.appColors.textSecondary,
          ),
        ),
      );
    }

    return ServiceRequestDetailSection(
      title: l10n.serviceRequestDetailActionPending,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ServiceRequestWorkflowChip(status: status),
          if (dueDate != null) ...[
            const SizedBox(height: AppDimensions.spaceSx),
            serviceRequestLabelledLine(
              context,
              l10n.serviceRequestDetailDueDateLabel,
              _kDueDateFormat.format(dueDate!),
            ),
          ],
        ],
      ),
    );
  }
}

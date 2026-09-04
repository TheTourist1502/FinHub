import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/core/utils/date_display_formatter.dart';
import 'package:finhub/features/service_request/domain/models/service_request_item.dart';
import 'package:finhub/features/service_request/domain/models/service_request_task.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_detail_section.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_workflow_stepper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Compact timestamp for stepper rows (e.g. "Jul 21, 12:14 PM").
final DateFormat _kStepDateFormat = DateFormat('MMM d, h:mm a');

/// Date-only format for task SLA dates (e.g. "Jul 28, 2026").
final DateFormat _kDateFormat = DateFormat('MMM d, yyyy');

/// Section rendering the request's task workflow as a vertical timeline.
///
/// Thin wrapper: the titled frame comes from [ServiceRequestDetailSection] and
/// the rows from [buildServiceRequestSteps], which is kept top-level so the
/// task-trail-to-steps mapping can be exercised without building a widget.
class ServiceRequestWorkflowSection extends StatelessWidget {
  /// Creates a [ServiceRequestWorkflowSection] for [request].
  const ServiceRequestWorkflowSection({required this.request, super.key});

  /// The request whose task trail is drawn.
  final ServiceRequestItem request;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ServiceRequestDetailSection(
      title: l10n.serviceRequestDetailWorkflowStatus,
      gap: AppDimensions.spaceSm + 4,
      child: ServiceRequestWorkflowStepper(steps: buildServiceRequestSteps(request, l10n)),
    );
  }
}

/// Builds the timeline rows for [request].
///
/// The API's task trail starts at the first review stage, so a synthetic
/// "Submitted" step is always prepended — every request has passed it.
List<ServiceRequestStep> buildServiceRequestSteps(ServiceRequestItem request, AppLocalizations l10n) {
  final steps = <ServiceRequestStep>[
    ServiceRequestStep(
      label: l10n.serviceRequestDetailStepSubmitted,
      subtitle: request.createdDateTime == null ? null : _kStepDateFormat.formatLocal(request.createdDateTime!),
      state: ServiceRequestStepState.completed,
    ),
  ];

  for (final task in request.tasks) {
    steps.add(
      ServiceRequestStep(
        label: task.currentStatusOnLead ?? task.ownerName ?? task.status,
        subtitle: task.createdDateTime == null ? null : _kStepDateFormat.formatLocal(task.createdDateTime!),
        details: _taskDetails(task, l10n),
        comments: _taskComment(task, l10n),
        state: task.isCompleted ? ServiceRequestStepState.completed : ServiceRequestStepState.current,
      ),
    );
  }

  // A request that is neither closed nor sitting on an open task still has an
  // unreached terminal stage — show it so the timeline reads as unfinished.
  if (!request.isClosed && request.pendingTask == null) {
    steps.add(
      ServiceRequestStep(label: l10n.serviceRequestDetailStepCompleted, state: ServiceRequestStepState.upcoming),
    );
  }

  return steps;
}

/// Labelled lines for a task's owner, assignee, and SLA date, skipping whatever
/// the API left null.
List<ServiceRequestStepDetailEntry> _taskDetails(ServiceRequestTask task, AppLocalizations l10n) {
  return [
    if (task.ownerName != null)
      ServiceRequestStepDetailEntry(label: l10n.serviceRequestDetailOwner, value: task.ownerName!),
    if (task.assignedTo != null)
      ServiceRequestStepDetailEntry(label: l10n.serviceRequestDetailAssignedTo, value: task.assignedTo!),
    if (task.activityDate != null)
      ServiceRequestStepDetailEntry(
        label: l10n.serviceRequestDetailDueDate,
        value: _kDateFormat.format(task.activityDate!),
      ),
  ];
}

/// The task's reviewer comment, or null when the API left it blank.
ServiceRequestStepComment? _taskComment(ServiceRequestTask task, AppLocalizations l10n) {
  final text = task.comments?.trim();
  if (text == null || text.isEmpty) return null;

  return ServiceRequestStepComment(
    label: l10n.serviceRequestDetailComments,
    text: text,
    viewMoreLabel: l10n.serviceRequestDetailViewMore,
    closeLabel: l10n.serviceRequestDetailClose,
  );
}

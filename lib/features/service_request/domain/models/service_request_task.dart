import 'package:finhub/core/utils/json_parsing.dart';
import 'package:flutter/foundation.dart';

/// One Salesforce task attached to a service request.
///
/// Tasks form the request's audit trail: each entry records the workflow stage
/// the request sat at (`currentStatusOnLead`), who owned it, and — once worked
/// — the reviewer's comments. They drive the Workflow Status stepper on the
/// service request detail sheet.
@immutable
class ServiceRequestTask {
  /// Creates a [ServiceRequestTask].
  const ServiceRequestTask({
    required this.id,
    required this.status,
    required this.createdDateTime,
    this.ownerName,
    this.currentStatusOnLead,
    this.comments,
    this.assignedTo,
    this.activityDate,
  });

  /// Parses one entry of the `tasks` array from `GET /v1/service-requests/status`.
  factory ServiceRequestTask.fromJson(Map<String, dynamic> json) => ServiceRequestTask(
    id: json['id'] as String? ?? '',
    status: json['status'] as String? ?? '',
    createdDateTime: parseOptionalDateTime(json['createdDateTime']),
    ownerName: json['ownerName'] as String?,
    currentStatusOnLead: json['currentStatusOnLead'] as String?,
    comments: json['comments'] as String?,
    assignedTo: json['assignedTo'] as String?,
    activityDate: parseOptionalDateTime(json['activityDate']),
  );

  /// Salesforce task record id (e.g. "00Thv0000000q8NEAQ").
  final String id;

  /// Task lifecycle status — "Open" while pending, "Completed" once worked.
  final String status;

  /// When the task was raised. Null when the API omits or malforms the value.
  final DateTime? createdDateTime;

  /// Queue or user that owns the task (e.g. "Brokerage Ops").
  final String? ownerName;

  /// Workflow stage the request was at when this task was raised — the label
  /// shown on the stepper (e.g. "Pending Ops Review").
  final String? currentStatusOnLead;

  /// Reviewer's note left when the task was completed. Null while still open.
  final String? comments;

  /// Queue or user the task was handed off to. Null when unassigned.
  final String? assignedTo;

  /// SLA/due date for the task (date only, no time component).
  final DateTime? activityDate;

  /// Whether this task has been worked and closed out.
  bool get isCompleted => status.toLowerCase() == 'completed';
}

import 'package:finhub/core/utils/date_sort_utils.dart';
import 'package:finhub/core/utils/json_parsing.dart';
import 'package:finhub/features/service_request/domain/models/service_request_task.dart';
import 'package:finhub/features/service_request/domain/models/service_request_type.dart';
import 'package:flutter/foundation.dart';

/// Status bucket used to group requests on the Service Requests list.
///
/// Deliberately only two buckets: the list groups purely by whether a request
/// is still open, never by how its due date falls relative to today.
enum ServiceRequestCategory {
  /// Still open — shown under the "Active" filter and in "All".
  active,

  /// Resolved — shown under the "Closed" filter and in "All".
  closed,
}

/// A single service request returned by `GET /v1/service-requests/status`.
///
/// The API models a request as a Salesforce record plus its task audit trail;
/// everything the list screen groups and sorts by ([category], [dueDate],
/// [requestType]) is derived from those raw fields rather than sent explicitly.
@immutable
class ServiceRequestItem {
  /// Creates a [ServiceRequestItem].
  const ServiceRequestItem({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.finAccountType,
    required this.status,
    required this.tasks,
    this.accountId,
    this.workflowStatus,
    this.createdDateTime,
    this.closedBySource,
  });

  /// Parses one entry of a service-request status response array.
  ///
  /// [isClosed] is what the *endpoint* says about these requests — pass `true`
  /// when parsing `closed-status` and `false` when parsing `status`. Leave it
  /// null only when the source is unknown, in which case the bucket falls back
  /// to reading [status].
  factory ServiceRequestItem.fromJson(Map<String, dynamic> json, {bool? isClosed}) {
    final rawTasks = json['tasks'];
    // Oldest first — the stepper and the "current stage" lookup both read the
    // trail in chronological order, and the API returns it unordered. Tasks
    // with no parseable date sort last rather than posing as the oldest.
    final tasks = <ServiceRequestTask>[
      if (rawTasks is List) ...rawTasks.whereType<Map<String, dynamic>>().map(ServiceRequestTask.fromJson),
    ]..sort((a, b) => compareDatesAsc(a.createdDateTime, b.createdDateTime));

    return ServiceRequestItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      accountNumber: json['accountNumber'] as String? ?? '',
      accountId: json['accountId'] as String? ?? json['financialAccountId'] as String?,
      finAccountType: json['finAccountType'] as String? ?? '',
      status: json['status'] as String? ?? '',
      workflowStatus: json['workflowStatus'] as String?,
      createdDateTime: parseOptionalDateTime(json['createdDateTime']),
      tasks: tasks,
      closedBySource: isClosed,
    );
  }

  /// Salesforce record id (e.g. "a0chv0000000D0TAAU").
  final String id;

  /// Human-readable request number (e.g. "Maintain-000000023"), shown as the
  /// reference id on the detail sheet and matched by the list search.
  final String name;

  /// Financial account number the request was raised against.
  final String accountNumber;

  /// Salesforce id of that financial account, when the response carries one.
  ///
  /// `GET /v1/service-requests/status` does not currently send it under either
  /// `accountId` or `financialAccountId`, so this is null in practice — it is
  /// parsed and searched anyway so the field starts working the moment the
  /// endpoint begins sending it, with no further change here.
  final String? accountId;

  /// Financial account type (e.g. "Corporation", "Individual").
  final String finAccountType;

  /// Overall request status (e.g. "In-progress", "Completed").
  final String status;

  /// Current workflow stage (e.g. "Pending Ops Review"). Null when the request
  /// carries no active stage.
  final String? workflowStatus;

  /// When the request was submitted — the stepper's implicit "Submitted" step.
  final DateTime? createdDateTime;

  /// Task audit trail, oldest first.
  final List<ServiceRequestTask> tasks;

  /// Which endpoint this request came from: `true` from `closed-status`,
  /// `false` from `status`, null when it was parsed without a known source.
  ///
  /// Takes precedence over [status] in [isClosed] because the two endpoints
  /// disagree with the status text: `closed-status` returns requests still
  /// carrying an open-looking `status` (e.g. "In-progress"), and reading the
  /// text alone files them under Active.
  final bool? closedBySource;

  /// Business-function classification, derived from the [name] prefix since the
  /// API does not send the type explicitly.
  ServiceRequestType get requestType => ServiceRequestType.fromRecordName(name);

  /// Workflow status badge text shown on the list card.
  String? get statusLabel => workflowStatus;

  /// Whether this request is resolved — the sole input to [category].
  ///
  /// The endpoint that served it wins ([closedBySource]): it is the only
  /// authority that always agrees with which filter chip the request belongs
  /// to. [status] is read only as a fallback, and there anything the API does
  /// not report as in-progress/open/pending counts as closed, so a new terminal
  /// status never silently lands in "Active".
  bool get isClosed =>
      closedBySource ??
      switch (status.toLowerCase()) {
        'in-progress' || 'in progress' || 'open' || 'pending' || 'new' || '' => false,
        _ => true,
      };

  /// The oldest task still open — the stage the request is waiting on.
  ServiceRequestTask? get pendingTask {
    for (final task in tasks) {
      if (!task.isCompleted) return task;
    }
    return null;
  }

  /// Date shown on the list card: the SLA date of the open task, falling back
  /// to the newest task's date and finally to the submission date.
  ///
  /// Null when the request carries no parseable date at all. Deliberately not
  /// defaulted to "now": a synthesised date would render on the card as a real
  /// due date.
  DateTime? get dueDate =>
      pendingTask?.activityDate ?? (tasks.isNotEmpty ? tasks.last.activityDate : null) ?? createdDateTime;

  /// Whether this request matches the free-text search [query].
  ///
  /// Matches on the four identifiers an advisor is likely to have to hand —
  /// account number, account id, reference id ([name]) and record id ([id]) —
  /// plus [finAccountType], so a query such as "corporation" still narrows the
  /// list the way it did before these identifiers were added.
  ///
  /// Case-insensitive: both sides are lowercased before comparison, so "3LW",
  /// "3lw" and "3Lw" all match the same requests. A blank query matches
  /// everything.
  bool matchesSearch(String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return true;

    return <String>[
      accountNumber,
      accountId ?? '',
      name,
      id,
      finAccountType,
    ].any((field) => field.toLowerCase().contains(needle));
  }

  /// Status bucket this request is grouped under.
  ///
  /// Follows [isClosed] and nothing else — [dueDate] drives only what the card
  /// prints, never which section the request lands in.
  ServiceRequestCategory get category => isClosed ? ServiceRequestCategory.closed : ServiceRequestCategory.active;
}

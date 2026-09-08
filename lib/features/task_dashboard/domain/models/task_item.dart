import 'package:flutter/foundation.dart';

/// Classifies a task by its temporal urgency bucket.
///
/// Not an API field — it records **which response list** the task arrived in
/// (`overdueTaskList`, `todayTaskList`, …), which is the only place that
/// information exists. Drives the filter chips and section grouping.
enum TaskCategory {
  /// Past the due date.
  overdue,

  /// Due today.
  today,

  /// Due in a future date.
  upcoming,

  /// Open tasks not yet assigned to a specific time bucket.
  open,

  /// Completed / closed tasks.
  closed,
}

/// Immutable domain model representing a single advisor task.
///
/// Field names mirror the tasks REST API payload key-for-key, so a JSON key
/// and its model field are always the same identifier. The only members that
/// are not API keys are [category] (derived from the enclosing response list)
/// and [icon] (a presentation value computed at parse time). The relative due
/// label shown in the UI is *not* stored here — see the note on [icon].
@immutable
class TaskItem {
  /// Creates a [TaskItem].
  const TaskItem({
    required this.taskId,
    required this.icon,
    required this.category,
    this.dueDate,
    this.type,
    this.workflowStatus,
    this.slaBreach,
    this.relatedRecordId,
    this.pendingAction,
    this.financialAccountName,
    this.financialAccountId,
    this.faAccountType,
    this.description,
    this.createdDate,
    this.assignedTo,
    this.accountNumber,
    this.accountMaintainenceTaskName,
    this.accountMaintainenceId,
  });

  // ── API keys ──────────────────────────────────────────────────────────────

  /// `taskId` — unique task identifier (e.g. "00TRK00000GFcTZ2A1").
  final String taskId;

  /// `type` — task type label (e.g. "Financial Account Task").
  final String? type;

  /// `workflowStatus` — workflow state shown as a badge chip
  /// (e.g. "NAO In progress").
  final String? workflowStatus;

  /// `slaBreach` — whether the task has breached its SLA ("Yes" / "No").
  final String? slaBreach;

  /// `relatedRecordId` — id of the Salesforce record this task relates to.
  final String? relatedRecordId;

  /// `pendingAction` — next action required to progress the task
  /// (e.g. "Submit Approval").
  final String? pendingAction;

  /// `financialAccountName` — name of the financial account
  /// (e.g. "TATA TMCID"). Null for account-maintenance tasks.
  final String? financialAccountName;

  /// `financialAccountId` — id of the related financial account.
  final String? financialAccountId;

  /// `faAccountType` — account type (e.g. "Corporation").
  final String? faAccountType;

  /// `dueDate` — parsed from the API's `"yyyy-MM-dd"` string, or `null` when
  /// the backend omitted it or sent something unparseable.
  ///
  /// A pure calendar date with no meaningful time-of-day: format it with
  /// `DateFormat.format`, never `formatLocal`. A `null` here means "no due
  /// date" — it must never be rendered as a placeholder, and never treated as
  /// overdue (see [category], which the API layer downgrades to
  /// [TaskCategory.open] when this is `null`).
  final DateTime? dueDate;

  /// `description` — long-form summary of what needs to be done.
  final String? description;

  /// `createdDate` — parsed from the API's ISO 8601 UTC timestamp, or `null`
  /// when absent/unparseable. Has a meaningful time-of-day, so display it via
  /// `DateFormat.formatLocal`.
  final DateTime? createdDate;

  /// `assignedTo` — display name of the assignee (e.g. "Nirish Kumar Piletti").
  final String? assignedTo;

  /// `accountNumber` — financial account number (e.g. "3LW039962").
  final String? accountNumber;

  /// `accountMaintainenceTaskName` — task name for account-maintenance tasks.
  /// Null for financial-account tasks.
  final String? accountMaintainenceTaskName;

  /// `accountMaintainenceId` — id of the related account-maintenance record.
  final String? accountMaintainenceId;

  // ── Non-API members ───────────────────────────────────────────────────────

  /// Temporal urgency bucket — see [TaskCategory].
  final TaskCategory category;

  /// MDI icon key resolved by the widget layer (e.g. "file_document_outline").
  final String icon;

  /// `dueLabel` was dropped: a repository is a `data/` concern and must not
  /// bake user-facing English text ("Due today", "Due 2 days ago") into a
  /// domain model — the app has exactly one localised source for that kind of
  /// string. The relative label is now computed at display time from
  /// [dueDate] by `taskDueLabel` (`task_item_due_row.dart`), which routes
  /// through `AppLocalizations` like every other string on screen.

  /// Name to display for this task's account.
  ///
  /// The API splits the name across two keys depending on task kind, so
  /// [financialAccountName] falls back to [accountMaintainenceTaskName], then
  /// to [taskId] when the payload carries neither.
  String get accountDisplayName => financialAccountName ?? accountMaintainenceTaskName ?? taskId;

  /// Every searchable field of this task flattened into one lowercase blob.
  ///
  /// Covers all values surfaced anywhere in the UI — the list card *and* the
  /// detail bottom sheet — plus the category name and the raw ISO dates, so a
  /// query such as "closed" or "2026-07" matches too. Lowercasing here is half
  /// of what makes search case-insensitive; [matchesSearch] lowercases the
  /// query to match.
  String get _searchIndex => <String>[
    taskId,
    type ?? '',
    workflowStatus ?? '',
    slaBreach ?? '',
    relatedRecordId ?? '',
    pendingAction ?? '',
    financialAccountName ?? '',
    financialAccountId ?? '',
    faAccountType ?? '',
    dueDate?.toIso8601String() ?? '',
    description ?? '',
    createdDate?.toIso8601String() ?? '',
    assignedTo ?? '',
    accountNumber ?? '',
    accountMaintainenceTaskName ?? '',
    accountMaintainenceId ?? '',
    category.name,
  ].join(' ').toLowerCase();

  /// Whether this task matches the free-text search [query].
  ///
  /// Case-insensitive: both the query and [_searchIndex] are lowercased before
  /// comparison, so "TATA", "tata" and "TaTa" all match the same tasks.
  ///
  /// The query is split on whitespace and **every** token must appear
  /// somewhere in [_searchIndex], so tokens may span different fields
  /// (e.g. "kyc corporation" matches a KYC task on a Corporation account). An
  /// empty or whitespace-only query matches every task.
  bool matchesSearch(String query) {
    final tokens = query.toLowerCase().split(RegExp(r'\s+')).where((t) => t.isNotEmpty);
    if (tokens.isEmpty) return true;

    final index = _searchIndex;
    return tokens.every(index.contains);
  }

  /// Multi-line dump of every field, used for diagnostic logging.
  ///
  /// Rendered one field per line so a task logged on detail-sheet open is
  /// readable in the console without unwrapping a single long string.
  @override
  String toString() =>
      'TaskItem(\n'
      '  taskId: $taskId\n'
      '  type: $type\n'
      '  workflowStatus: $workflowStatus\n'
      '  slaBreach: $slaBreach\n'
      '  relatedRecordId: $relatedRecordId\n'
      '  pendingAction: $pendingAction\n'
      '  financialAccountName: $financialAccountName\n'
      '  financialAccountId: $financialAccountId\n'
      '  faAccountType: $faAccountType\n'
      '  dueDate: ${dueDate?.toIso8601String()}\n'
      '  description: $description\n'
      '  createdDate: ${createdDate?.toIso8601String()}\n'
      '  assignedTo: $assignedTo\n'
      '  accountNumber: $accountNumber\n'
      '  accountMaintainenceTaskName: $accountMaintainenceTaskName\n'
      '  accountMaintainenceId: $accountMaintainenceId\n'
      '  category: ${category.name}\n'
      '  icon: $icon\n'
      ')';
}

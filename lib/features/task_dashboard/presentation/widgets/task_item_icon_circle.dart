import 'package:finhub/features/task_dashboard/presentation/widgets/task_status_avatar.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// MDI icons keyed by the values `TaskDashboardApi._iconForType` derives from
/// the API `type` field — the API sends no icon key of its own.
const _kIconMap = <String, String>{
  'file_document_outline': Mdi.file_document_outline,
  'bank_outline': Mdi.bank_outline,
  'account_outline': Mdi.account_outline,
};

const String _kFallbackIcon = Mdi.clipboard_text_outline;

/// Glyph a task falls back to when the API reports no workflow stage — its
/// record type, or a generic clipboard when that is unmapped too.
///
/// Shared so the list card's circle and the detail sheet's avatar always show
/// the same icon for the same task.
String taskItemFallbackIcon(String? iconKey) => _kIconMap[iconKey] ?? _kFallbackIcon;

/// Leading 48 px circular avatar holding the task's icon.
///
/// A thin wrapper over [TaskStatusAvatar]: the stage a task is sitting in
/// says more at a glance than what kind of record it hangs off, so it drives
/// both the glyph and the circle's colour, and the type icon is used only when
/// no stage is reported.
class TaskItemIconCircle extends StatelessWidget {
  /// Creates a [TaskItemIconCircle] for [iconKey].
  const TaskItemIconCircle({required this.iconKey, this.workflowStatus, super.key});

  /// Icon key from the task model; unmapped values use the fallback glyph.
  final String? iconKey;

  /// Raw `workflowStatus` text; drives the glyph and palette whenever the API
  /// sends one.
  final String? workflowStatus;

  @override
  Widget build(BuildContext context) {
    return TaskStatusAvatar(
      status: workflowStatus,
      fallbackIcon: taskItemFallbackIcon(iconKey),
    );
  }
}

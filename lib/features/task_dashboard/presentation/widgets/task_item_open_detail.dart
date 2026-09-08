import 'package:finhub/features/task_dashboard/domain/models/task_item.dart';
import 'package:finhub/features/task_dashboard/presentation/widgets/task_detail_bottom_sheet.dart';
import 'package:flutter/material.dart';

/// Opens the task detail sheet for [task].
///
/// Single entry point for every "View" tap, so callers outside this folder
/// never import the bottom sheet widget directly.
Future<void> openTaskDetail(BuildContext context, TaskItem task) {
  return showTaskDetailBottomSheet(context, task);
}

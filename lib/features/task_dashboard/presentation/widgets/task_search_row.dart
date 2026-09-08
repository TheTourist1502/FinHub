import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/task_dashboard/presentation/providers/task_dashboard_provider.dart';
import 'package:finhub/shared/widgets/inputs/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Search field for the Task Dashboard header.
///
/// Filters tasks via [taskSearchQueryProvider]; its clear button is
/// [AppSearchField]'s own, so this widget only adds the extra side effect of
/// dropping focus.
class TaskSearchRow extends ConsumerStatefulWidget {
  /// Creates a [TaskSearchRow].
  const TaskSearchRow({super.key});

  @override
  ConsumerState<TaskSearchRow> createState() => _TaskSearchRowState();
}

class _TaskSearchRowState extends ConsumerState<TaskSearchRow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Seed from the provider: it outlives this widget, so a query typed before
    // navigating away is still filtering the list when the screen is re-entered.
    _controller = TextEditingController(text: ref.read(taskSearchQueryProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            child: AppSearchField(
              controller: _controller,
              hintText: context.l10n.taskDashboardSearchHint,
              onChanged: (q) => ref.read(taskSearchQueryProvider.notifier).query = q,
              // The field and the provider are already emptied by the shared
              // clear button; only dropping focus is this screen's business.
              onClear: () => FocusScope.of(context).unfocus(),
            ),
          ),
        ],
      ),
    );
  }
}

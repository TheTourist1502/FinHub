import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Grab-handle pill drawn at the top of the draggable task detail sheet.
class TaskSheetHandle extends StatelessWidget {
  /// Creates a [TaskSheetHandle].
  const TaskSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 4),
      child: Center(
        child: Container(
          width: 48,
          height: 4,
          decoration: BoxDecoration(
            color: context.appColors.borderDefault,
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
      ),
    );
  }
}

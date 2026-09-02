import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Grab-handle pill drawn at the top of a draggable transaction sheet.
class TransactionSheetHandle extends StatelessWidget {
  /// Creates a [TransactionSheetHandle].
  const TransactionSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
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

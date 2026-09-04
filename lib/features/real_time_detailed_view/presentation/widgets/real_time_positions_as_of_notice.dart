import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Informational notice that the market feed lags real time.
class RealTimePositionsAsOfNotice extends StatelessWidget {
  /// Creates the notice.
  const RealTimePositionsAsOfNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(1),
            child: Iconify(Mdi.information_outline, size: 16, color: colors.textSecondary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              context.l10n.realTimeDelayNote,
              style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

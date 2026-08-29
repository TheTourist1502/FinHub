import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Footer row of the recent-transactions card that opens the full history.
///
/// Its own widget so the tap target owns the ink splash and rebuild scope.
class RecentTransactionsViewAllButton extends StatelessWidget {
  /// Creates a [RecentTransactionsViewAllButton].
  const RecentTransactionsViewAllButton({super.key});

  /// Rounded only at the bottom, where the button meets the card edge.
  static const BorderRadius _radius = BorderRadius.vertical(bottom: Radius.circular(16));

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(AppRoutes.viewTransactions),
        borderRadius: _radius,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: Text(
            context.l10n.dashboardViewTransactionHistory,
            style: AppTypography.bodyMedium.copyWith(
              color: colors.interactiveDefault,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/features/view_transactions/domain/models/view_transaction.dart';
import 'package:finhub/shared/widgets/transaction/transaction_type_avatar.dart';
import 'package:finhub/shared/widgets/transaction/transaction_type_config.dart';
import 'package:flutter/material.dart';

/// Top block of the transaction detail sheet: type avatar beside the account
/// line and the security title.
class TransactionDetailHeader extends StatelessWidget {
  /// Creates a [TransactionDetailHeader] for [transaction].
  const TransactionDetailHeader({required this.transaction, super.key});

  /// The transaction being described.
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final config = transactionTypeConfig(transaction.transactionType, context.appColors, context.l10n);
    final securityLabel = _securityLabel(transaction.tickerSymbol, transaction.securityName);

    // The avatar always shows: a transaction with no recognised type is a
    // Non-Trade, not a missing field.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TransactionTypeAvatar(config: config),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (transaction.accountName.isNotEmpty)
                _AccountLine(name: transaction.accountName, type: transaction.accountType),
              const SizedBox(height: 4),
              if (securityLabel.isNotEmpty) _SecurityTitle(label: securityLabel),
            ],
          ),
        ),
      ],
    );
  }
}

/// Account name and type on one wrapping line, separated by a dot.
class _AccountLine extends StatelessWidget {
  const _AccountLine({required this.name, required this.type});

  final String name;
  final String type;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          name,
          style: AppTypography.bodySmall.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w500,
            fontSize: 12,
            letterSpacing: 0,
          ),
        ),
        if (type.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(Icons.circle, size: 4, color: colors.textSecondary),
          ),
          Text(
            type,
            style: AppTypography.bodySmall.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 11,
              letterSpacing: 0.55,
            ),
          ),
        ],
      ],
    );
  }
}

/// Prominent security name / ticker title under the account line.
class _SecurityTitle extends StatelessWidget {
  const _SecurityTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTypography.pageTitle.copyWith(
        color: context.appColors.textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 18,
        height: 1.2,
      ),
    );
  }
}

/// Formats the title as `Name (TICKER)`, falling back to whichever of the two
/// is present, or an empty string when neither is.
String _securityLabel(String? ticker, String name) {
  final hasTicker = ticker != null && ticker.isNotEmpty;
  if (hasTicker && name.isNotEmpty) return '$name ($ticker)';
  return hasTicker ? ticker : name;
}

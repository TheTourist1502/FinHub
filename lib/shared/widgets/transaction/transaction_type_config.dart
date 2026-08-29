import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Visual configuration for a transaction type: display label plus the
/// colors used for its amount text, type badge, and detail-sheet avatar.
///
/// BUY transactions use the error color, SELL transactions use the success
/// color, and everything else — "N/A", missing, or anything unrecognised —
/// is a Non-Trade, falling back to the info color for accents and to the
/// primary text color for amounts. Resolve via [transactionTypeConfig] so every transaction
/// surface — cards, badges, and the detail bottom sheet — stays visually
/// consistent.
@immutable
class TransactionTypeConfig {
  /// Creates a [TransactionTypeConfig].
  const TransactionTypeConfig({
    required this.label,
    required this.accentColor,
    required this.displayColor,
    required this.badgeBgColor,
    required this.badgeTextColor,
  });

  /// Upper-cased, localised display label (e.g. "BUY").
  final String label;

  /// Foreground colour for amount text and other unbadged accents.
  final Color accentColor;

  /// Foreground colour for the amount shown on transaction cards.
  ///
  /// Error for BUY, success for SELL, primary text for every other type.
  final Color displayColor;

  /// Background colour for the type badge / avatar circle.
  final Color badgeBgColor;

  /// Foreground colour for text drawn on top of [badgeBgColor].
  final Color badgeTextColor;
}

/// Resolves the [TransactionTypeConfig] for a raw `transactionType` value.
///
/// Only "BUY" and "SELL" are trades. Everything else — null, empty,
/// whitespace only, "N/A", or any unrecognised value — resolves to the
/// Non-Trade label and the neutral/info colours.
TransactionTypeConfig transactionTypeConfig(
  String? type,
  AppColorTokens colors,
  AppLocalizations l10n,
) {
  final normalized = type?.trim() ?? '';
  final label = switch (normalized) {
    'BUY' => l10n.viewTransactionsTypeBuy,
    'SELL' => l10n.viewTransactionsTypeSell,
    _ => l10n.transactionTypeNonTrade,
  }.toUpperCase();

  switch (normalized) {
    case 'BUY':
      return TransactionTypeConfig(
        label: label,
        accentColor: colors.statusErrorDefault,
        displayColor: colors.statusError,
        badgeBgColor: colors.statusErrorBg,
        badgeTextColor: colors.statusError,
      );
    case 'SELL':
      return TransactionTypeConfig(
        label: label,
        accentColor: colors.statusSuccessDefault,
        displayColor: colors.statusSuccess,
        badgeBgColor: colors.statusSuccessBg,
        badgeTextColor: colors.statusSuccess,
      );
    default:
      return TransactionTypeConfig(
        label: label,
        accentColor: colors.statusInfoDefault,
        displayColor: colors.textPrimary,
        badgeBgColor: colors.statusInfoBg,
        badgeTextColor: colors.statusInfo,
      );
  }
}

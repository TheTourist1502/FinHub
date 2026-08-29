import 'package:finhub/shared/widgets/transaction/transaction_type_config.dart';
import 'package:flutter/material.dart';

/// Circular badge showing a transaction type's short label ("BUY", "SELL").
///
/// Prop-driven leaf so every transaction surface renders the same avatar.
class TransactionTypeAvatar extends StatelessWidget {
  /// Creates a [TransactionTypeAvatar] from a resolved [config].
  const TransactionTypeAvatar({
    required this.config,
    this.size = 48,
    this.fontSize = 13,
    super.key,
  });

  /// Colors and label for the transaction type being shown.
  final TransactionTypeConfig config;

  /// Diameter of the circle in logical pixels.
  final double size;

  /// Label type size. Override on smaller avatars so short labels are not
  /// scaled up to fill the circle.
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: config.badgeBgColor, shape: BoxShape.circle),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(4),
          // Scales long labels down rather than clipping or wrapping them.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              config.label,
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: fontSize,
                color: config.badgeTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

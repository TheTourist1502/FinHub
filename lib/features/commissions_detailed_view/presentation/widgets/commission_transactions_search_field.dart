import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/commissions_detailed_view/presentation/providers/commissions_detailed_view_filter_provider.dart';
import 'package:finhub/shared/widgets/inputs/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Search field above the commission detail list.
///
/// Owns its text controller and writes the query to
/// [commissionDetailSearchQueryProvider] so only the list and sort header rebuild.
class CommissionTransactionsSearchField extends ConsumerStatefulWidget {
  /// Creates a [CommissionTransactionsSearchField].
  const CommissionTransactionsSearchField({super.key});

  @override
  ConsumerState<CommissionTransactionsSearchField> createState() => _CommissionTransactionsSearchFieldState();
}

class _CommissionTransactionsSearchFieldState extends ConsumerState<CommissionTransactionsSearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppSearchField(
      hintText: context.l10n.commissionDetailedViewSearchHint,
      controller: _controller,
      // Also fires with '' when the built-in clear button empties the field.
      onChanged: (v) => ref.read(commissionDetailSearchQueryProvider.notifier).query = v,
    );
  }
}

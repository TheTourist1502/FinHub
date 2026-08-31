import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/accounts/presentation/providers/accounts_provider.dart';
import 'package:finhub/shared/widgets/feedback/pagination_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Trailing row of the accounts list showing load-more progress or a retry.
///
/// Watches the pagination flags itself so only this row rebuilds while a
/// further page is being fetched.
class AccountsPaginationFooter extends ConsumerWidget {
  /// Creates an [AccountsPaginationFooter].
  const AccountsPaginationFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoadingMore = ref.watch(
      accountsNotifierProvider.select((s) => s.value?.isLoadingMore ?? false),
    );
    final hasError = ref.watch(
      accountsNotifierProvider.select((s) => s.value?.paginationError != null),
    );

    return PaginationFooter(
      isLoadingMore: isLoadingMore,
      hasError: hasError,
      errorLabel: context.l10n.accountsPaginationError,
      onRetry: () => ref.read(accountsNotifierProvider.notifier).loadMore(),
    );
  }
}

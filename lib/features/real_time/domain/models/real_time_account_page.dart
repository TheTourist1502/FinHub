import 'package:finhub/features/real_time/domain/models/real_time_account.dart';

/// A single page of [RealTimeAccount]s returned by
/// [IRealTimeRepository.getAccounts].
///
/// The mock repository never generates a real cursor — see [nextCursor].
class RealTimeAccountPage {
  /// Creates a [RealTimeAccountPage].
  const RealTimeAccountPage({required this.accounts, required this.nextCursor, required this.totalCount});

  /// The accounts returned in this page.
  final List<RealTimeAccount> accounts;

  /// Opaque cursor to pass in the next request, or `null` when this is the
  /// last page and no further records exist. The mock data source returns
  /// every account in one page, so this is always `null`.
  final String? nextCursor;

  /// Total number of accounts matching the current search, across all pages.
  final int totalCount;

  /// Whether a subsequent page of accounts is available.
  bool get hasMore => nextCursor != null;

  /// Whether this single page holds the entire dataset, so the list can be
  /// searched and counted in memory without asking the server again.
  ///
  /// A null [nextCursor] alone is not enough: it says "no further pages", not
  /// "you have everything". A server that stops paging early — or caps a page
  /// without issuing a cursor — would strand the list in memory-only mode
  /// holding a fraction of the records, where the search is never sent and the
  /// header counts the fraction. [totalCount] is the dataset's own statement of
  /// its size, so compare against it.
  ///
  /// **Only meaningful on an unsearched response.** [totalCount] is scoped to
  /// the query, so on a searched page this answers "did I get all the matches?"
  /// rather than "do I have every account".
  bool get isCompleteDataset => nextCursor == null && accounts.length >= totalCount;
}

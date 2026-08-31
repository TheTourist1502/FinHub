import 'package:finhub/features/accounts/domain/models/account.dart';

/// A single page of accounts returned by the cursor-based API.
///
/// The frontend must never generate or modify [nextCursor] — it is an opaque
/// value owned by the server. Pass it verbatim to the next
/// [AccountsRepository.getAccounts] call to fetch the next page.
class AccountPage {
  /// Creates an [AccountPage].
  const AccountPage({required this.accounts, required this.nextCursor, required this.totalCount});

  /// The accounts returned in this page.
  final List<Account> accounts;

  /// Opaque cursor to pass in the next request, or `null` when this is the
  /// last page and no further records exist.
  final String? nextCursor;

  /// Number of accounts matching this request's `search` and `filter` on the
  /// server, across all pages (the `totalCount` key in the response).
  ///
  /// Scoped to the query, not the book: a request for `standalone` reports the
  /// standalone total, not the grand total. Stays constant while paginating the
  /// same query, so the header can show it without the count growing per page.
  final int totalCount;

  /// Whether a subsequent page of accounts is available.
  bool get hasMore => nextCursor != null;

  /// Whether this single page holds the entire dataset, so the list can be
  /// searched, filtered and counted in memory without asking the server again.
  ///
  /// A null [nextCursor] alone is not enough: it says "no further pages", not
  /// "you have everything". A server that stops paging early — or caps a page
  /// without issuing a cursor — would strand the list in memory-only mode
  /// holding a fraction of the records, where the filter is never sent and the
  /// header counts the fraction. [totalCount] is the dataset's own statement of
  /// its size, so compare against it.
  ///
  /// **Only meaningful on an unfiltered, unsearched response.** [totalCount] is
  /// scoped to the query, so on a filtered page this answers "did I get all the
  /// matches?" — and a page holding every standalone account is emphatically
  /// not the whole book. Deciding the mode from one would re-create the exact
  /// bug this guard exists to prevent.
  bool get isCompleteDataset => nextCursor == null && accounts.length >= totalCount;
}

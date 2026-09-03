import 'package:finhub/features/view_transactions/domain/models/view_transactions_page.dart';

/// Abstract contract for fetching the FA's full transaction history.
///
/// The concrete implementation in `data/` calls the live API with cursor-based
/// pagination. When the endpoint changes, only [ViewTransactionsApi] changes —
/// this interface and the presentation layer remain untouched.
// ignore: one_member_abstracts
abstract interface class IViewTransactionsRepository {
  /// Fetches a single page of transactions from the server.
  ///
  /// Omit [cursor] (or pass `null`) to fetch the first page. For subsequent
  /// pages, pass the [TransactionPage.nextCursor] returned by the previous
  /// call verbatim — never construct or modify cursor values on the client.
  ///
  /// The returned [TransactionPage.hasMore] indicates whether another page
  /// is available. When `false`, do not make further requests.
  Future<TransactionPage> getTransactions({String? cursor});
}

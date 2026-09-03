import 'package:finhub/features/households/domain/models/household_detail.dart';

/// A single page of households returned by the cursor-based API.
///
/// The frontend must never generate or modify [nextCursor] — it is an opaque
/// value owned by the server. Pass it verbatim to the next
/// [HouseholdsRepository.getHouseholds] call to fetch the next page.
class HouseholdPage {
  /// Creates a [HouseholdPage].
  const HouseholdPage({required this.households, required this.nextCursor, required this.totalCount});

  /// The households returned in this page.
  final List<HouseholdDetail> households;

  /// Opaque cursor to pass in the next request, or `null` when this is the
  /// last page and no further records exist.
  final String? nextCursor;

  /// Number of households matching this request's `search` on the server,
  /// across all pages (the `totalCount` key in the response).
  ///
  /// Scoped to the query, not the book. Stays constant while paginating the
  /// same query, so the header can show it without the count growing per page.
  final int totalCount;

  /// Whether a subsequent page of households is available.
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
  /// rather than "do I have every household".
  bool get isCompleteDataset => nextCursor == null && households.length >= totalCount;
}

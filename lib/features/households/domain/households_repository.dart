import 'package:finhub/features/households/domain/models/household_page.dart';
import 'package:finhub/features/households/domain/models/household_sort_field.dart';
import 'package:finhub/shared/models/sort_order.dart';

/// Abstract repository for fetching household data.
// ignore: one_member_abstracts
abstract class HouseholdsRepository {
  /// Fetches one page of households for the current advisor.
  ///
  /// [cursor] comes from the previous [HouseholdPage.nextCursor]; omit it for
  /// the first page. [search] filters by household name or id; omit it for
  /// the full list. [sortBy] and [sortOrder] are sent on every request,
  /// including the first, so the server's order always matches what the UI
  /// shows.
  Future<HouseholdPage> getHouseholds({
    required HouseholdSortField sortBy,
    required SortOrder sortOrder,
    String? cursor,
    String? search,
  });
}

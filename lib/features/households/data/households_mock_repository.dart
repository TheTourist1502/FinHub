import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/households/domain/households_repository.dart';
import 'package:finhub/features/households/domain/models/household_detail.dart';
import 'package:finhub/features/households/domain/models/household_page.dart';
import 'package:finhub/features/households/domain/models/household_sort_field.dart';
import 'package:finhub/shared/models/sort_order.dart';

/// [HouseholdsRepository] backed by `assets/mock-data/households/list.json`.
///
/// The filtering, searching and sorting the list endpoint used to do
/// server-side happens here instead, so the list screen's controls behave the
/// same way they always did.
class HouseholdsMockRepository implements HouseholdsRepository {
  /// Creates the repository over [_source], scoped to [_scope]'s advisor.
  HouseholdsMockRepository(this._source, this._scope);

  final MockDataSource _source;
  final DataScope _scope;

  @override
  Future<HouseholdPage> getHouseholds({
    required HouseholdSortField sortBy,
    required SortOrder sortOrder,
    String? cursor,
    String? search,
  }) async {
    final all = await _source.listScoped('households/list.json', _scope.advisorId);
    final searched = searchRows(all, search, ['householdName']);
    final sorted = sortRows(
      searched,
      sortBy == HouseholdSortField.name ? 'householdName' : 'totalAumCents',
      ascending: sortOrder == SortOrder.asc,
    );

    // Everything comes back on the first page — there is no cursor to hand
    // back, so the list simply stops paging.
    return HouseholdPage(
      households: sorted.map(HouseholdDetail.fromApiJson).toList(),
      nextCursor: null,
      totalCount: sorted.length,
    );
  }
}

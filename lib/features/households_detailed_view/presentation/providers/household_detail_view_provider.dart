import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/households_detailed_view/data/household_detail_view_mock_repository.dart';
import 'package:finhub/features/households_detailed_view/domain/household_detail_view_repository.dart';
import 'package:finhub/features/households_detailed_view/domain/models/household_detail_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the concrete [HouseholdDetailViewRepository] implementation.
final householdDetailViewRepositoryProvider = Provider<HouseholdDetailViewRepository>(
  (ref) => HouseholdDetailViewMockRepository(ref.watch(mockDataSourceProvider), ref.watch(dataScopeProvider)),
);

/// Loads the full detail of a single household identified by [householdId].
///
/// Fires four concurrent API calls.
///
/// The repository is watched, not read: `dataScopeProvider` rebuilds it when a
/// leadership user selects a different advisor, so every cached entry here goes
/// stale at that moment rather than serving the previous advisor's household.
// ignore: specify_nonobvious_property_types
final householdDetailViewProvider = FutureProvider.family<HouseholdDetailView, String>(
  (ref, householdId) => ref.watch(householdDetailViewRepositoryProvider).getHouseholdDetail(householdId),
);

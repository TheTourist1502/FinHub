import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/leadership_advisor_selection/data/leadership_advisor_selection_mock_repository.dart';
import 'package:finhub/features/leadership_advisor_selection/domain/advisor_selection_repository.dart';
import 'package:finhub/features/leadership_advisor_selection/domain/models/advisor_option.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the active [AdvisorSelectionRepository] implementation.
final advisorSelectionRepositoryProvider = Provider<AdvisorSelectionRepository>(
  (ref) => LeadershipAdvisorSelectionMockRepository(ref.watch(mockDataSourceProvider)),
);

/// Loads every advisor the leadership user may select.
///
/// Deliberately **not** `autoDispose` — the roster is fetched once and reused
/// across visits to the picker instead of being refetched. It is discarded at
/// sign-out along with the whole Riverpod container.
final advisorListProvider = FutureProvider<List<AdvisorOption>>(
  (ref) => ref.watch(advisorSelectionRepositoryProvider).getAdvisors(),
);

/// Holds the advisor-search text typed in the picker sheet.
class AdvisorSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  /// Updates the search query to [query].
  void update(String query) {
    if (state != query) state = query;
  }

  /// Clears the search query, restoring the unfiltered list.
  void clear() {
    if (state.isNotEmpty) state = '';
  }
}

/// The current advisor-search text. Defaults to `''` (no filter).
final advisorSearchQueryProvider = NotifierProvider<AdvisorSearchQueryNotifier, String>(
  AdvisorSearchQueryNotifier.new,
);

/// [advisorListProvider], narrowed by [advisorSearchQueryProvider].
///
/// Filtering is client-side over the list already fetched — no request is
/// issued per keystroke. Matches a case-insensitive substring against
/// [AdvisorOption.fullName], [AdvisorOption.companyEmail], or
/// [AdvisorOption.financialAdvisorId].
final filteredAdvisorListProvider = Provider<AsyncValue<List<AdvisorOption>>>((ref) {
  final advisors = ref.watch(advisorListProvider);
  final query = ref.watch(advisorSearchQueryProvider).trim().toLowerCase();
  if (query.isEmpty) return advisors;

  return advisors.whenData(
    (list) => list
        .where(
          (advisor) =>
              advisor.fullName.toLowerCase().contains(query) ||
              advisor.companyEmail.toLowerCase().contains(query) ||
              advisor.financialAdvisorId.toLowerCase().contains(query),
        )
        .toList(),
  );
});

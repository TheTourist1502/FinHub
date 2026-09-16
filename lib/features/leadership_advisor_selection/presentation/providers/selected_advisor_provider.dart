import 'package:finhub/core/advisor_context/advisor_context_provider.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/features/leadership_advisor_selection/domain/models/advisor_option.dart';
import 'package:finhub/features/leadership_advisor_selection/presentation/providers/leadership_advisor_selection_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Resolves the full [AdvisorOption] for the id held by
/// [advisorContextProvider], or `null` when none is selected.
///
/// Looks the id up in [advisorListProvider] when it is already loaded (the
/// common case — the picker is how a selection is made); falls back to
/// [AdvisorSelectionRepository.getAdvisor] otherwise, e.g. a cold start where
/// the persisted selection is restored before the picker has ever opened.
///
/// `ref.exists` + `ref.read` rather than `ref.watch` on the list, on purpose:
/// watching would instantiate [advisorListProvider] and fetch the whole
/// roster just to resolve one name.
final selectedAdvisorProvider = FutureProvider<AdvisorOption?>((ref) async {
  final advisorId = ref.watch(advisorContextProvider).advisorId;
  if (advisorId == null) return null;

  if (ref.exists(advisorListProvider)) {
    final cached = ref.read(advisorListProvider).value;
    if (cached != null) {
      for (final advisor in cached) {
        if (advisor.financialAdvisorId == advisorId) return advisor;
      }
      AppLogger.d('SelectedAdvisor: id not in the cached advisor list, falling back to a direct lookup');
    }
  }

  final advisor = await ref.read(advisorSelectionRepositoryProvider).getAdvisor(advisorId);

  // The selection can change while this request is in flight; a stale result
  // here would name the wrong advisor next to data scoped to a different one.
  if (ref.read(advisorContextProvider).advisorId != advisorId) {
    AppLogger.d('SelectedAdvisor: selection changed mid-request, discarding the stale result');
    return null;
  }
  return advisor;
});

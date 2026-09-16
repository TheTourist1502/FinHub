import 'package:finhub/features/leadership_advisor_selection/domain/models/advisor_option.dart';
import 'package:finhub/features/leadership_advisor_selection/presentation/providers/selected_advisor_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The advisor picked in the selection sheet but not yet committed.
///
/// The screen's Continue button is what writes through to
/// [advisorContextProvider]; the sheet only writes here. Keeping the pending
/// value in a provider (rather than screen state) lets the field and the
/// button — sibling widgets — read the same draft.
class AdvisorDraftNotifier extends Notifier<AdvisorOption?> {
  /// Seeds the draft with the advisor already in context, so re-opening the
  /// picker to switch advisors starts from the current one rather than empty.
  @override
  AdvisorOption? build() => ref.watch(selectedAdvisorProvider).value;

  /// Records [advisor] as the pending selection.
  // Write-only state — the sheet sets it; reads go through the provider.
  // ignore: avoid_setters_without_getters
  set advisor(AdvisorOption advisor) => state = advisor;
}

/// Pending advisor selection for the picker screen.
///
/// `autoDispose` so leaving the screen discards an uncommitted choice.
final NotifierProvider<AdvisorDraftNotifier, AdvisorOption?> advisorDraftProvider =
    NotifierProvider.autoDispose<AdvisorDraftNotifier, AdvisorOption?>(AdvisorDraftNotifier.new);

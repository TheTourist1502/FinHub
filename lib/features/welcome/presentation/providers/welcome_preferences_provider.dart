import 'package:finhub/core/observability/observability_provider.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Staged preference selections for the Welcome carousel's personalize page.
///
/// Unlike Profile's preference rows (which persist immediately on each
/// selection), Welcome batches every field here and sends a single
/// [WelcomeSubmitNotifier.submit] call only when the user taps "Continue".
@immutable
class WelcomePreferencesDraft {
  /// Creates a [WelcomePreferencesDraft].
  const WelcomePreferencesDraft({this.countryId, this.regionIds = const []});

  /// Staged advisor base country ID.
  final int? countryId;

  /// Staged region/market-served IDs (multi-select).
  final List<int> regionIds;

  /// Returns a copy of this draft with the given fields replaced.
  WelcomePreferencesDraft copyWith({int? countryId, List<int>? regionIds}) {
    return WelcomePreferencesDraft(countryId: countryId ?? this.countryId, regionIds: regionIds ?? this.regionIds);
  }
}

/// Holds the staged [WelcomePreferencesDraft] for the personalize page.
///
/// Seeded from [currentProfileProvider] where available, so a returning
/// session shows previously-saved selections. Every setter is a synchronous,
/// local-only state update — no fixture write happens until
/// [WelcomeSubmitNotifier.submit] runs.
class WelcomeDraftNotifier extends Notifier<WelcomePreferencesDraft> {
  @override
  WelcomePreferencesDraft build() {
    final profile = ref.read(currentProfileProvider).value;
    return WelcomePreferencesDraft(countryId: profile?.selectedCountryId, regionIds: profile?.selectedRegionIds ?? const []);
  }

  /// Stages a new advisor base country selection.
  void setCountry(int countryId) => state = state.copyWith(countryId: countryId);

  /// Stages a new region/market-served selection (multi-select).
  void setRegions(List<int> regionIds) => state = state.copyWith(regionIds: regionIds);
}

/// Riverpod provider for the staged [WelcomePreferencesDraft].
final welcomeDraftProvider = NotifierProvider<WelcomeDraftNotifier, WelcomePreferencesDraft>(WelcomeDraftNotifier.new);

/// Submits the staged [WelcomePreferencesDraft] as a single
/// [ProfileRepository.updatePreferences] call and exposes its own loading
/// state, read by the Welcome screen's Continue button.
class WelcomeSubmitNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Sends every staged field in one write, clearing `firstTimeLogin` so
  /// `routeGuard` stops sending this advisor back through the carousel, then
  /// caches the profile the repository echoes back.
  Future<void> submit() async {
    state = const AsyncLoading();
    final reporter = ref.read(errorReporterProvider);
    try {
      final draft = ref.read(welcomeDraftProvider);
      final payload = <String, dynamic>{
        'language': 'en',
        'theme': 'light',
        'firstTimeLogin': false,
        if (draft.countryId != null) 'countryId': draft.countryId,
        if (draft.regionIds.isNotEmpty) 'regionIds': draft.regionIds,
      };
      final updated = await ref.read(profileRepositoryProvider).updatePreferences(payload);
      ref.read(currentProfileProvider.notifier).applyUpdate(updated);

      state = const AsyncData(null);
    } on Object catch (e, s) {
      AppLogger.e('WelcomeSubmitNotifier.submit failed', e, s);
      reporter.report(e, stackTrace: s, context: 'WelcomeSubmitNotifier.submit');
      state = AsyncError(e, s);
    }
  }
}

/// Riverpod provider for [WelcomeSubmitNotifier].
final welcomeSubmitProvider = AsyncNotifierProvider<WelcomeSubmitNotifier, void>(WelcomeSubmitNotifier.new);

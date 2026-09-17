import 'dart:async';

import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/core/observability/observability_provider.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/features/login/presentation/providers/login_provider.dart';
import 'package:finhub/features/profile/data/profile_mock_repository.dart';
import 'package:finhub/features/profile/domain/models/profile_data.dart';
import 'package:finhub/features/profile/domain/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the concrete [ProfileRepository] implementation.
///
/// Rebuilding when [currentUserProvider] changes also resets the
/// repository's in-session preference edits — exactly what should happen on
/// a fresh sign-in, and redundant with (not a substitute for) the full
/// container teardown [restartSession] already does on sign-out.
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final userId = ref.watch(currentUserProvider)?.id ?? '';
  return ProfileMockRepository(ref.watch(mockDataSourceProvider), userId);
});

/// The signed-in user's profile, fetched once per session and updated in
/// place by the preference/avatar notifiers below via [applyUpdate].
final currentProfileProvider = AsyncNotifierProvider<ProfileNotifier, ProfileData>(ProfileNotifier.new);

/// Owns the fetched [ProfileData]. Holds no update logic of its own — each
/// preference row drives its own small notifier (below) so one row's spinner
/// never lights up while a different row is updating, then calls
/// [applyUpdate] to publish the result here.
class ProfileNotifier extends AsyncNotifier<ProfileData> {
  @override
  Future<ProfileData> build() => ref.watch(profileRepositoryProvider).getProfile();

  /// Publishes an already-fetched [profile], e.g. after a preference update.
  void applyUpdate(ProfileData profile) => state = AsyncData(profile);
}

/// Fetches the country list for the "Select Country" / "Select Top Client
/// Country" preference rows.
final countriesProvider = FutureProvider<List<Country>>((ref) => ref.watch(profileRepositoryProvider).getCountries());

/// Fetches the region list for the "Select Region / Market Served" row.
final regionsProvider = FutureProvider<List<Region>>((ref) => ref.watch(profileRepositoryProvider).getRegions());

/// Base class for a preference row's own update notifier: applies a partial
/// [ProfileRepository.updatePreferences] payload, exposes its own
/// [AsyncValue] as the row's loading/error state, and publishes the result to
/// [currentProfileProvider] on success.
abstract class _PreferenceNotifier extends AsyncNotifier<void> {
  @override
  void build() {}

  /// The context string reported alongside a failure.
  String get _context;

  /// Applies [payload], independent of every other preference row's loader.
  Future<void> apply(Map<String, dynamic> payload) async {
    state = const AsyncLoading<void>();
    final reporter = ref.read(errorReporterProvider);
    try {
      final updated = await ref.read(profileRepositoryProvider).updatePreferences(payload);
      ref.read(currentProfileProvider.notifier).applyUpdate(updated);
      state = const AsyncData(null);
    } on Object catch (e, s) {
      AppLogger.e('$_context failed', e, s);
      reporter.report(e, stackTrace: s, context: _context);
      state = AsyncError(e, s);
    }
  }
}

/// Drives the "Select Country" row's own loading state, independent of every
/// other preference row.
final countryPreferenceProvider = AsyncNotifierProvider<CountryPreferenceNotifier, void>(
  CountryPreferenceNotifier.new,
);

/// See [countryPreferenceProvider].
class CountryPreferenceNotifier extends _PreferenceNotifier {
  @override
  String get _context => 'CountryPreferenceNotifier.updateCountry';

  /// Persists the selected country id.
  Future<void> updateCountry(int countryId) => apply({'countryId': countryId});
}

/// Drives the "Select Top Client Country" row's own loading state.
final topClientCountryPreferenceProvider = AsyncNotifierProvider<TopClientCountryPreferenceNotifier, void>(
  TopClientCountryPreferenceNotifier.new,
);

/// See [topClientCountryPreferenceProvider].
class TopClientCountryPreferenceNotifier extends _PreferenceNotifier {
  @override
  String get _context => 'TopClientCountryPreferenceNotifier.updateTopClientCountry';

  /// Persists the selected top-client-country id.
  Future<void> updateTopClientCountry(int countryId) => apply({'topClientCountryId': countryId});
}

/// Drives the "Select Region / Market Served" row's own loading state.
final regionPreferenceProvider = AsyncNotifierProvider<RegionPreferenceNotifier, void>(RegionPreferenceNotifier.new);

/// See [regionPreferenceProvider].
class RegionPreferenceNotifier extends _PreferenceNotifier {
  @override
  String get _context => 'RegionPreferenceNotifier.updateRegions';

  /// Persists the selected region ids (multi-select).
  Future<void> updateRegions(List<int> regionIds) => apply({'regionIds': regionIds});
}

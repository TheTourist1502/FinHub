import 'dart:io';

import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/core/utils/json_parsing.dart';
import 'package:finhub/features/profile/domain/models/profile_data.dart';
import 'package:finhub/features/profile/domain/profile_repository.dart';

/// [ProfileRepository] backed by `assets/mock-data/profile/`.
///
/// The profile describes the *signed-in user*, not the advisor a leadership
/// user may be viewing elsewhere in the app, so it is keyed by user id via
/// [MockDataSource.readScoped] rather than by [DataScope]'s advisor id.
class ProfileMockRepository implements ProfileRepository {
  /// Creates the repository over [_source] for [_userId].
  ProfileMockRepository(this._source, this._userId);

  final MockDataSource _source;
  final String _userId;

  static const _profilePath = 'profile/profile.json';
  static const _countriesPath = 'profile/countries.json';
  static const _regionsPath = 'profile/regions.json';

  /// This session's edited profile record, once a preference has changed.
  /// `null` means no edit has been made yet — reads still go to the fixture.
  Map<String, dynamic>? _sessionRaw;

  Future<Map<String, dynamic>> _readRaw() async {
    final edited = _sessionRaw;
    if (edited != null) return edited;
    final record = await _source.readScoped(_profilePath, _userId);
    if (record == null) throw const NotFoundError(message: 'No profile fixture for this user');
    return record;
  }

  @override
  Future<ProfileData> getProfile() async => ProfileData.fromJson(await _readRaw());

  @override
  Future<ProfileData> updatePreferences(Map<String, dynamic> payload) async {
    final raw = await _readRaw();
    final preferences = {...(raw['preferences'] as Map<String, dynamic>? ?? {}), ...payload};
    final updated = {...raw, 'preferences': preferences};

    // Mirrors what a PATCH response would echo back: the convenience objects
    // nested at the top level (`country`, `topClientCountry`, `regionIds`)
    // stay in sync with whichever id-only key just changed.
    if (payload['countryId'] case final int id) {
      updated['country'] = await _findCountry(id);
    }
    if (payload['topClientCountryId'] case final int id) {
      updated['topClientCountry'] = await _findCountry(id);
    }
    if (payload['regionIds'] case final List<dynamic> ids) {
      updated['regionIds'] = await _findRegions(ids.cast<int>());
    }

    _sessionRaw = updated;
    return ProfileData.fromJson(updated);
  }

  Future<Map<String, dynamic>?> _findCountry(int id) async {
    final countries = await _source.listScoped(_countriesPath, null);
    for (final c in countries) {
      if (parseInt(c['id']) == id) return c;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> _findRegions(List<int> ids) async {
    final regions = await _source.listScoped(_regionsPath, null);
    return [
      for (final r in regions)
        if (ids.contains(parseInt(r['id']))) r,
    ];
  }

  @override
  Future<List<Country>> getCountries() async =>
      (await _source.listScoped(_countriesPath, null)).map(Country.fromJson).toList();

  @override
  Future<List<Region>> getRegions() async =>
      (await _source.listScoped(_regionsPath, null)).map(Region.fromJson).toList();

  /// Accepts the picked [imageFile] and returns no URL.
  ///
  /// ponytail: there is nowhere to upload to, and the avatar is rendered with
  /// `CachedNetworkImage`, which cannot read a local file — so returning an
  /// empty URL leaves the initials fallback showing rather than a broken
  /// image. Serving the picked file directly would mean teaching the avatar
  /// widget about local paths for a build with no backend to round-trip to.
  @override
  Future<String> uploadAvatar(File imageFile) async {
    AppLogger.i('Avatar upload skipped — this build has no storage to upload ${imageFile.path} to');
    return '';
  }
}

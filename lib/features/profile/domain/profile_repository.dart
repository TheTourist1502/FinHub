import 'package:finhub/features/profile/domain/models/profile_data.dart';

/// Abstract repository for reading and updating the signed-in user's profile.
abstract class ProfileRepository {
  /// Fetches the signed-in user's profile record.
  Future<ProfileData> getProfile();

  /// Applies a partial update to the signed-in user's preferences.
  ///
  /// [payload] applies as a partial update — only the included keys change.
  /// Returns the updated [ProfileData] so callers can use it directly as the
  /// new profile instead of merging [payload] in by hand.
  Future<ProfileData> updatePreferences(Map<String, dynamic> payload);

  /// Fetches the list of countries offered by the country/top-client-country pickers.
  Future<List<Country>> getCountries();

  /// Fetches the list of regions offered by the region/market-served picker.
  Future<List<Region>> getRegions();
}

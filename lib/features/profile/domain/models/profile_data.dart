import 'package:finhub/core/utils/json_parsing.dart';
import 'package:flutter/foundation.dart';

/// A single entry from the `recentLogins` array of the profile fixture.
@immutable
class RecentLogin {
  /// Creates a [RecentLogin].
  const RecentLogin({required this.device, this.loginAt});

  /// Deserialises from the fixture's map.
  factory RecentLogin.fromJson(Map<String, dynamic> json) {
    return RecentLogin(device: parseString(json['device']), loginAt: parseOptionalDateTime(json['loginAt']));
  }

  /// Human-readable device and platform string (e.g. "Android 15 · Pixel 8").
  final String device;

  /// When this login happened; `null` when the fixture omits it.
  ///
  /// A UTC instant with meaningful time-of-day, so display it via
  /// `DateFormat.formatLocal`.
  final DateTime? loginAt;
}

/// A single country entry, from `assets/mock-data/profile/countries.json` or
/// nested under the `country` key of the profile fixture.
@immutable
class Country {
  /// Creates a [Country].
  const Country({required this.id, required this.name, required this.isoCode});

  /// Deserialises from the fixture's map.
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(id: parseInt(json['id']), name: parseString(json['name']), isoCode: parseString(json['isoCode']));
  }

  /// Numeric country identifier used by `preferences.countryId`.
  final int id;

  /// Display name (e.g. "United States").
  final String name;

  /// ISO 3166-1 alpha-2 country code (e.g. "US").
  final String isoCode;
}

/// A single region entry, from `assets/mock-data/profile/regions.json`.
///
/// Displayed using [marketsServed] as the label while [id] is the value held
/// in `preferences.regionIds`.
@immutable
class Region {
  /// Creates a [Region].
  const Region({required this.id, required this.name, required this.marketsServed});

  /// Deserialises from the fixture's map.
  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: parseInt(json['id']),
      name: parseString(json['name']),
      marketsServed: parseString(json['marketsServed']),
    );
  }

  /// Numeric region identifier used by `preferences.regionIds`.
  final int id;

  /// Region name (e.g. "Latin America").
  final String name;

  /// Market-served label shown to the user in the region picker.
  final String marketsServed;
}

/// The signed-in user's profile record, from `assets/mock-data/profile/profile.json`.
///
/// Keeps the raw JSON map (rather than a field per property) so an in-session
/// preference edit can be applied with a shallow merge and re-parsed, exactly
/// mirroring how a `PATCH` response would look.
@immutable
class ProfileData {
  /// Creates a [ProfileData].
  const ProfileData({required this.raw});

  /// Deserialises from the fixture's map.
  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(raw: json);

  /// The full record, keyed the same as the fixture.
  final Map<String, dynamic> raw;

  /// Profile record's unique identifier (the signed-in user's id).
  String get id => parseString(raw['id']);

  /// User's full name.
  String get fullName => parseString(raw['fullName']);

  /// Financial advisor id; empty for a leadership user.
  String get financialAdvisorId => parseString(raw['financialAdvisorId']);

  /// User's FinHub-issued email address, distinct from the sign-in email.
  String get companyEmail => parseString(raw['companyEmail']);

  /// User's unique IP code, shown as a badge in the profile header.
  String get ipCode => parseString(raw['ipCode']);

  /// Raw role string (e.g. `"advisor"`).
  ///
  /// This is display-only — the token's `role` claim, not this value, decides
  /// access.
  String get role => parseString(raw['role']);

  /// Whether the account is active; drives the verified badge in the header.
  bool get isActive => raw['isActive'] as bool? ?? false;

  /// Whether the account has been soft-deleted.
  bool get isDeleted => raw['isDeleted'] as bool? ?? false;

  /// Phone number; null when not set.
  String? get phone => parseOptionalString(raw['phone']);

  /// URL of the uploaded avatar image; null when none has been set.
  String? get avatarUrl => parseOptionalString(raw['avatarUrl']);

  /// Registered country, parsed from the nested `country` object.
  Country? get country {
    final c = raw['country'] as Map<String, dynamic>?;
    return c == null ? null : Country.fromJson(c);
  }

  /// Formatted "Name ( ISO )" display value for [country], e.g. `India ( IN )`.
  String get countryDisplayName {
    final c = country;
    if (c == null || c.name.isEmpty) return '';
    return '${c.name} ( ${c.isoCode} )';
  }

  /// Country id to highlight as selected in the country picker.
  int? get selectedCountryId => country?.id ?? parseOptionalInt(preferences['countryId']);

  /// Raw preferences map; empty when not set.
  Map<String, dynamic> get preferences => (raw['preferences'] as Map<String, dynamic>?) ?? const {};

  /// Top client's country, parsed from the nested `topClientCountry` object.
  Country? get topClientCountry {
    final c = raw['topClientCountry'] as Map<String, dynamic>?;
    return c == null ? null : Country.fromJson(c);
  }

  /// Formatted "Name ( ISO )" display value for [topClientCountry].
  String get topClientCountryDisplayName {
    final c = topClientCountry;
    if (c == null || c.name.isEmpty) return '';
    return '${c.name} ( ${c.isoCode} )';
  }

  /// Top-client-country id to highlight as selected in the country picker.
  int? get selectedTopClientCountryId => topClientCountry?.id ?? parseOptionalInt(preferences['topClientCountryId']);

  /// Selected regions/markets served, parsed from the top-level `regionIds`
  /// array of full region objects.
  List<Region> get regions {
    final list = raw['regionIds'] as List<dynamic>?;
    if (list == null) return const [];
    return list.whereType<Map<String, dynamic>>().map(Region.fromJson).toList();
  }

  /// Region ids to highlight as selected in the region picker.
  List<int> get selectedRegionIds => regions.isNotEmpty
      ? regions.map((r) => r.id).toList()
      : ((preferences['regionIds'] as List<dynamic>?) ?? const []).whereType<int>().toList();

  /// Parsed list of recent login sessions (newest first).
  List<RecentLogin> get recentLogins {
    final list = raw['recentLogins'] as List<dynamic>?;
    if (list == null) return const [];
    return list.whereType<Map<String, dynamic>>().map(RecentLogin.fromJson).toList();
  }
}

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the app-wide [MockDataSource].
final mockDataSourceProvider = Provider<MockDataSource>((ref) => MockDataSource());

/// Reads the JSON fixtures under `assets/mock-data/`.
///
/// Each fixture is a JSON object keyed by whatever scopes it — an advisor id,
/// an account id, a household id, or `default` for data that is the same for
/// everyone. [readScoped] picks the record matching the requested key and
/// falls back to `default`.
///
/// Files are cached after their first read: the bundle is immutable for the
/// life of the process, so re-decoding it per call buys nothing.
class MockDataSource {
  /// Creates a data source over the asset bundle.
  MockDataSource();

  final Map<String, Map<String, dynamic>> _cache = {};

  /// Reads a whole fixture, e.g. `auth/users.json`.
  Future<Map<String, dynamic>> read(String path) async {
    final cached = _cache[path];
    if (cached != null) return cached;
    final raw = await rootBundle.loadString('assets/mock-data/$path');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return _cache[path] = decoded;
  }

  /// Reads the record in [path] keyed by [key], falling back to `default`.
  ///
  /// Returns `null` when neither is present — a missing record is an ordinary
  /// empty state, not an error.
  Future<Map<String, dynamic>?> readScoped(String path, String? key) async {
    final file = await read(path);
    final record = (key == null ? null : file[key]) ?? file['default'];
    return record as Map<String, dynamic>?;
  }
}

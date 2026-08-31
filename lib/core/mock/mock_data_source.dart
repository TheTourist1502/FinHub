import 'dart:convert';

import 'package:flutter/foundation.dart' show visibleForTesting;
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

  /// Fixtures the user has edited in-app, held for the life of the session.
  ///
  /// The bundle is read-only, so a screen that writes (personalisation, say)
  /// parks its result here and every later read sees it. Sign-out discards the
  /// container along with this map.
  final Map<String, Map<String, dynamic>> _edits = {};

  /// Injects [file] as the already-decoded contents of [path], so a test can
  /// exercise the scoping and envelope rules without an asset bundle.
  @visibleForTesting
  void seedForTest(String path, Map<String, dynamic> file) => _cache[path] = file;

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

  /// Reads the list in [path] keyed by [key], falling back to `default`.
  ///
  /// Accepts both fixture shapes: a bare JSON array, and the page envelope
  /// `{data, nextCursor, totalCount}` the paged list endpoints returned. A
  /// caller that needs the cursor reads the envelope itself with [readScoped].
  ///
  /// Returns an empty list when neither is present — an advisor with no rows
  /// is an ordinary empty state, not an error.
  Future<List<Map<String, dynamic>>> listScoped(String path, String? key) async {
    final file = await read(path);
    final record = (key == null ? null : file[key]) ?? file['default'];
    final rows = record is Map<String, dynamic> ? record['data'] : record;
    if (rows is! List) return const [];
    return rows.cast<Map<String, dynamic>>();
  }

  /// Reads the `default` record of an editable fixture, or the session's own
  /// edit of it if one has been saved.
  Future<Map<String, dynamic>> readEditable(String path) async =>
      _edits[path] ?? (await read(path))['default'] as Map<String, dynamic>;

  /// Records an in-app edit to [path] for the rest of the session.
  void saveEditable(String path, Map<String, dynamic> data) => _edits[path] = data;
}
// ---------------------------------------------------------------------------
// List helpers — the filtering the list endpoints used to do server-side
// ---------------------------------------------------------------------------

/// Filters [rows] to those [keep] accepts.
List<Map<String, dynamic>> filterRows(
  List<Map<String, dynamic>> rows,
  bool Function(Map<String, dynamic>) keep,
) => rows.where(keep).toList();

/// Applies a case-insensitive substring search over [fields].
List<Map<String, dynamic>> searchRows(
  List<Map<String, dynamic>> rows,
  String? search,
  List<String> fields,
) {
  if (search == null || search.trim().isEmpty) return rows;
  final needle = search.trim().toLowerCase();
  return filterRows(
    rows,
    (row) => fields.any((field) => '${row[field] ?? ''}'.toLowerCase().contains(needle)),
  );
}

/// Sorts [rows] by [field], numerically when both values are numbers and
/// alphabetically otherwise. Descending unless [ascending] is true.
List<Map<String, dynamic>> sortRows(
  List<Map<String, dynamic>> rows,
  String field, {
  required bool ascending,
}) {
  final sorted = [...rows]..sort((a, b) {
    final left = a[field];
    final right = b[field];
    if (left is num && right is num) return left.compareTo(right);
    return '$left'.toLowerCase().compareTo('$right'.toLowerCase());
  });
  return ascending ? sorted : sorted.reversed.toList();
}

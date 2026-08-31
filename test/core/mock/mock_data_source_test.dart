import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

/// [MockDataSource.listScoped] has to accept both fixture shapes, because the
/// fixtures reproduce two different endpoint contracts: a bare array, and the
/// `{data, nextCursor, totalCount}` envelope the paged list endpoints returned.
/// Getting this wrong fails silently as an empty screen, not as an error.
void main() {
  group('listScoped', () {
    test('unwraps a bare array', () async {
      expect(await _rows({'FAP0001': _people}), hasLength(2));
    });

    test('unwraps a page envelope', () async {
      expect(await _rows({'FAP0001': {'data': _people, 'nextCursor': null, 'totalCount': 2}}), hasLength(2));
    });

    test('falls back to the default record', () async {
      expect(await _rows({'default': _people}), hasLength(2));
    });

    test('is empty for an unknown advisor with no default', () async {
      expect(await _rows({'FAP0002': _people}), isEmpty);
    });
  });
}

const _people = [
  {'name': 'a'},
  {'name': 'b'},
];

/// Runs [listScoped] for `FAP0001` against an in-memory [file].
Future<List<Map<String, dynamic>>> _rows(Map<String, dynamic> file) async {
  final source = MockDataSource()..seedForTest('x.json', file);
  return source.listScoped('x.json', 'FAP0001');
}

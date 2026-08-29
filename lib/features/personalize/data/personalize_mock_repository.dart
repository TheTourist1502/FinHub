import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/personalize/domain/models/personalize_data.dart';
import 'package:finhub/features/personalize/domain/personalize_repository.dart';

/// [IPersonalizeRepository] backed by
/// `assets/mock-data/profile/personalization.json`.
///
/// Edits are held in [MockDataSource] for the life of the session, so quick
/// actions reordered here are reflected on the dashboard immediately.
class PersonalizeMockRepository implements IPersonalizeRepository {
  /// Creates the repository over [_source].
  PersonalizeMockRepository(this._source);

  final MockDataSource _source;

  /// The fixture backing personalisation settings.
  static const _path = 'profile/personalization.json';

  @override
  Future<PersonalizeData> getPersonalizeOptions() async =>
      PersonalizeData.fromJson(await _source.readEditable(_path));

  @override
  Future<void> updatePersonalizeOptions(PersonalizeData data) async => _source.saveEditable(_path, data.toJson());
}

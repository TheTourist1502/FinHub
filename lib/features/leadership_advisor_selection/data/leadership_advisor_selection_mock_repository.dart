import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/leadership_advisor_selection/domain/advisor_selection_repository.dart';
import 'package:finhub/features/leadership_advisor_selection/domain/models/advisor_option.dart';

/// [AdvisorSelectionRepository] backed by
/// `assets/mock-data/profile/advisors.json` — the roster a leadership user
/// may pick from.
class LeadershipAdvisorSelectionMockRepository implements AdvisorSelectionRepository {
  /// Creates the repository over [_source].
  LeadershipAdvisorSelectionMockRepository(this._source);

  final MockDataSource _source;

  static const _path = 'profile/advisors.json';

  @override
  Future<List<AdvisorOption>> getAdvisors() async =>
      (await _source.listScoped(_path, 'default')).map(AdvisorOption.fromJson).toList();

  @override
  Future<AdvisorOption> getAdvisor(String financialAdvisorId) async {
    final rows = await _source.listScoped(_path, 'default');
    final found = rows.where((row) => row['financialAdvisorId'] == financialAdvisorId).firstOrNull;
    if (found == null) throw const NotFoundError(message: 'Advisor not found');
    return AdvisorOption.fromJson(found);
  }
}

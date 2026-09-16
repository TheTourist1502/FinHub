import 'package:finhub/features/leadership_advisor_selection/domain/models/advisor_option.dart';

/// Contract for reading the financial advisors a leadership user may select
/// as the active data context for the app.
abstract class AdvisorSelectionRepository {
  /// Returns every advisor the signed-in leadership user may select.
  Future<List<AdvisorOption>> getAdvisors();

  /// Returns the single advisor identified by [financialAdvisorId].
  ///
  /// Used to rehydrate the selected-advisor context on cold start without
  /// fetching the full list.
  Future<AdvisorOption> getAdvisor(String financialAdvisorId);
}

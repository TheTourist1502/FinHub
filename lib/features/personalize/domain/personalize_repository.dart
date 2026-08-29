import 'package:finhub/features/personalize/domain/models/personalize_data.dart';

/// Abstract contract for loading and persisting personalisation settings.
///
/// The concrete implementation ([PersonalizeApi]) reads from a local mock
/// JSON asset; swap it for an HTTP implementation when the backend is ready.
abstract interface class IPersonalizeRepository {
  /// Returns the current personalisation settings for the authenticated advisor.
  Future<PersonalizeData> getPersonalizeOptions();

  /// Persists the given [data] to the backend (no-op in the mock impl).
  Future<void> updatePersonalizeOptions(PersonalizeData data);
}

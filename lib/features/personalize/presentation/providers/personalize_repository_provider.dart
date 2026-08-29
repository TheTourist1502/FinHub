import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/personalize/data/personalize_mock_repository.dart';
import 'package:finhub/features/personalize/domain/personalize_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Maximum number of quick-action shortcuts that can be enabled simultaneously.
const kMaxQuickActions = 3;

/// Provides the concrete [IPersonalizeRepository] implementation.
///
/// Lives apart from the Personalize screen's own notifier because the
/// dashboard derives its quick-action bar from these settings and must not
/// depend on that screen. Override in tests with an in-memory fake.
final personalizeRepositoryProvider = Provider<IPersonalizeRepository>(
  (ref) => PersonalizeMockRepository(ref.watch(mockDataSourceProvider)),
);

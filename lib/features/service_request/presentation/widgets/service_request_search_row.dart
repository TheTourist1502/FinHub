import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/service_request/presentation/providers/service_request_provider.dart';
import 'package:finhub/shared/widgets/inputs/app_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Search field above the Service Requests list.
///
/// Pushes every keystroke straight into [serviceRequestSearchQueryProvider]
/// with no debounce — filtering runs over an in-memory list, so there is no
/// request to throttle. Which fields a query is matched against is the model's
/// business: see [ServiceRequestItem.matchesSearch].
class ServiceRequestSearchRow extends ConsumerWidget {
  /// Creates a [ServiceRequestSearchRow].
  const ServiceRequestSearchRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppSearchField(
      hintText: context.l10n.serviceRequestSearchHint,
      onChanged: (q) => ref.read(serviceRequestSearchQueryProvider.notifier).query = q,
    );
  }
}

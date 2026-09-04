import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/features/service_request/presentation/providers/service_request_provider.dart';
import 'package:finhub/shared/widgets/transaction/transaction_filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// All / Open / Closed chip row above the service request list.
///
/// Renders whatever [availableServiceRequestFiltersProvider] offers, so the
/// "All" chip disappears on its own once an endpoint fails, and highlights
/// [effectiveServiceRequestFilterProvider] rather than the raw selection so
/// the highlight always matches the list below.
///
/// Scrolls horizontally so the row degrades to a swipe instead of overflowing
/// on narrow screens or at large text scales.
class ServiceRequestFilterChips extends ConsumerWidget {
  /// Creates a [ServiceRequestFilterChips].
  const ServiceRequestFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final available = ref.watch(availableServiceRequestFiltersProvider);
    final active = ref.watch(effectiveServiceRequestFilterProvider);

    // The scroll view shrink-wraps to the chips' width, so without the
    // [Align] the parent column centres the whole row on wide screens.
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final filter in available)
              Padding(
                padding: EdgeInsets.only(right: filter == available.last ? 0 : 8),
                child: TransactionFilterChip(
                  label: _label(filter, l10n),
                  selected: filter == active,
                  onTap: () => ref.read(serviceRequestFilterProvider.notifier).filter = filter,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Localised chip label for [filter].
  String _label(ServiceRequestFilter filter, AppLocalizations l10n) => switch (filter) {
    ServiceRequestFilter.all => l10n.serviceRequestFilterAll,
    ServiceRequestFilter.active => l10n.serviceRequestFilterActive,
    ServiceRequestFilter.closed => l10n.serviceRequestFilterClosed,
  };
}

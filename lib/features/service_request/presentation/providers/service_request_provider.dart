import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/service_request/data/service_request_mock_repository.dart';
import 'package:finhub/features/service_request/domain/models/service_request_item.dart';
import 'package:finhub/features/service_request/domain/service_request_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the [IServiceRequestRepository] implementation in use.
///
/// [ServiceRequestApi] serves the data from the live status endpoints.
///
/// Override with a fake in widget/unit tests to avoid real network calls.
final Provider<IServiceRequestRepository> serviceRequestRepositoryProvider = Provider<IServiceRequestRepository>(
  (ref) => ServiceRequestMockRepository(ref.watch(mockDataSourceProvider), ref.watch(dataScopeProvider)),
);

/// Loads the FA's **active** service requests from
/// `GET /v1/service-requests/status`.
final FutureProvider<List<ServiceRequestItem>> serviceRequestsProvider =
    FutureProvider.autoDispose<List<ServiceRequestItem>>(
      (ref) => ref.watch(serviceRequestRepositoryProvider).getServiceRequests(),
    );

/// Loads the FA's **closed** service requests from
/// `GET /v1/service-requests/closed-status`.
///
/// Kept separate from [serviceRequestsProvider] rather than merged into one
/// list, so the "Active" and "Closed" filters each render straight from their
/// own endpoint and a failure on one does not blank out the other.
final FutureProvider<List<ServiceRequestItem>> closedServiceRequestsProvider =
    FutureProvider.autoDispose<List<ServiceRequestItem>>(
      (ref) => ref.watch(serviceRequestRepositoryProvider).getClosedServiceRequests(),
    );

/// `true` while either status endpoint is in flight.
///
/// The screen waits on both before it shows anything, so the first load, a
/// per-tab retry, and a pull-to-refresh all render the same full shimmer
/// rather than a half-populated list.
final Provider<bool> serviceRequestsLoadingProvider = Provider.autoDispose<bool>(
  (ref) => ref.watch(serviceRequestsProvider).isLoading || ref.watch(closedServiceRequestsProvider).isLoading,
);

/// Which subset of service requests the list is showing.
enum ServiceRequestFilter {
  /// Active and closed requests together.
  all,

  /// Only requests from `GET /v1/service-requests/status`.
  active,

  /// Only requests from `GET /v1/service-requests/closed-status`.
  closed,
}

/// Holds the filter chip the user last picked.
///
/// This is the *requested* filter; read [effectiveServiceRequestFilterProvider]
/// to get the one actually in force, which drops "All" when an endpoint fails.
final NotifierProvider<ServiceRequestFilterNotifier, ServiceRequestFilter> serviceRequestFilterProvider =
    NotifierProvider<ServiceRequestFilterNotifier, ServiceRequestFilter>(ServiceRequestFilterNotifier.new);

/// Notifier behind [serviceRequestFilterProvider].
///
/// Holds only what the user picked; the reconciliation against which chips are
/// actually available lives in [effectiveServiceRequestFilterProvider], so a
/// transient endpoint failure never overwrites the user's choice.
class ServiceRequestFilterNotifier extends Notifier<ServiceRequestFilter> {
  @override
  ServiceRequestFilter build() => ServiceRequestFilter.all;

  /// Returns the requested filter.
  ServiceRequestFilter get filter => state;

  /// Selects [filter] and rebuilds all dependents.
  set filter(ServiceRequestFilter filter) => state = filter;
}

/// Chips to offer, in display order.
///
/// "All" needs both endpoints to have succeeded — with one of them failed it
/// could only ever show half the picture, so it is dropped and the user is
/// left to pick the tab they want and retry it.
final Provider<List<ServiceRequestFilter>> availableServiceRequestFiltersProvider =
    Provider.autoDispose<List<ServiceRequestFilter>>((ref) {
      final anyFailed =
          ref.watch(serviceRequestsProvider).hasError || ref.watch(closedServiceRequestsProvider).hasError;
      return anyFailed
          ? const [ServiceRequestFilter.active, ServiceRequestFilter.closed]
          : const [ServiceRequestFilter.all, ServiceRequestFilter.active, ServiceRequestFilter.closed];
    });

/// The filter actually in force.
///
/// Falls back off "All" when an error withdraws it, landing on whichever tab
/// still has data so the user is not left on a chip that no longer exists.
final Provider<ServiceRequestFilter> effectiveServiceRequestFilterProvider = Provider.autoDispose<ServiceRequestFilter>(
  (ref) {
    final selected = ref.watch(serviceRequestFilterProvider);
    if (ref.watch(availableServiceRequestFiltersProvider).contains(selected)) return selected;
    return ref.watch(serviceRequestsProvider).hasError ? ServiceRequestFilter.closed : ServiceRequestFilter.active;
  },
);

/// Manages the live search query string — see
/// [ServiceRequestItem.matchesSearch] for the fields it is matched against.
final NotifierProvider<ServiceRequestSearchNotifier, String> serviceRequestSearchQueryProvider =
    NotifierProvider<ServiceRequestSearchNotifier, String>(ServiceRequestSearchNotifier.new);

/// Holds the current search query.
///
/// Stores the raw text as typed — trimming and case folding happen in
/// [ServiceRequestItem.matchesSearch], so the field keeps whatever the user
/// entered while matching stays lenient.
class ServiceRequestSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  /// Returns the current search query.
  String get query => state;

  /// Updates the query and rebuilds all dependents.
  set query(String query) => state = query;
}

/// Requests for [effectiveServiceRequestFilterProvider], narrowed by
/// [serviceRequestSearchQueryProvider].
///
/// Each tab reads straight from its own endpoint, so a failure surfaces only
/// on the tab that owns it — the "All" tab is only reachable when both
/// succeeded, so it never has to reconcile one source erroring.
///
/// Grouping into the Active and Closed sections happens in the list widget
/// from each item's own [ServiceRequestItem.category], which follows the
/// endpoint it came from — so on "All" the two sources stay in their own
/// sections rather than being interleaved by their `status` text.
final Provider<AsyncValue<List<ServiceRequestItem>>> filteredServiceRequestsProvider =
    Provider.autoDispose<AsyncValue<List<ServiceRequestItem>>>((ref) {
      final active = ref.watch(serviceRequestsProvider);
      final closed = ref.watch(closedServiceRequestsProvider);

      final async = switch (ref.watch(effectiveServiceRequestFilterProvider)) {
        ServiceRequestFilter.active => active,
        ServiceRequestFilter.closed => closed,
        // "All" is only offered when both endpoints succeeded, so `closed`
        // here is always AsyncData; the guard just keeps the types honest.
        ServiceRequestFilter.all => active.whenData(
          (items) => [
            ...items,
            if (closed is AsyncData<List<ServiceRequestItem>>) ...closed.value,
          ],
        ),
      };

      final query = ref.watch(serviceRequestSearchQueryProvider);
      return async.whenData(
        // Which fields a query matches on lives with the model — see
        // [ServiceRequestItem.matchesSearch].
        (requests) => requests.where((r) => r.matchesSearch(query)).toList(),
      );
    });

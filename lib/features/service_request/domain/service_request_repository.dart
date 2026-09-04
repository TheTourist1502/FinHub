import 'package:finhub/features/service_request/domain/models/service_request_item.dart';

/// Abstract contract for Service Request data operations.
///
/// Active and closed requests come from two separate endpoints rather than one
/// list the client partitions, so each has its own method here.
abstract interface class IServiceRequestRepository {
  /// Fetches the still-open service requests for the authenticated FA.
  Future<List<ServiceRequestItem>> getServiceRequests();

  /// Fetches the resolved service requests for the authenticated FA.
  Future<List<ServiceRequestItem>> getClosedServiceRequests();
}

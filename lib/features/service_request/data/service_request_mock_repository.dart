import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/service_request/domain/models/service_request_item.dart';
import 'package:finhub/features/service_request/domain/service_request_repository.dart';

/// [IServiceRequestRepository] backed by
/// `assets/mock-data/service_requests/{active,closed}.json`.
class ServiceRequestMockRepository implements IServiceRequestRepository {
  /// Creates the repository over [_source], scoped to [_scope]'s advisor.
  ServiceRequestMockRepository(this._source, this._scope);

  final MockDataSource _source;
  final DataScope _scope;

  @override
  Future<List<ServiceRequestItem>> getServiceRequests() =>
      _load('service_requests/active.json', isClosed: false);

  @override
  Future<List<ServiceRequestItem>> getClosedServiceRequests() =>
      _load('service_requests/closed.json', isClosed: true);

  /// Reads and parses the fixture at [path] for the current advisor.
  Future<List<ServiceRequestItem>> _load(String path, {required bool isClosed}) async {
    final rows = await _source.listScoped(path, _scope.advisorId);
    return rows.map((json) => ServiceRequestItem.fromJson(json, isClosed: isClosed)).toList();
  }
}

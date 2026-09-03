import 'package:finhub/core/mock/data_scope.dart';
import 'package:finhub/core/mock/mock_data_source.dart';
import 'package:finhub/features/view_transactions/domain/models/view_transaction.dart';
import 'package:finhub/features/view_transactions/domain/models/view_transactions_page.dart';
import 'package:finhub/features/view_transactions/domain/view_transactions_repository.dart';

/// [IViewTransactionsRepository] backed by
/// `assets/mock-data/transactions/all.json`.
class ViewTransactionsMockRepository implements IViewTransactionsRepository {
  /// Creates the repository over [_source], scoped to [_scope]'s advisor.
  const ViewTransactionsMockRepository(this._source, this._scope);

  final MockDataSource _source;
  final DataScope _scope;

  @override
  Future<TransactionPage> getTransactions({String? cursor}) async {
    final rows = await _source.listScoped('transactions/all.json', _scope.advisorId);
    return TransactionPage(
      transactions: rows.map(Transaction.fromApiJson).toList(),
      nextCursor: null,
      totalCount: rows.length,
    );
  }
}

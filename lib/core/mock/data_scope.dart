import 'package:finhub/features/login/domain/models/user.dart';

/// Names the advisor a read is scoped to.
///
/// An advisor reads their own book; a leadership user reads whichever advisor
/// they picked in the FA selector, and reads nothing until they have picked
/// one. Any repository serving advisor-scoped data takes a [DataScope], and
/// providers must **watch** it so a leadership advisor switch rebuilds them.
class DataScope {
  /// Creates a scope naming [advisorId].
  const DataScope(this.advisorId);

  /// Builds the scope implied by [user] alone — their own book for an
  /// advisor, unresolved for leadership until they select one.
  factory DataScope.forUser(User? user) => DataScope(user?.advisorId);

  /// The advisor whose data is readable, or `null` when none is selected.
  final String? advisorId;

  /// Whether a read can proceed. `false` means "leadership, no advisor picked".
  bool get isResolved => advisorId != null;

  @override
  bool operator ==(Object other) => other is DataScope && other.advisorId == advisorId;

  @override
  int get hashCode => advisorId.hashCode;

  @override
  String toString() => 'DataScope($advisorId)';
}

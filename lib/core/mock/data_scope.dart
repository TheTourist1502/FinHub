import 'package:finhub/core/advisor_context/advisor_context_provider.dart';
import 'package:finhub/features/login/domain/models/user.dart';
import 'package:finhub/features/login/presentation/providers/login_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The advisor the signed-in user is currently reading.
///
/// An advisor reads their own book. Leadership resolves to whichever advisor
/// is picked in the FA selector, tracked by [advisorContextProvider] —
/// [advisorContextProvider] is watched, not read, so a leadership advisor
/// switch rebuilds every scoped repository.
final dataScopeProvider = Provider<DataScope>(
  (ref) => DataScope.forUser(ref.watch(currentUserProvider), ref.watch(advisorContextProvider).advisorId),
);

@immutable
/// Names the advisor a read is scoped to.
///
/// An advisor reads their own book; a leadership user reads whichever advisor
/// they picked in the FA selector, and reads nothing until they have picked
/// one. Any repository serving advisor-scoped data takes a [DataScope], and
/// providers must **watch** it so a leadership advisor switch rebuilds them.
class DataScope {
  /// Creates a scope naming [advisorId].
  const DataScope(this.advisorId);

  /// Builds the scope for [user] — their own book for an advisor,
  /// [leadershipAdvisorId] for leadership (unresolved when that is `null`,
  /// i.e. nothing picked yet, or still being restored).
  ///
  /// [User.advisorId] is `null` for every leadership user, so it is safe to
  /// fall back to [leadershipAdvisorId] whenever [User.advisorId] is absent.
  factory DataScope.forUser(User? user, String? leadershipAdvisorId) =>
      DataScope(user?.advisorId ?? leadershipAdvisorId);

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

import 'dart:async';

import 'package:finhub/core/config/app_constants.dart';
import 'package:finhub/core/observability/observability_provider.dart';
import 'package:finhub/core/storage/storage_provider.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/features/login/domain/models/user.dart';
import 'package:finhub/features/login/presentation/providers/login_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The advisor a leadership user has picked to view, and whether that answer
/// is settled yet.
///
/// *Resolved with a `null` [advisorId]* means the user genuinely has none
/// selected — the route guard should send them to the picker. *Restoring*
/// means the persisted choice is still being read off disk, so neither
/// redirecting nor scoping a request should happen yet: the router holds the
/// current screen until this resolves, exactly like [AuthUnknown] does for
/// the cold-start session check.
@immutable
class AdvisorContext {
  /// The answer is known: [advisorId] is the selection, or `null` when none
  /// has been made.
  const AdvisorContext.resolved(this.advisorId) : isRestoring = false;

  /// The persisted selection is still being read; the answer is not known yet.
  const AdvisorContext.restoring() : advisorId = null, isRestoring = true;

  /// The advisor whose data is being shown, or `null` when none is selected.
  final String? advisorId;

  /// Whether the persisted leadership selection is still being read off disk.
  final bool isRestoring;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdvisorContext && other.advisorId == advisorId && other.isRestoring == isRestoring;

  @override
  int get hashCode => Object.hash(advisorId, isRestoring);

  @override
  String toString() => isRestoring ? 'AdvisorContext.restoring()' : 'AdvisorContext.resolved($advisorId)';
}

/// Holds the advisor id a leadership user has picked as the active data
/// context; a no-op for every other role, whose scope comes straight from
/// [User.advisorId].
///
/// A plain [Notifier], not an [AsyncNotifier]: nearly every reader (the route
/// guard, [DataScope.forUser]) needs the answer synchronously, and for a
/// non-leadership user it always is. The one genuinely async step — reading
/// the persisted selection off disk for a leadership user — is modelled by
/// [AdvisorContext.restoring] instead of an [AsyncValue], so callers never see
/// a loading state that cannot occur for their own role.
class AdvisorContextNotifier extends Notifier<AdvisorContext> {
  /// Last known leadership selection, kept alive across [build] re-runs and
  /// scoped to [_cachedForUserId] so a fresh sign-in never inherits the
  /// previous leadership user's choice from this in-memory cache.
  ///
  /// Instance state, not `static`: sign-out discards the whole Riverpod
  /// container ([SessionRoot.restartSession]), which is exactly the lifetime
  /// this cache should have.
  String? _cached;
  String? _cachedForUserId;

  @override
  AdvisorContext build() {
    final user = ref.watch(currentUserProvider);

    // Advisors (and a signed-out user) never restore anything — their scope
    // is either User.advisorId or nothing.
    if (user == null || user.role != UserRole.leadership) return const AdvisorContext.resolved(null);

    if (_cachedForUserId == user.id) return AdvisorContext.resolved(_cached);

    // A different leadership identity: drop the previous selection before
    // the restore below can be mistaken for it.
    _cached = null;
    _cachedForUserId = null;

    // Fire-and-forget: state must stay synchronous, and `_RouterChangeNotifier`
    // listens to this provider so the guard re-evaluates once the read lands.
    unawaited(_restore(user.id));
    return const AdvisorContext.restoring();
  }

  /// Loads the persisted advisor selection for [userId] into state.
  ///
  /// A missing value or a failed read both resolve to "no selection" rather
  /// than leaving the context restoring forever — that is recoverable via the
  /// picker, a permanently stuck restore is not.
  Future<void> _restore(String userId) async {
    try {
      final stored = await ref.read(storageServiceProvider).getSecure(StorageKeys.selectedAdvisorId);
      if (!ref.mounted || _cachedForUserId != null) return; // a selection made mid-read wins
      _cached = (stored == null || stored.isEmpty) ? null : stored;
      _cachedForUserId = userId;
      state = AdvisorContext.resolved(_cached);
    } on Object catch (e, s) {
      AppLogger.e('AdvisorContext: restoring the persisted advisor selection failed', e, s);
      ref.read(errorReporterProvider).report(e, stackTrace: s, context: 'AdvisorContextNotifier._restore');
      if (ref.mounted) state = const AdvisorContext.resolved(null);
    }
  }

  /// Records [advisorId] as the active selection and persists it.
  ///
  /// State updates before the write is awaited — nothing downstream needs to
  /// wait on the disk round-trip to see the new scope take effect.
  Future<void> select(String advisorId) async {
    _cached = advisorId;
    _cachedForUserId = ref.read(currentUserProvider)?.id;
    state = AdvisorContext.resolved(advisorId);
    await ref.read(storageServiceProvider).setSecure(StorageKeys.selectedAdvisorId, advisorId);
  }
}

/// Provides the advisor context a leadership user has selected.
///
/// See [AdvisorContextNotifier] for per-role semantics and [AdvisorContext]
/// for why "no selection" and "not yet loaded" are kept distinct.
final advisorContextProvider = NotifierProvider<AdvisorContextNotifier, AdvisorContext>(AdvisorContextNotifier.new);

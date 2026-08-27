import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Hosts the [ProviderScope] and can throw the whole container away.
///
/// Sign-out discards **every** provider at once rather than invalidating an
/// enumerated list: such a list rots silently as features are added, and its
/// failure mode is the previous user's data showing to the next one.
///
/// This is the one widget in the app allowed to use [setState] — it sits
/// *above* Riverpod, so Riverpod cannot own the state whose job is destroying
/// the Riverpod container.
class SessionRoot extends StatefulWidget {
  /// Creates the root. [overrides] and [observers] are re-applied to every
  /// rebuilt container.
  const SessionRoot({required this.child, this.overrides = const [], this.observers = const [], super.key});

  /// The app below the scope.
  final Widget child;

  /// Overrides applied to each container.
  final List<Override> overrides;

  /// Observers attached to each container.
  final List<ProviderObserver> observers;

  @override
  State<SessionRoot> createState() => _SessionRootState();

  /// Discards the current provider container and builds a fresh one.
  ///
  /// Call it only **after** `AuthService.clearAuthData()` has completed — the
  /// rebuilt session check reads storage, and would restore the session it was
  /// meant to end.
  static void restartSession(BuildContext context) {
    context.findAncestorStateOfType<_SessionRootState>()!._restart();
  }
}

class _SessionRootState extends State<SessionRoot> {
  /// Changing the scope's key forces Flutter to dispose the old
  /// [ProviderScope] element — and with it every provider it held.
  Key _scopeKey = UniqueKey();

  void _restart() => setState(() => _scopeKey = UniqueKey());

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      key: _scopeKey,
      overrides: widget.overrides,
      observers: widget.observers,
      // Riverpod 3 retries every failed provider up to 10x with exponential
      // backoff by default. The app has its own retry UX, so disable the
      // built-in retry and let error states reach the UI immediately.
      retry: (retryCount, error) => null,
      child: widget.child,
    );
  }
}

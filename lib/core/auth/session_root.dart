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
  /// Creates the root. [scopeBuilder] is called with a fresh key on every
  /// restart and must apply it to the [ProviderScope] it returns; the scope's
  /// overrides and observers live at the call site, with the rest of start-up.
  const SessionRoot({required this.scopeBuilder, super.key});

  /// Builds the scope for the current session.
  final ProviderScope Function(Key scopeKey) scopeBuilder;

  @override
  State<SessionRoot> createState() => _SessionRootState();

  /// Discards the current provider container and builds a fresh one.
  ///
  /// Call it only **after** `AuthService.clearAuthData()` has completed — the
  /// rebuilt session check reads storage, and would restore the very session
  /// it was meant to end.
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
  Widget build(BuildContext context) => widget.scopeBuilder(_scopeKey);
}

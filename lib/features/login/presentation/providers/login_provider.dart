import 'dart:async';

import 'package:finhub/core/auth/auth_service.dart';
import 'package:finhub/core/auth/auth_service_provider.dart';
import 'package:finhub/core/auth/session_root.dart';
import 'package:finhub/core/mock/mock_auth.dart';
import 'package:finhub/core/observability/observability_provider.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/features/login/domain/models/invalid_session_exception.dart';
import 'package:finhub/features/login/domain/models/user.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The session's state, as the router and the login form see it.
sealed class AuthState {
  const AuthState();
}

/// The cold-start session check has not finished. The router holds still.
final class AuthUnknown extends AuthState {
  const AuthUnknown();
}

/// No live session.
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// A sign-in attempt is in flight.
final class AuthAuthenticating extends AuthState {
  const AuthAuthenticating();
}

/// A live session, carrying the signed-in [user] and their role.
final class AuthAuthenticated extends AuthState {
  /// Creates the authenticated state.
  const AuthAuthenticated(this.user);

  /// Who is signed in.
  final User user;
}

/// Owns the session state. The single writer of anything session-shaped.
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

/// The signed-in user, or `null`. Synchronous by construction — the session is
/// resolved once at start-up and held in [AuthNotifier], so no consumer needs
/// to treat "who is signed in?" as an async question.
final currentUserProvider = Provider<User?>((ref) {
  final state = ref.watch(authNotifierProvider);
  return state is AuthAuthenticated ? state.user : null;
});

/// Drives sign-in, cold-start session restore, and sign-out.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Fire-and-forget: the router renders against AuthUnknown until this
    // resolves, which on a cold start is a single storage read.
    unawaited(_restoreSession());
    return const AuthUnknown();
  }

  AuthService get _auth => ref.read(authServiceProvider);

  Future<void> _restoreSession() async {
    try {
      final user = await _auth.getCurrentUser();
      state = user == null ? const AuthUnauthenticated() : AuthAuthenticated(user);
    } on Object catch (e, s) {
      AppLogger.e('Session restore failed; starting signed out', e, s);
      ref.read(errorReporterProvider).report(e, stackTrace: s, context: 'AuthNotifier._restoreSession');
      state = const AuthUnauthenticated();
    }
  }

  /// Signs in with a username or email and a password.
  ///
  /// Returns `null` on success, or a diagnostic reason on failure — the caller
  /// turns that into localised copy. Failure leaves the state
  /// [AuthUnauthenticated]; it never throws at the widget.
  Future<String?> signIn({required String identifier, required String password}) async {
    state = const AuthAuthenticating();
    try {
      final token = await ref.read(mockAuthServiceProvider).signIn(identifier: identifier, password: password);
      final user = await _auth.persistSession(token);
      await ref.read(errorReporterProvider).setUser(id: user.id, email: user.email, name: user.name);
      state = AuthAuthenticated(user);
      return null;
    } on InvalidSessionException catch (e) {
      // Expected user-facing flow (wrong credentials) — logged, not reported.
      AppLogger.i('Sign-in refused: ${e.reason}');
      state = const AuthUnauthenticated();
      return e.reason;
    } on Object catch (e, s) {
      AppLogger.e('Unexpected error during sign-in', e, s);
      ref.read(errorReporterProvider).report(e, stackTrace: s, context: 'AuthNotifier.signIn');
      state = const AuthUnauthenticated();
      return e.toString();
    }
  }

  /// Ends the session: clears storage first, then discards the entire provider
  /// container. Order matters — see [SessionRoot.restartSession].
  Future<void> signOut(BuildContext context) async {
    try {
      await ref.read(errorReporterProvider).clearUser();
      await _auth.clearAuthData();
    } on Object catch (e, s) {
      // Best-effort: the session ends whether or not every key could be wiped.
      AppLogger.e('Sign-out cleanup failed; ending the session anyway', e, s);
      ref.read(errorReporterProvider).report(e, stackTrace: s, context: 'AuthNotifier.signOut');
    }
    if (context.mounted) SessionRoot.restartSession(context);
  }
}

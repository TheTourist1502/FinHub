import 'package:flutter/widgets.dart';

/// Contract for all error and crash reporting in the app.
///
/// This build ships `LoggingErrorReporter`, which writes reports through
/// `AppLogger` — there is no crash-reporting backend. `NullErrorReporter` is
/// the no-op used in tests. Adding a real SDK later means writing one more
/// implementation of this interface; no call site changes.
///
/// Every caller goes through this interface via `errorReporterProvider`, never
/// a reporting SDK directly.
abstract class ErrorReporter {
  /// [report] context prefix that opts a `ForbiddenError` out of the blanket
  /// skip on that type.
  ///
  /// Retained as the agreed name for a scope mismatch between the advisor a
  /// leadership user selected and the advisor their session permits. Declared
  /// on the interface rather than an implementation so call sites can name it
  /// without depending on a concrete reporter.
  static const String leadershipScopeDeniedContext = 'leadership-scope-denied';

  /// Initialises the reporter. Must be awaited before `runApp` is called.
  Future<void> init();

  /// Reports [error] as a non-fatal event.
  ///
  /// Silently skips expected user-facing errors — chiefly `NotFoundError`, a
  /// fixture with no record for the requested key, which the UI already shows
  /// as an empty state.
  ///
  /// Deduplicates within the session — the same `(runtimeType, toString())`
  /// fingerprint is only reported once per app launch.
  ///
  /// [context] names the call site (e.g. `'AccountsMockRepository.getAccounts'`).
  /// [extras] carries additional structured metadata attached to the event.
  void report(Object error, {StackTrace? stackTrace, String? context, Map<String, dynamic>? extras});

  /// Adds a breadcrumb log.
  ///
  /// Use for navigation events, significant lifecycle milestones, or any
  /// debug signal that helps reconstruct a failure sequence.
  void addBreadcrumb(String message, {String? category, Map<String, dynamic>? data});

  /// Returns a [NavigatorObserver] to attach to `GoRouter(observers: [...])`.
  NavigatorObserver buildNavigatorObserver();

  /// Reports [error] as a **fatal** crash.
  ///
  /// Call only from `FlutterError.onError` and
  /// `PlatformDispatcher.instance.onError` in `main.dart`. Never call from
  /// feature code.
  Future<void> reportFatal(Object error, StackTrace stackTrace);

  /// Sets the authenticated user's identity on the reporter.
  ///
  /// Call after a successful login so all subsequent events carry the user.
  Future<void> setUser({required String id, String? email, String? name});

  /// Clears user identity on logout.
  Future<void> clearUser();
}

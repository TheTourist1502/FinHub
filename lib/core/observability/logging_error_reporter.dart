import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/observability/error_reporter.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:flutter/widgets.dart';

/// The [ErrorReporter] this build ships with.
///
/// There is no crash-reporting backend here, so a report is a structured log
/// line rather than a network call. The interface is kept because it is what
/// every call site — and `.claude/rules/observability.md` — is written
/// against: swapping in a real SDK means adding one implementation, not
/// editing every `catch` block in the app.
///
/// Keeps the two behaviours callers rely on: expected user-facing errors are
/// skipped, and each distinct error is reported once per launch.
class LoggingErrorReporter implements ErrorReporter {
  /// Fingerprints already reported this launch, so a failure on a screen the
  /// user retries ten times produces one log line rather than ten.
  final Set<String> _seen = {};

  @override
  Future<void> init() async {
    AppLogger.i('ErrorReporter: reporting to the log; no crash backend is configured');
  }

  @override
  void report(Object error, {StackTrace? stackTrace, String? context, Map<String, dynamic>? extras}) {
    // A missing fixture record is shown to the user as an empty state — it is
    // an expected flow, not a defect worth a report.
    if (error is NotFoundError) return;

    if (!_seen.add('${error.runtimeType}:$error')) return;

    AppLogger.e(
      'Reported${context == null ? '' : ' [$context]'}${extras == null ? '' : ' $extras'}',
      error,
      stackTrace,
    );
  }

  @override
  void addBreadcrumb(String message, {String? category, Map<String, dynamic>? data}) {
    AppLogger.d('Breadcrumb${category == null ? '' : ' [$category]'}: $message${data == null ? '' : ' $data'}');
  }

  @override
  NavigatorObserver buildNavigatorObserver() => NavigatorObserver();

  @override
  Future<void> reportFatal(Object error, StackTrace stackTrace) async {
    AppLogger.e('Fatal', error, stackTrace);
  }

  @override
  Future<void> setUser({required String id, String? email, String? name}) async {
    AppLogger.d('ErrorReporter: user set to $id');
  }

  @override
  Future<void> clearUser() async {
    AppLogger.d('ErrorReporter: user cleared');
  }
}

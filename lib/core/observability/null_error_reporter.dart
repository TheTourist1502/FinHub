import 'package:finhub/core/observability/error_reporter.dart';
import 'package:flutter/widgets.dart';

/// No-op [ErrorReporter] used on web and in tests.
///
/// Inject in tests via:
/// ```dart
/// errorReporterProvider.overrideWithValue(NullErrorReporter())
/// ```
class NullErrorReporter implements ErrorReporter {
  @override
  Future<void> init() async {}

  @override
  void report(Object error, {StackTrace? stackTrace, String? context, Map<String, dynamic>? extras}) {}

  @override
  void addBreadcrumb(String message, {String? category, Map<String, dynamic>? data}) {}

  @override
  NavigatorObserver buildNavigatorObserver() => NavigatorObserver();

  @override
  Future<void> reportFatal(Object error, StackTrace stackTrace) async {}

  @override
  Future<void> setUser({required String id, String? email, String? name}) async {}

  @override
  Future<void> clearUser() async {}
}

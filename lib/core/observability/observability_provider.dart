import 'package:finhub/core/observability/error_reporter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the singleton [ErrorReporter] to the Riverpod graph.
///
/// **Must be overridden in `main.dart` before [ProviderScope] is built.**
/// Any provider that resolves this before the override is in place will throw.
///
/// Override in `main.dart`:
/// ```dart
/// errorReporterProvider.overrideWithValue(reporter)
/// ```
///
/// Override in tests:
/// ```dart
/// errorReporterProvider.overrideWithValue(NullErrorReporter())
/// ```
final errorReporterProvider = Provider<ErrorReporter>((ref) {
  throw UnimplementedError('errorReporterProvider must be overridden in main.dart before ProviderScope builds.');
});

import 'package:finhub/core/observability/error_reporter.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod [ProviderObserver] that forwards unexpected provider failures to
/// [ErrorReporter].
///
/// Attach to [ProviderScope] via the `observers` parameter in `main.dart`:
/// ```dart
/// ProviderScope(
///   observers: [ProviderErrorObserver(reporter)],
///   ...
/// )
/// ```
///
/// Expected domain errors (`NetworkError`, `UnauthorizedError`, etc.) are
/// filtered inside `LoggingErrorReporter.report` — no additional filtering
/// is needed here.
base class ProviderErrorObserver extends ProviderObserver {
  /// Creates a [ProviderErrorObserver] that forwards errors to `reporter`.
  const ProviderErrorObserver(this._reporter);

  final ErrorReporter _reporter;

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    final provider = context.provider;
    final name = provider.name ?? '${provider.runtimeType}';
    AppLogger.e('[ProviderObserver] $name failed', error, stackTrace);
    _reporter.report(error, stackTrace: stackTrace, context: 'provider:$name');
  }
}

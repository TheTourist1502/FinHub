import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized application logger.
///
/// All methods are **no-ops in release builds** — the [kReleaseMode] guard is a
/// compile-time constant, so the Dart AOT compiler removes every call site
/// entirely from production binaries (zero overhead, no log leakage).
///
/// Logs remain active in both debug (`flutter run`) and profile
/// (`flutter run --profile`) builds so developers can inspect behaviour
/// while using profiling tools.
///
/// Usage:
/// ```dart
/// AppLogger.d('Widget rebuilt, count=$count');
/// AppLogger.i('User signed in');
/// AppLogger.w('Token expiring soon');
/// AppLogger.e('Payment failed', error, stackTrace);
/// ```
class AppLogger {
  // Private constructor — class is used as a static utility only.
  AppLogger._();

  static final Logger _logger = Logger(printer: PrettyPrinter(lineLength: 100), filter: _ReleaseFilter());

  /// Logs a [Level.debug] message. Stripped entirely in release builds.
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kReleaseMode) return;
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a [Level.info] message for significant lifecycle events.
  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kReleaseMode) return;
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a [Level.warning] message for recoverable unexpected state.
  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kReleaseMode) return;
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Logs a [Level.error] message for exceptions and failures.
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kReleaseMode) return;
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}

/// Secondary runtime safety net — suppresses any output that reaches the
/// [Logger] while running in release mode (e.g. if called indirectly).
class _ReleaseFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => !kReleaseMode;
}

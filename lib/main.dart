import 'dart:async';

import 'package:finhub/app.dart';
import 'package:finhub/core/observability/error_reporter.dart';
import 'package:finhub/core/observability/logging_error_reporter.dart';
import 'package:finhub/core/observability/observability_provider.dart';
import 'package:finhub/core/observability/provider_error_observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Application entry point.
///
/// Initialisation order:
/// 1. [WidgetsFlutterBinding.ensureInitialized] — required before any plugin call.
/// 2. [SystemChrome.setPreferredOrientations] — locks phones to portrait.
/// 3. [ErrorReporter.init]                    — prepares error reporting.
/// 4. [FlutterError.onError]                  — captures Flutter framework errors as fatal.
/// 5. `PlatformDispatcher.instance.onError`   — captures uncaught Dart zone errors as fatal.
/// 6. [runApp]                                — builds the widget tree.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Phones are locked to portrait; tablets and iPads keep free rotation, since
  // their screens are wide enough for the landscape layouts to read well.
  // 600dp is the platform's own phone/tablet line (Android's `sw600dp`).
  final view = PlatformDispatcher.instance.views.first;
  if (view.physicalSize.shortestSide / view.devicePixelRatio < 600) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  final reporter = LoggingErrorReporter();
  await reporter.init();

  // Capture Flutter framework errors (widget build failures, rendering errors).
  // The original handler is preserved so Flutter continues to print to the
  // console in debug builds.
  final originalFlutterError = FlutterError.onError;
  FlutterError.onError = (details) {
    originalFlutterError?.call(details);
    unawaited(reporter.reportFatal(details.exception, details.stack ?? StackTrace.empty));
  };

  // Capture uncaught Dart errors from the root isolate and platform callbacks.
  // Returning true signals that the error has been handled, preventing
  // duplicate crash-log output from the default handler.
  PlatformDispatcher.instance.onError = (error, stack) {
    unawaited(reporter.reportFatal(error, stack));
    return true;
  };

  runApp(
    ProviderScope(
      observers: [ProviderErrorObserver(reporter)],
      // Riverpod 3 retries every failed provider up to 10x with exponential
      // backoff by default. The app has its own retry UX (retry buttons,
      // pull-to-refresh), so disable the built-in retry to avoid delaying
      // error states from reaching the UI.
      retry: (retryCount, error) => null,
      overrides: [errorReporterProvider.overrideWithValue(reporter)],
      child: const App(),
    ),
  );
}

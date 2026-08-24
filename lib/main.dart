import 'package:finhub/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Application entry point.
///
/// Initialisation order:
/// 1. [WidgetsFlutterBinding.ensureInitialized] — required before any plugin call.
/// 2. [SystemChrome.setPreferredOrientations] — locks phones to portrait.
/// 3. [runApp]                                — builds the widget tree.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Phones are locked to portrait; tablets and iPads keep free rotation, since
  // their screens are wide enough for the landscape layouts to read well.
  // 600dp is the platform's own phone/tablet line (Android's `sw600dp`).
  final view = PlatformDispatcher.instance.views.first;
  if (view.physicalSize.shortestSide / view.devicePixelRatio < 600) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  runApp(const App());
}

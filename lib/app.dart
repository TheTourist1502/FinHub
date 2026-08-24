import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Root widget of the FinHub application.
///
/// Currently renders a placeholder while the foundations are laid down. The
/// theme, localisation, routing and session layers replace this shell as they
/// arrive; the widget itself stays the single root the rest of the app hangs
/// off.
class App extends StatelessWidget {
  /// Creates the root widget.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'FinHub',
      debugShowCheckedModeBanner: false,
      home: _ScaffoldPlaceholder(),
    );
  }
}

/// Holding screen for the scaffolded project: the brand lockup on the splash
/// colour, so a fresh clone runs and shows something recognisable.
class _ScaffoldPlaceholder extends StatelessWidget {
  const _ScaffoldPlaceholder();

  /// Splash background — matches `flutter_native_splash`'s configured colour so
  /// the launch screen hands over to the first frame without a flash.
  static const _background = Color(0xFF081A30);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: _background,
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Iconify(Mdi.finance, color: Colors.white, size: 44),
            SizedBox(width: 12),
            Text(
              'FinHub',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 34,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                height: 1,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Debug-only horizontal stripe that displays the currently active route path.
///
/// Rebuilds automatically on every navigation event by listening to [GoRouter].
/// Renders nothing in release builds — no runtime cost in production.
class RouteBanner extends StatefulWidget {
  const RouteBanner({super.key});

  @override
  State<RouteBanner> createState() => _RouteBannerState();
}

class _RouteBannerState extends State<RouteBanner> {
  late final GoRouter _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _router = GoRouter.of(context);
    // Listen to the delegate, not routeInformationProvider.
    // routeInformationProvider.value holds the pre-redirect URI; the delegate's
    // currentConfiguration reflects the actual resolved location after guards run.
    _router.routerDelegate.addListener(_onRouteChange);
  }

  @override
  void dispose() {
    _router.routerDelegate.removeListener(_onRouteChange);
    super.dispose();
  }

  void _onRouteChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    if (kReleaseMode) return const SizedBox.shrink();

    final path = _router.routerDelegate.currentConfiguration.uri.path;

    return Container(
      width: double.infinity,
      color: const Color(0xFFFFD600),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(
        path,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1A1A1A),
          letterSpacing: 0.2,
          height: 1,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

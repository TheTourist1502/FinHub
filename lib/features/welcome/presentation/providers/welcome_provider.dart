import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Total number of pages in the welcome carousel.
const int kWelcomePageCount = 2;

/// Tracks which page of the welcome carousel is currently active.
///
/// [WelcomeScreen] owns the [PageController] that drives the swipe/animate
/// transitions; this notifier only tracks the resulting index so the
/// pagination dots can react to it via Riverpod instead of `setState`.
class WelcomePageIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  /// The active page index.
  int get page => state;

  /// Updates the active page index. Called from `PageView.onPageChanged`.
  set page(int index) => state = index;
}

/// Riverpod provider for the active welcome carousel page index.
///
/// `autoDispose` so the index resets to `0` once [WelcomeScreen] unmounts
/// (e.g. after completing onboarding and navigating home) instead of
/// persisting stale state across a later logout/re-login that revisits this
/// screen.
final NotifierProvider<WelcomePageIndexNotifier, int> welcomePageIndexProvider =
    NotifierProvider.autoDispose<WelcomePageIndexNotifier, int>(WelcomePageIndexNotifier.new);

import 'dart:async';

import 'package:finhub/core/feedback/snackbar_service.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/profile/presentation/providers/profile_provider.dart';
import 'package:finhub/features/welcome/presentation/providers/welcome_preferences_provider.dart';
import 'package:finhub/features/welcome/presentation/providers/welcome_provider.dart';
import 'package:finhub/features/welcome/presentation/widgets/welcome_hero_page.dart';
import 'package:finhub/features/welcome/presentation/widgets/welcome_page_dots.dart';
import 'package:finhub/features/welcome/presentation/widgets/welcome_personalize_page.dart';
import 'package:finhub/shared/animations/slide_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Post-login onboarding carousel (`/welcome`) — two full-page slides shown
/// after sign-in while the profile fixture reports `preferences.firstTimeLogin`,
/// before the advisor lands on the dashboard. A returning advisor goes
/// straight to the dashboard instead — see `routeGuard`.
///
/// Page 1 ("Get Started") advances to page 2; page 2's back arrow returns to
/// page 1. Page 2's "Continue" submits the staged preferences draft (see
/// [_completeAndGoHome]) — which is also what clears the fixture's
/// first-time flag — then routes to [AppRoutes.home]. Swiping between pages
/// is also supported: the [PageView] and the CTA/back-arrow buttons stay in
/// sync via [welcomePageIndexProvider].
class WelcomeScreen extends ConsumerStatefulWidget {
  /// Creates a [WelcomeScreen].
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Prefetch the country and region ("market served") lists immediately on
    // landing rather than waiting for the personalize page's selection
    // sheets to open them. Both are cached FutureProviders, so this just
    // kicks the request off early; the sheets reuse the same cached result.
    ref
      ..read(countriesProvider)
      ..read(regionsProvider);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    unawaited(
      _pageController.animateToPage(
        index,
        duration: AppMotion.duration(context, AppMotion.base),
        curve: AppMotion.enter,
      ),
    );
  }

  /// Every visible preference card on [WelcomePersonalizePage] is mandatory
  /// — returns the translated label of each field left unfilled in
  /// [welcomeDraftProvider], or an empty list if the draft is complete.
  List<String> _missingRequiredFields() {
    final l10n = context.l10n;
    final draft = ref.read(welcomeDraftProvider);
    return [
      if (draft.countryId == null) l10n.welcomeAdvisorCountryLabel,
      if (draft.regionIds.isEmpty) l10n.welcomeRegionLabel,
    ];
  }

  /// Submits the staged [welcomeDraftProvider] via [welcomeSubmitProvider],
  /// then — only on success — navigates home. On failure the notifier's own
  /// error state surfaces the error and the user stays on this page to
  /// retry.
  ///
  /// Blocked up front, before any write, if a required field is still
  /// unfilled — surfaced via a comma-joined error snackbar instead.
  Future<void> _completeAndGoHome() async {
    final missingFields = _missingRequiredFields();
    if (missingFields.isNotEmpty) {
      ref
          .read(snackbarServiceProvider)
          .showError(context.l10n.welcomeMissingFieldsError(missingFields.join(', '), missingFields.length));
      return;
    }
    await ref.read(welcomeSubmitProvider.notifier).submit();
    if (!mounted) return;
    if (ref.read(welcomeSubmitProvider).hasError) return;
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final pageIndex = ref.watch(welcomePageIndexProvider);
    final isSubmitting = ref.watch(welcomeSubmitProvider).isLoading;

    return Scaffold(
      backgroundColor: colors.surfaceDefault,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => ref.read(welcomePageIndexProvider.notifier).page = index,
                children: [
                  const WelcomeHeroPage(),
                  WelcomePersonalizePage(onBack: () => _goToPage(0)),
                ],
              ),
            ),
            // The footer is the one bar arriving *below* the page it acts
            // on, which is what earns it the livelier entrance over
            // SettleIn's 12 px rise. It rises once, on mount, and stays put
            // across page changes; the CTA is tappable the whole way up.
            SlideInClip(
              direction: SlideDirection.up,
              child: SlideIn(
                direction: SlideDirection.up,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isSubmitting ? null : (pageIndex == 0 ? () => _goToPage(1) : _completeAndGoHome),
                          child: isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Text(
                                  pageIndex == 0 ? context.l10n.welcomeGetStarted : context.l10n.commonButtonContinue,
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      WelcomePageDots(activeIndex: pageIndex),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

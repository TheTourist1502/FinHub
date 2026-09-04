import 'dart:async';

import 'package:finhub/core/feedback/snackbar_service.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/service_request/presentation/providers/service_request_provider.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_success_action_button.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_success_countdown.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_success_details.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_success_headline.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_success_icon.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Navigation payload for the Service Request Success screen.
@immutable
class ServiceRequestSuccessArgs {
  /// Creates a [ServiceRequestSuccessArgs].
  const ServiceRequestSuccessArgs({required this.recordId});

  /// The service request record ID returned from the API (e.g., accountMaintenanceRecordId).
  final String recordId;
}

/// Success screen shown after a service request is successfully submitted.
///
/// Shows the new record ID, what the request changed, and auto-redirects to
/// the service requests home page after a short countdown.
class ServiceRequestSuccessScreen extends ConsumerStatefulWidget {
  /// Creates a [ServiceRequestSuccessScreen].
  const ServiceRequestSuccessScreen({required this.args, super.key});

  /// Record ID passed in by the submitting screen.
  final ServiceRequestSuccessArgs args;

  @override
  ConsumerState<ServiceRequestSuccessScreen> createState() => _ServiceRequestSuccessScreenState();
}

/// Drives the screen's two time-based behaviours: the entry animation and the
/// countdown that redirects back to the Service Requests tab.
///
/// Observes the app lifecycle because a [Timer.periodic] keeps firing while the
/// app is backgrounded — it would redirect a screen the user cannot see, so the
/// countdown is cancelled on pause and restarted on resume.
class _ServiceRequestSuccessScreenState extends ConsumerState<ServiceRequestSuccessScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  /// Delay before auto-redirecting to the service requests home page.
  static const int _redirectDelaySeconds = 5;

  /// Tick rate of the countdown; one second so the displayed number is exact.
  static const Duration _countdownInterval = Duration(seconds: 1);

  late Timer _countdownTimer;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late int _secondsRemaining;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _animationController = AnimationController(duration: AppMotion.hero, vsync: this);
    // Both layers settle rather than spring: the mark confirms a submitted
    // request, and nothing the advisor reads as a result is allowed to bounce.
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: AppMotion.enter),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: AppMotion.enter),
    );

    unawaited(_animationController.forward());
    _secondsRemaining = _redirectDelaySeconds;
    _startCountdown();

    // The request just submitted is not in the cached status list — drop it so
    // the status endpoint is called again and the home page shows the new
    // request once the countdown redirects there. Deferred past the first frame
    // because provider writes are not allowed during widget construction.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.invalidate(serviceRequestsProvider);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Under "reduce motion" the controller is pinned at its end value, so the
    // mark renders finished on the first frame without a second code path.
    if (!AppMotion.enabled(context)) _animationController.value = 1;
  }

  /// Ticks the countdown once per second and redirects when it runs out.
  void _startCountdown() {
    _countdownTimer = Timer.periodic(_countdownInterval, (_) {
      if (!mounted) return;
      if (_secondsRemaining <= 1) {
        _countdownTimer.cancel();
        if (mounted) {
          context.go(AppRoutes.serviceRequests);
        }
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  /// Copies the record ID to the clipboard and confirms via the shared
  /// snackbar service, never `ScaffoldMessenger` directly.
  Future<void> _copyRecordId() async {
    await Clipboard.setData(ClipboardData(text: widget.args.recordId));
    if (mounted) {
      ref.read(snackbarServiceProvider).showSuccess(context.l10n.serviceRequestSuccessCopied);
    }
  }

  /// Pauses the countdown in the background and restarts it on resume.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_countdownTimer.isActive) {
      _secondsRemaining = _redirectDelaySeconds;
      _startCountdown();
    } else if (state == AppLifecycleState.paused) {
      _countdownTimer.cancel();
    }
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.bgPrimary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ServiceRequestSuccessIcon(
                  controller: _animationController,
                  scale: _scaleAnimation,
                  fade: _fadeAnimation,
                ),
                const SizedBox(height: 40),
                // The mark lands first, then the block beneath it settles in
                // order. Everything below is on screen at mount, so these play
                // straight away rather than waiting on a scroll.
                const SettleIn(child: ServiceRequestSuccessHeadline()),
                const SizedBox(height: 24),
                SettleIn(
                  index: 1,
                  child: ServiceRequestSuccessDetails(
                    recordId: widget.args.recordId,
                    onCopy: _copyRecordId,
                  ),
                ),
                const SizedBox(height: 48),
                SettleIn(
                  index: 2,
                  child: ServiceRequestSuccessCountdown(secondsRemaining: _secondsRemaining),
                ),
                const SizedBox(height: 32),
                const SettleIn(index: 3, child: ServiceRequestSuccessActionButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

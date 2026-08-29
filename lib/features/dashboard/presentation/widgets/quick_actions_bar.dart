import 'dart:async';

import 'package:finhub/core/errors/app_error.dart';
import 'package:finhub/core/feedback/snackbar_service.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/l10n/locale_provider.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/core/utils/quick_action_icons.dart';
import 'package:finhub/core/utils/quick_action_labels.dart';
import 'package:finhub/features/dashboard/domain/models/dashboard_data.dart';
import 'package:finhub/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:finhub/shared/widgets/feedback/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

// ---------------------------------------------------------------------------
// Public widget
// ---------------------------------------------------------------------------

/// Horizontal bar of quick-action shortcuts fetched from [quickActionsProvider].
///
/// Renders a shimmer row while loading, an inline error on failure, and one
/// [_QuickAction] tile per item returned by the API (up to 5 items displayed).
class QuickActionsBar extends ConsumerWidget {
  /// Creates a [QuickActionsBar].
  const QuickActionsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(quickActionsProvider);
    return asyncData.when(
      skipLoadingOnRefresh: false,
      loading: () => const _QuickActionsShimmer(),
      error: (e, _) => const ErrorView(error: UnknownError()),
      data: (actions) => _QuickActionsRow(actions: actions),
    );
  }
}

// ---------------------------------------------------------------------------
// Loaded row
// ---------------------------------------------------------------------------

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow({required this.actions});
  final List<QuickAction> actions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final display = actions.take(3).toList();

    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: display
          .map(
            (action) => Expanded(
              child: _QuickAction(
                icon: quickActionIconSvg(action.id),
                label: quickActionLabel(l10n, action.id),
                id: action.id,
              ),
            ),
          )
          .toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Single action tile
// ---------------------------------------------------------------------------

class _QuickAction extends ConsumerWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.id,
  });

  /// MDI SVG string, already resolved from the icon key.
  final String icon;

  /// Display label from the API.
  final String label;

  /// Unique semantic identifier for accessibility and UI testing.
  final String id;

  void _handleTap(BuildContext context, WidgetRef ref) {
    switch (id) {
      case 'commissions':
        unawaited(context.push(AppRoutes.myCommissions));
      case 'tasks_dashboard':
        unawaited(context.push(AppRoutes.taskDashboard));
      case 'client_search':
        unawaited(context.push('${AppRoutes.accounts}?focusSearch=true'));
      case 'account_maintenance':
        unawaited(context.push('${AppRoutes.newServiceRequest}?type=account_maintenance'));
      case 'online_access':
        unawaited(context.push('${AppRoutes.newServiceRequest}?type=online_access'));
      case 'asset_movement':
        unawaited(context.push('${AppRoutes.newServiceRequest}?type=asset_movement_withdrawals'));
      case 'investor_portal':
        unawaited(_launchInvestorPortal(context, ref));
      default:
        break;
    }
  }

  /// Opens the Investor Portal portal in the device's external browser.
  ///
  /// Logs and surfaces a snackbar error if the URL cannot be launched.
  Future<void> _launchInvestorPortal(BuildContext context, WidgetRef ref) async {
    final locale = ref.read(localeProvider).value ?? const Locale('en');
    final uri = Uri.parse(
      locale.languageCode == 'es'
          ? 'https://portal.finhub.example/nxi/welcome?isMfe=true&isModern=true&lang=es_LA'
          : 'https://portal.finhub.example/nxi/welcome?isMfe=true&isModern=true&lang=en_US',
    );
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      AppLogger.e('Could not launch Investor Portal url: $uri');
      if (context.mounted) {
        ref.read(snackbarServiceProvider).showError(context.l10n.dashboardQuickActionInvestorPortalLaunchFailedMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;

    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        key: Key(id),
        behavior: HitTestBehavior.opaque,
        onTap: () => _handleTap(context, ref),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.surfaceDefault,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Iconify(icon, color: colors.interactiveDefault),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textSecondary,
                  height: 1.15,
                  letterSpacing: 0.25,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shimmer skeleton
// ---------------------------------------------------------------------------

/// Skeleton mirroring [_QuickActionsRow]: three top-aligned, evenly spaced
/// cells, each with the real 48×48 rounded icon square and a one-line label.
class _QuickActionsShimmer extends StatelessWidget {
  const _QuickActionsShimmer();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Shimmer.fromColors(
      baseColor: colors.bgPrimary,
      highlightColor: colors.surfaceDefault,
      child: Row(
        // Same spacing and alignment as [_QuickActionsRow], so the tiles don't
        // shift sideways or vertically once the labels arrive.
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          3,
          (_) => Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ShimmerBox(size: const Size(48, 48), borderRadius: 12, color: colors.surfaceDefault),
                  const SizedBox(height: 8),
                  // Label — a single line at the real 12px × 1.15 ≈ 14 height.
                  _ShimmerBox(size: const Size(40, 14), color: colors.surfaceDefault),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Rounded placeholder block used by [_QuickActionsShimmer].
class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({required this.size, required this.color, this.borderRadius = 4});

  /// Placeholder dimensions, matching the real element's.
  final Size size;

  /// Fill colour the shimmer gradient recolors.
  final Color color;

  /// Corner radius of the placeholder.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(borderRadius)),
    );
  }
}

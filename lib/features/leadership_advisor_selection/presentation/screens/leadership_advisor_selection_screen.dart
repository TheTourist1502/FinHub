import 'package:finhub/core/advisor_context/advisor_context_provider.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/routing/app_routes.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/features/leadership_advisor_selection/domain/models/advisor_option.dart';
import 'package:finhub/features/leadership_advisor_selection/presentation/providers/advisor_draft_provider.dart';
import 'package:finhub/features/leadership_advisor_selection/presentation/providers/leadership_advisor_selection_provider.dart';
import 'package:finhub/features/leadership_advisor_selection/presentation/widgets/advisor_selection_app_bar.dart';
import 'package:finhub/features/leadership_advisor_selection/presentation/widgets/advisor_selection_field.dart';
import 'package:finhub/features/leadership_advisor_selection/presentation/widgets/advisor_selection_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Financial-advisor picker shown to leadership users.
///
/// A leadership user owns no book of business, so nothing scoped can render
/// until an advisor is chosen — the route guard redirects here from any
/// protected route while no advisor is selected, and the app bar's back arrow
/// (when this was pushed to *switch* advisors instead) returns to where the
/// switch was started.
///
/// Picking and committing are two steps: the sheet writes to
/// [advisorDraftProvider], and only Continue writes through to
/// [advisorContextProvider].
class LeadershipAdvisorSelectionScreen extends ConsumerWidget {
  /// Creates a [LeadershipAdvisorSelectionScreen].
  const LeadershipAdvisorSelectionScreen({super.key});

  /// Opens the advisor sheet and records the result as the pending selection.
  Future<void> _pick(BuildContext context, WidgetRef ref, AdvisorOption? current) async {
    final picked = await showAdvisorSelectionSheet(context, selectedId: current?.financialAdvisorId);
    if (!context.mounted) return;
    ref.read(advisorSearchQueryProvider.notifier).clear();
    if (picked == null) return;
    ref.read(advisorDraftProvider.notifier).advisor = picked;
  }

  /// Persists [advisor] as the active context and leaves the picker.
  ///
  /// The redirect off this route is driven by the route guard: committing the
  /// selection notifies `_RouterChangeNotifier`, which re-evaluates the
  /// advisor-selection gate.
  Future<void> _confirm(BuildContext context, WidgetRef ref, AdvisorOption advisor) async {
    await ref.read(advisorContextProvider.notifier).select(advisor.financialAdvisorId);
    if (!context.mounted) return;
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final draft = ref.watch(advisorDraftProvider);
    // Warms the advisor list while the user reads the heading, so the sheet
    // opens on data instead of a spinner. Watched for its side effect only.
    ref.watch(advisorListProvider);

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: const AdvisorSelectionAppBar(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.spaceMd,
            AppDimensions.spaceLg,
            AppDimensions.spaceMd,
            AppDimensions.spaceLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.selectAdvisorHeading,
                style: AppTypography.pageTitle.copyWith(color: colors.textPrimary),
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              Text(
                l10n.selectAdvisorSubtitle,
                style: TextStyle(fontFamily: 'Inter', fontSize: 14, height: 1.5, color: colors.textSecondary),
              ),
              const SizedBox(height: AppDimensions.spaceLg),
              AdvisorSelectionField(advisor: draft, onTap: () => _pick(context, ref, draft)),
              const SizedBox(height: AppDimensions.spaceLg),
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                // Disabled until something is chosen — nothing to commit yet.
                child: ElevatedButton(
                  onPressed: draft == null ? null : () => _confirm(context, ref, draft),
                  child: Text(l10n.selectAdvisorContinue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

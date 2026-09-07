import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/commissions_detailed_view/presentation/widgets/commission_details_body.dart';
import 'package:finhub/features/my_commissions/domain/models/commission_summary.dart';
import 'package:finhub/shared/widgets/layout/detail_page_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Full-screen Commission Detailed View page.
///
/// Accessed via `/my-commissions/detailed-view/:accountId`, pushed from the My
/// Commissions screen. Owns only the Scaffold; the body handles loading, error
class CommissionsDetailedViewScreen extends StatelessWidget {
  /// Creates a [CommissionsDetailedViewScreen].
  const CommissionsDetailedViewScreen({
    required this.summary,
    super.key,
  });

  /// The commission summary carried over from the My Commissions list (route
  /// `extra`), used to render the header card without a second API call and
  /// to source the account ID used to fetch detail data.
  final CommissionSummary summary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.bgPrimary,
      resizeToAvoidBottomInset: false,
      appBar: DetailPageBar(
        label: context.l10n.commissionDetailedViewTitle,
        onPrevious: () => context.pop(),
      ),
      body: CommissionDetailsBody(summary: summary),
    );
  }
}

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/features/service_request/domain/models/service_request_item.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_detail_section.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_pending_action_section.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_section_divider.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_sheet_close_button.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_sheet_handle.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_status_avatar.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_workflow_section.dart';
import 'package:finhub/shared/widgets/status/status_chip.dart';
import 'package:flutter/material.dart';

/// Opens the service request detail bottom sheet for [request].
Future<void> showServiceRequestDetailBottomSheet(BuildContext context, ServiceRequestItem request) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ServiceRequestDetailBottomSheet(request: request),
    );

/// Bottom sheet for one service request: an identity header, then the pending
/// action and the workflow rail, over a pinned close button.
///
/// The header is built inline rather than split into per-line widgets — it is
/// three text lines and an avatar, and one file reads faster than five.
class ServiceRequestDetailBottomSheet extends StatelessWidget {
  /// Creates a [ServiceRequestDetailBottomSheet].
  const ServiceRequestDetailBottomSheet({required this.request, super.key});

  /// The request to display.
  final ServiceRequestItem request;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    /// Header's primary line — the request name.
    final titleStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 20 / 15,
      color: colors.textPrimary,
    );

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.9),
      decoration: BoxDecoration(
        color: colors.surfaceDefault,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ServiceRequestSheetHandle(),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ServiceRequestStatusAvatar(status: request.workflowStatus, iconSize: 28),
                        const SizedBox(width: AppDimensions.spaceMd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Dropped rather than rendered blank when the API
                              // sends no name, so the block keeps its rhythm.
                              if (request.name.isNotEmpty) ...[
                                Text(request.name, style: titleStyle),
                                const SizedBox(height: 2),
                              ],
                              serviceRequestLabelledLine(
                                context,
                                l10n.serviceRequestDetailFinancialAccountLabel,
                                request.accountNumber,
                              ),
                              const SizedBox(height: 2),
                              serviceRequestLabelledLine(
                                context,
                                l10n.serviceRequestDetailFinancialAccountTypeLabel,
                                request.finAccountType,
                              ),
                              const SizedBox(height: 2),
                              serviceRequestLabelledLine(context, l10n.serviceRequestDetailRecordId, request.id),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const ServiceRequestSectionDivider(),
                    ServiceRequestDetailSection(
                      title: l10n.serviceRequestDetailStatus,
                      child: StatusChip(status: request.status),
                    ),
                    const SizedBox(height: AppDimensions.spaceMd),
                    ServiceRequestPendingActionSection(
                      workflowStatus: request.workflowStatus,
                      dueDate: request.dueDate,
                    ),
                    const SizedBox(height: AppDimensions.spaceMd),
                    ServiceRequestWorkflowSection(request: request),
                    const SizedBox(height: AppDimensions.spaceMd),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.spaceLg,
                AppDimensions.spaceMd,
                AppDimensions.spaceLg,
                AppDimensions.spaceLg,
              ),
              child: ServiceRequestSheetCloseButton(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/features/service_request/domain/models/service_request_item.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_status_avatar.dart';
import 'package:finhub/features/service_request/presentation/widgets/service_request_workflow_chip.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:intl/intl.dart';

/// Uppercase section label rendered above each service-request group.
class ServiceRequestSectionLabel extends StatelessWidget {
  /// Creates a [ServiceRequestSectionLabel].
  const ServiceRequestSectionLabel({required this.label, super.key});

  /// Uppercase text ("ACTIVE" or "CLOSED").
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.appColors.textTertiary;

    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.6,
        height: 16 / 12,
      ),
    );
  }
}

/// A single service request rendered as its own rounded, shadowed card.
///
/// The only card treatment on the list — both the Active and Closed sections
/// render one of these per request.
class ServiceRequestStandaloneCard extends StatelessWidget {
  /// Creates a [ServiceRequestStandaloneCard].
  const ServiceRequestStandaloneCard({required this.request, this.onView, super.key});

  /// The request to display.
  final ServiceRequestItem request;

  /// Called when the "View" link is tapped. Omit to hide the link's tap affordance.
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderDefault),
        boxShadow: [
          BoxShadow(color: colors.cardShadow, blurRadius: 1, offset: const Offset(0, 1)),
        ],
      ),
      padding: const EdgeInsets.all(17),
      child: _ServiceRequestCardBody(request: request, onView: onView),
    );
  }
}

/// The request's own content — icon, status badge, identifiers and due date —
/// with no frame of its own.
///
/// Kept separate from [ServiceRequestStandaloneCard]'s frame so the content and
/// the card outline stay independently readable.
class _ServiceRequestCardBody extends StatelessWidget {
  const _ServiceRequestCardBody({required this.request, this.onView});

  final ServiceRequestItem request;
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final hasStatusLabel = request.statusLabel != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Colour and glyph both come from the workflow stage, and degrade to
        // the neutral palette with a question mark when the API reports none.
        ServiceRequestStatusAvatar(status: request.workflowStatus),
        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                // Chip hard left, "View" hard right. The empty box keeps the
                // link pinned right on requests that carry no workflow stage —
                // spaceBetween would otherwise pull a lone child to the start.
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (hasStatusLabel)
                    Flexible(
                      child: ServiceRequestWorkflowChip(status: request.statusLabel),
                    )
                  else
                    const SizedBox.shrink(),
                  GestureDetector(
                    onTap: onView,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        l10n.serviceRequestView,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          height: 16 / 13,
                          fontWeight: FontWeight.w500,
                          color: colors.interactiveDefault,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              Text(
                '${request.accountNumber} • ${request.finAccountType}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                  letterSpacing: 0.25,
                  height: 16 / 11,
                ),
              ),
              const SizedBox(height: 2),
              if (request.name.isNotEmpty)
                Text(
                  request.name,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                    height: 18 / 14,
                  ),
                ),
              // Icon and label both go when there is no date — a request
              // with nothing on file must not show a synthesised due date.
              if (request.dueDate != null) ...[
                const SizedBox(height: 4),
                _ServiceRequestDueDateRow(date: request.dueDate!),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Absolute format used once a date is far enough out to need a real date.
final DateFormat _kAbsoluteDateFormat = DateFormat('MMM d, yyyy');

/// A request's date, rendered as a calendar icon plus a plain label.
///
/// Deliberately carries no overdue styling or "N days ago" phrasing — a past
/// date reads exactly like any other, since the list groups by status alone
/// and never reports a request as late.
class _ServiceRequestDueDateRow extends StatelessWidget {
  const _ServiceRequestDueDateRow({required this.date});

  final DateTime date;

  /// Names the day when it is within one day of today, and falls back to an
  /// absolute date otherwise.
  ///
  /// Compared date-only, so a timestamp late in the day still reads as
  /// "Today" rather than rolling to the next label.
  String _label(AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);

    return switch (day.difference(today).inDays) {
      0 => l10n.serviceRequestDateToday,
      -1 => l10n.serviceRequestDateYesterday,
      1 => l10n.serviceRequestDateTomorrow,
      _ => _kAbsoluteDateFormat.format(date),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    return Row(
      children: [
        Iconify(Mdi.calendar_outline, color: colors.textSecondary, size: 14),
        const SizedBox(width: 6),
        Text(
          _label(l10n),
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: colors.textSecondary,
            height: 16 / 12,
          ),
        ),
      ],
    );
  }
}

import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Submitted-request summary: record ID label, copyable badge and confirmation.
///
/// The record id is the one thing the advisor may need to carry out of this
/// screen before the countdown redirects, which is why it is given a copy
/// affordance rather than being rendered as plain text.
class ServiceRequestSuccessDetails extends StatelessWidget {
  /// Creates a [ServiceRequestSuccessDetails].
  const ServiceRequestSuccessDetails({
    required this.recordId,
    required this.onCopy,
    super.key,
  });

  /// Record ID returned by the API for the submitted request.
  final String recordId;

  /// Invoked when the user taps the copy affordance in the badge.
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CaptionText(text: l10n.serviceRequestSuccessRecordLabel),
        const SizedBox(height: 8),
        _RecordIdBadge(recordId: recordId, onCopy: onCopy),
        const SizedBox(height: 8),
        _CaptionText(text: l10n.serviceRequestSuccessConfirmation),
      ],
    );
  }
}

/// Pill showing the record ID with a tap-to-copy button.
///
/// The copy target is a dedicated [InkWell] on the trailing icon rather than
/// the whole pill, so selecting or reading the id cannot fire a copy by
/// accident.
class _RecordIdBadge extends StatelessWidget {
  const _RecordIdBadge({required this.recordId, required this.onCopy});

  /// Record id as returned by the submit endpoint, rendered verbatim.
  final String recordId;

  /// Fired by the trailing copy icon only.
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Iconify(
            Mdi.clipboard_check_outline,
            size: 16,
            color: AppColors.tealAccent,
          ),
          const SizedBox(width: 8),
          Text(
            recordId,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.slate700,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: onCopy,
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Iconify(Mdi.content_copy, size: 16, color: AppColors.tealAccent),
            ),
          ),
        ],
      ),
    );
  }
}

/// Centered secondary caption used above and below the record ID badge.
class _CaptionText extends StatelessWidget {
  const _CaptionText({required this.text});

  /// Already-localised caption copy.
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: context.appColors.textSecondary,
      ),
    );
  }
}

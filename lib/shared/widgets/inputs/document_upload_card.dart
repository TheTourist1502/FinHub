import 'package:finhub/core/config/app_constants.dart';
import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/shared/models/uploaded_document.dart';
import 'package:finhub/shared/widgets/inputs/field_error_text.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// One required-document upload card — dashed upload area + "Browse File"
/// button while under [AppConstants.maxDocumentUploadCount], followed by a
/// separate "Uploaded Documents" section listing every attached file (icon,
/// filename, size, Remove action) once at least one has been picked.
///
/// Shared by the Account Maintenance (Letter of Authorization / Proof of
/// Address) and Online Access service request forms. Purely presentational:
/// [onBrowse] and [onRemove] are wired by the caller to a Notifier method
/// (see `pickDocuments` in `document_picker.dart`) rather than performed
/// here, since the actual file pick must survive this widget being torn
/// down mid-flow (the OS can reclaim the hosting Activity while the native
/// picker is in the foreground).
///
/// The upload area can also be present but unavailable — see [disabledReason],
/// which a form whose cards share one attachment budget uses to say that the
/// allowance is already spent.
class DocumentUploadCard extends StatelessWidget {
  /// Creates a [DocumentUploadCard].
  const DocumentUploadCard({
    required this.title,
    required this.hint,
    required this.documents,
    required this.onBrowse,
    required this.onRemove,
    this.required = true,
    this.errorText,
    this.disabledReason,
    super.key,
  });

  /// Whether the card's [title] carries the red `*`.
  ///
  /// Defaults to `true` because every form using this card so far demands its
  /// attachments. Account Maintenance passes `false` while nothing on the
  /// request obliges an upload — a `*` on an attachment the advisor may
  /// legitimately skip reads as a blocked submit that never comes.
  final bool required;

  /// Validation message shown under the card, or `null` when there is nothing
  /// to report.
  ///
  /// The title already carries a `*`, but on a form that only validates once
  /// Submit is tapped that marker is the *only* signal a missing attachment
  /// gives — without this the advisor gets a rejected submit and no visible
  /// cause anywhere on screen.
  final String? errorText;

  /// Why no further file may be attached right now, or `null` while uploading
  /// is available.
  ///
  /// Non-null greys out "Browse File" and takes the place of [hint], so the
  /// card states its own unavailability rather than opening a picker that
  /// would reject every pick. Used by a form whose attachment budget is shared
  /// across several cards (Account Maintenance), where filling one card can
  /// spend the whole request's allowance and leave the other with none.
  ///
  /// Independent of [errorText]: this explains the card's *current* state and
  /// shows immediately, while the error only appears once Submit has been
  /// tapped. A required card whose slots the other one took shows both.
  final String? disabledReason;

  /// e.g. "Letter of Authorization".
  final String title;

  /// e.g. "Allowed Format: PDF". Replaced by [disabledReason] while uploading
  /// is unavailable.
  final String hint;

  /// Every document attached so far, up to [AppConstants.maxDocumentUploadCount].
  final List<UploadedDocument> documents;

  /// Triggers picking one or more new documents. Fire-and-forget from this
  /// widget's perspective — the caller's Notifier method owns the pick,
  /// validates it, and appends to state directly.
  final VoidCallback onBrowse;

  /// Removes the given document from [documents].
  final ValueChanged<UploadedDocument> onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final canAddMore = documents.length < AppConstants.maxDocumentUploadCount;
    final uploadDisabled = disabledReason != null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: colors.textPrimary,
              ),
              children: [
                TextSpan(text: required ? '$title ' : title),
                if (required)
                  TextSpan(
                    text: '*',
                    style: TextStyle(color: colors.statusErrorDefault),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd - 4),
          if (canAddMore) ...[
            CustomPaint(
              foregroundPainter: _DashedRRectPainter(
                color: colors.uploadBorder,
                radius: AppDimensions.borderRadiousSm,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.spaceMd),
                decoration: BoxDecoration(
                  color: colors.surfaceFilled,
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiousSm),
                ),
                child: Center(
                  child: OutlinedButton.icon(
                    onPressed: uploadDisabled ? null : onBrowse,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: uploadDisabled ? colors.interactiveDisabled : colors.borderDefault),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      minimumSize: const Size(0, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiousSm),
                      ),
                    ),
                    icon: Iconify(
                      Mdi.folder_open_outline,
                      size: 16,
                      color: uploadDisabled ? colors.iconDisabled : colors.textBrandNavyBlue,
                    ),
                    label: Text(
                      l10n.commonBrowseFile,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: uploadDisabled ? colors.textDisabled : colors.textBrandNavyBlue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            Text(
              // While uploading is unavailable the format hint is moot — the
              // reason it is unavailable is what the advisor needs instead.
              disabledReason ?? hint,
              style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: colors.textSecondary),
            ),
          ],
          if (documents.isNotEmpty) ...[
            SizedBox(height: canAddMore ? AppDimensions.spaceMd : 0),
            Text(
              l10n.commonUploadedDocumentsTitle,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceSm),
            Column(
              children: [
                for (final attached in documents) ...[
                  _UploadedDocumentTile(document: attached, onRemove: () => onRemove(attached)),
                  if (attached != documents.last) const SizedBox(height: AppDimensions.spaceSm),
                ],
              ],
            ),
          ],
          if (errorText case final error?) FieldErrorText(message: error),
        ],
      ),
    );
  }
}

/// One row in the "Uploaded Documents" section: file-type icon, filename,
/// formatted size, and a Remove action.
class _UploadedDocumentTile extends StatelessWidget {
  const _UploadedDocumentTile({required this.document, required this.onRemove});

  final UploadedDocument document;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceFilled,
        border: Border.all(color: colors.borderDefault),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiousSm),
      ),
      child: Row(
        children: [
          Iconify(_iconForExtension(document.extension), size: 28, color: colors.iconSecondary),
          const SizedBox(width: AppDimensions.spaceSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.fileName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  document.formattedSize,
                  style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: colors.textSecondary),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            tooltip: l10n.commonRemove,
            icon: Iconify(Mdi.trash_can_outline, size: 20, color: colors.statusErrorDefault),
          ),
        ],
      ),
    );
  }
}

/// Maps a lowercase, no-dot file [extension] to a representative mdi icon.
String _iconForExtension(String extension) => switch (extension) {
  'pdf' => Mdi.file_pdf_box,
  'jpg' || 'jpeg' || 'png' => Mdi.file_image_box,
  'doc' || 'docx' => Mdi.file_word_box,
  'xls' || 'xlsx' => Mdi.file_excel_box,
  _ => Mdi.file_outline,
};

/// Paints a dashed rounded-rectangle border around its child, used for the
/// upload drop zone since [BoxDecoration] has no dashed [BorderStyle].
class _DashedRRectPainter extends CustomPainter {
  /// Creates a [_DashedRRectPainter].
  const _DashedRRectPainter({required this.color, required this.radius});

  /// Dash stroke colour.
  final Color color;

  /// Corner radius, matching the underlying [BoxDecoration]'s radius.
  final double radius;

  static const _strokeWidth = 1.0;
  static const _dashWidth = 6.0;
  static const _dashGap = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        _strokeWidth / 2,
        _strokeWidth / 2,
        size.width - _strokeWidth,
        size.height - _strokeWidth,
      ),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + _dashWidth;
        canvas.drawPath(metric.extractPath(distance, next.clamp(0, metric.length)), paint);
        distance = next + _dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) =>
      color != oldDelegate.color || radius != oldDelegate.radius;
}

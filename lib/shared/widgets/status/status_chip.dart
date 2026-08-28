import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Background/foreground pair a chip paints itself with.
///
/// Kept as a private record rather than exposing raw colours, so every chip in
/// the app draws from the same semantic palettes and none can drift.
typedef _ChipPalette = ({Color background, Color foreground});

/// Glyph for any status value the API sends that this file does not know — a
/// question mark rather than a wrong-but-plausible icon.
const String kStatusFallbackIcon = Mdi.help_circle_outline;

/// MDI glyph for every status and workflow-stage label the API sends, keyed by
/// its normalised form.
///
/// One table rather than a per-enum getter: the icon is the only thing a
/// workflow stage still drives, so a stage needs no enum member of its own —
/// adding a row here is the whole job.
const Map<String, String> _kIconByLabel = {
  // Overall request/task statuses.
  'approved': Mdi.check_decagram,
  'escalated': Mdi.arrow_up_bold_circle_outline,
  'rejected': Mdi.close_circle_outline,
  'completed': Mdi.check_circle_outline,
  'in progress': Mdi.progress_clock,

  // Workflow stages.
  'pending ops review': Mdi.clipboard_clock_outline,
  'pending principal review': Mdi.account_tie,
  'pending aml review': Mdi.shield_search,
  'nao in progress': Mdi.progress_clock,
  'ready to send to custodian': Mdi.bank_transfer_out,
  'open': Mdi.folder_open_outline,
  'closed': Mdi.progress_check,
  'on hold': Mdi.pause_circle_outline,
  'pending compliance review': Mdi.shield_check_outline,
  'delegated to fa': Mdi.account_arrow_right_outline,
  'pending aml manager review': Mdi.shield_account_outline,
  'pending business escalations review': Mdi.alert_octagon_outline,
  'pending fa review': Mdi.account_clock_outline,
};

/// Resolves the glyph for a raw API status or workflow-stage [label].
///
/// Matching is done on the normalised label, so every spelling the API mixes
/// ("In-progress" / "In progress", "--None--" / "") lands on the same icon.
/// Unknown labels — and `--None--`, which names no stage — return [fallback],
/// letting a caller that has a better icon of its own supply it.
String getIconByLabel(String? label, {String fallback = kStatusFallbackIcon}) =>
    _kIconByLabel[_normalise(label)] ?? fallback;

/// The overall status of a service request or task, as sent by the API.
///
/// The API ships status as free text, so [fromRaw] normalises before matching
/// and anything unrecognised resolves to `null` — the chip then renders the raw
/// text on the info palette rather than mis-colouring it.
enum RequestStatus {
  /// `--None--` — no status set yet.
  none,

  /// `Approved` — signed off, awaiting downstream processing.
  approved,

  /// `Escalated` — raised to a higher review tier.
  escalated,

  /// `Rejected` — declined; terminal.
  rejected,

  /// `Completed` — fully processed; terminal.
  completed,

  /// `In-progress` — actively moving through the workflow.
  inProgress;

  /// Resolves [raw] API text to a [RequestStatus], or `null` when unrecognised.
  ///
  /// Case-insensitive, and tolerant of the hyphen/space and surrounding-dash
  /// variants the API mixes ("In-progress", "In progress", "--None--").
  static RequestStatus? fromRaw(String? raw) => switch (_normalise(raw)) {
    '' || 'none' => RequestStatus.none,
    'approved' => RequestStatus.approved,
    'escalated' => RequestStatus.escalated,
    'rejected' => RequestStatus.rejected,
    'completed' => RequestStatus.completed,
    'in progress' => RequestStatus.inProgress,
    _ => null,
  };

  /// Localised display label.
  String label(AppLocalizations l10n) => switch (this) {
    RequestStatus.none => l10n.statusNone,
    RequestStatus.approved => l10n.statusApproved,
    RequestStatus.escalated => l10n.statusEscalated,
    RequestStatus.rejected => l10n.statusRejected,
    RequestStatus.completed => l10n.statusCompleted,
    RequestStatus.inProgress => l10n.statusInProgress,
  };

  /// Semantic colour pair for this status.
  ///
  /// Only the five statuses that carry real meaning are colour-coded; `none`
  /// falls through to the info palette alongside anything the API sends that
  /// this enum does not cover.
  _ChipPalette _palette(AppColorTokens c) => switch (this) {
    RequestStatus.approved || RequestStatus.completed => (
      background: c.statusSuccessBg,
      foreground: c.statusSuccessText,
    ),
    RequestStatus.escalated => (background: c.statusWarningBg, foreground: c.statusWarningText),
    RequestStatus.rejected => (background: c.statusErrorBg, foreground: c.statusErrorText),
    RequestStatus.none || RequestStatus.inProgress => _statusInfoPalette(c),
  };
}

/// The info-toned pair used for every status this file does not colour-code,
/// and by the per-feature workflow chips and avatars.
_ChipPalette _statusInfoPalette(AppColorTokens c) => (background: c.statusInfoBg, foreground: c.statusInfoText);

/// Lowercases [raw], strips the API's `--…--` wrapper, folds hyphens and
/// underscores to spaces, and collapses runs of whitespace.
///
/// Lets one lookup match every spelling the API uses for a value
/// ("In-progress" / "In progress", "--None--" / "None" / "").
String _normalise(String? raw) => (raw ?? '')
    .toLowerCase()
    .replaceAll(RegExp(r'^-+|-+$'), '')
    .replaceAll(RegExp('[-_]+'), ' ')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();

/// Rounded pill showing a request/task's overall status with a leading icon.
///
/// Takes the raw API string rather than a [RequestStatus] so callers never have
/// to parse: recognised values get a localised label, an icon and a semantic
/// palette; anything else degrades to the raw text on the info palette with the
/// fallback glyph. The dense, uppercase treatment is the only one — the chip
/// only ever appears inside a list card or a detail row.
class StatusChip extends StatelessWidget {
  /// Creates a [StatusChip] for the raw API [status] text.
  const StatusChip({required this.status, super.key});

  /// Raw status text from the API (e.g. "In-progress", "--None--").
  final String? status;

  @override
  Widget build(BuildContext context) {
    final parsed = RequestStatus.fromRaw(status);
    final colors = context.appColors;
    final palette = parsed?._palette(colors) ?? _statusInfoPalette(colors);
    // Recognised statuses are localised; anything else shows the API's own
    // wording rather than nothing at all.
    final label = parsed?.label(context.l10n) ?? (status ?? '').trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: palette.background, borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Iconify(getIconByLabel(status), color: palette.foreground, size: 12),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label.isEmpty ? '—' : label.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                height: 15 / 10,
                color: palette.foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

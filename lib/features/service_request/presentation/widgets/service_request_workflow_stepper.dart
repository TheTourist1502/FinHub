import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Visual state of one node on the [ServiceRequestWorkflowStepper].
enum ServiceRequestStepState {
  /// Stage worked and signed off — filled navy dot with a check.
  completed,

  /// Stage the request is sitting at right now — navy ring with an inner dot.
  current,

  /// Stage not reached yet — hollow gray ring.
  upcoming,
}

/// One row of the workflow stepper.
///
/// A pre-rendered view model, not a domain type: labels and dates arrive
/// already localised and formatted, so the stepper stays pure presentation and
/// callers can synthesise steps the task trail does not contain (e.g.
/// "Submitted").
@immutable
class ServiceRequestStep {
  /// Creates a [ServiceRequestStep].
  const ServiceRequestStep({
    required this.label,
    required this.state,
    this.subtitle,
    this.details = const [],
    this.comments,
  });

  /// Stage name (e.g. "Submitted", "Pending Ops Review").
  final String label;

  /// Secondary line under the label — normally the stage's date.
  final String? subtitle;

  /// Labelled attributes of the stage (owner, assignee, due date), rendered one
  /// per line with the label emphasised over its value.
  final List<ServiceRequestStepDetailEntry> details;

  /// Reviewer's comment, rendered last and clamped to two lines.
  final ServiceRequestStepComment? comments;

  /// Which marker to draw for this step.
  final ServiceRequestStepState state;
}

/// One `Label: value` line under a stage.
///
/// Pre-rendered like [ServiceRequestStep]: both halves arrive localised and
/// formatted, the stepper only decides how they are weighted.
@immutable
class ServiceRequestStepDetailEntry {
  /// Creates a [ServiceRequestStepDetailEntry].
  const ServiceRequestStepDetailEntry({required this.label, required this.value});

  /// Localised attribute name (e.g. "Owner").
  final String label;

  /// The attribute's value.
  final String value;
}

/// A stage's comment plus the strings the clamped presentation needs.
///
/// The "view more" affordance only appears when the text actually overflows two
/// lines, which the stepper measures — the caller just supplies the labels.
@immutable
class ServiceRequestStepComment {
  /// Creates a [ServiceRequestStepComment].
  const ServiceRequestStepComment({
    required this.label,
    required this.text,
    required this.viewMoreLabel,
    required this.closeLabel,
  });

  /// Localised "Comments" label shown before the text.
  final String label;

  /// The comment body.
  final String text;

  /// Localised link label revealing the untruncated comment.
  final String viewMoreLabel;

  /// Localised dismiss label for the full-comment dialog.
  final String closeLabel;
}

/// Diameter of a step's circular marker. The connecting rail is centred on
/// this, so the two share one constant.
const double _kMarkerSize = 20;

/// Thickness of the rail joining one marker to the next.
const double _kRailWidth = 2;

/// Vertical timeline of a service request's workflow stages.
///
/// Pure presentation: the caller builds the [steps] from the request's task
/// audit trail.
///
/// The rail is one unbroken line behind the stages — as in the design, where
/// it is a single left border on the stage list rather than a segment per
/// stage. It runs down the markers' centre and each marker paints over it with
/// its own opaque fill.
///
/// Only the stages *above* the last one sit on the rail, so the line stops at
/// the final marker instead of trailing past it into that stage's text. A
/// single-stage timeline therefore draws no rail at all.
class ServiceRequestWorkflowStepper extends StatelessWidget {
  /// Creates a [ServiceRequestWorkflowStepper].
  const ServiceRequestWorkflowStepper({required this.steps, super.key});

  /// Stages to render, oldest first.
  final List<ServiceRequestStep> steps;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final lastIndex = steps.length - 1;

    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Railed section — the rail is sized by the stages stacked on top of
          // it, so `top`/`bottom` stretch it to their combined height without
          // anything having to be measured as stages are added.
          Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: (_kMarkerSize - _kRailWidth) / 2,
                width: _kRailWidth,
                child: ColoredBox(color: colors.bgBrandNavyBlue),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < lastIndex; i++) _StepRow(step: steps[i], isLast: false),
                ],
              ),
            ],
          ),
          if (lastIndex >= 0) _StepRow(step: steps[lastIndex], isLast: true),
        ],
      ),
    );
  }
}

/// A single stage: the marker in a fixed-width gutter, with the text block
/// beside it.
///
/// Draws no rail of its own — the stepper paints one continuous line behind
/// every row, which this row's marker covers where the two overlap.
class _StepRow extends StatelessWidget {
  const _StepRow({required this.step, required this.isLast});

  /// Stage to render — its state picks the marker and the text weight/colour.
  final ServiceRequestStep step;

  /// The final stage carries no gap beneath it, so the rail stops with it.
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isCurrent = step.state == ServiceRequestStepState.current;
    final isUpcoming = step.state == ServiceRequestStepState.upcoming;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: _kMarkerSize,
          child: _StepMarker(state: step.state),
        ),
        const SizedBox(width: AppDimensions.spaceMd),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppDimensions.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                    height: 20 / 14,
                    color: isUpcoming ? colors.textTertiary : colors.textPrimary,
                  ),
                ),
                if (step.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    step.subtitle!,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 16 / 12,
                      color: colors.textTertiary,
                    ),
                  ),
                ],
                if (step.details.isNotEmpty || step.comments != null) ...[
                  const SizedBox(height: 4),
                  for (final entry in step.details) _StepDetailLine(entry: entry),
                  if (step.comments != null) _StepCommentLine(comment: step.comments!),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Metrics shared by every detail line; the label and value differ only in
/// weight and colour, so they stay on one baseline.
TextStyle _detailStyle(BuildContext context) =>
    const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w400, height: 18 / 12);

/// Style for a detail line's label — heavier and dimmer than its value.
TextStyle _detailLabelStyle(BuildContext context) =>
    _detailStyle(context).copyWith(fontWeight: FontWeight.w500, color: context.appColors.textSecondary);

/// Style for a detail line's value.
TextStyle _detailValueStyle(BuildContext context) =>
    _detailStyle(context).copyWith(color: context.appColors.textPrimary);

/// A `Label: value` line, the label carried at w500/`textSecondary` against a
/// w400/`textPrimary` value.
class _StepDetailLine extends StatelessWidget {
  const _StepDetailLine({required this.entry});

  /// Attribute to render.
  final ServiceRequestStepDetailEntry entry;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '${entry.label}: ', style: _detailLabelStyle(context)),
          TextSpan(text: entry.value, style: _detailValueStyle(context)),
        ],
      ),
    );
  }
}

/// The comment line, clamped to two lines with a "view more" link sitting
/// inline at the end of the second line.
///
/// The link has to share the last line with the text, so the clamp cannot be
/// left to [TextOverflow.ellipsis] — that would cut the line before the link
/// and push it onto a third. Instead the comment is measured with a
/// [TextPainter] at the row's real width, and when it overruns two lines a
/// binary search finds the longest prefix that still leaves room for
/// "… View more" on the second line.
///
/// Stateful only to own the [TapGestureRecognizer]'s lifecycle — an inline
/// [TextSpan] cannot be wrapped in a [GestureDetector], and a recognizer must
/// be disposed with the widget.
class _StepCommentLine extends StatefulWidget {
  const _StepCommentLine({required this.comment});

  /// Comment to render.
  final ServiceRequestStepComment comment;

  @override
  State<_StepCommentLine> createState() => _StepCommentLineState();
}

class _StepCommentLineState extends State<_StepCommentLine> {
  /// Lines shown before the text is cut off.
  static const int _maxLines = 2;

  /// Marks the cut and separates the text from the link.
  static const String _kEllipsis = '… ';

  late final TapGestureRecognizer _viewMoreTap;

  @override
  void initState() {
    super.initState();
    _viewMoreTap = TapGestureRecognizer()..onTap = _showFullComment;
  }

  @override
  void dispose() {
    _viewMoreTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;
    final labelStyle = _detailLabelStyle(context);
    final valueStyle = _detailValueStyle(context);
    final linkStyle = _detailStyle(context).copyWith(
      fontWeight: FontWeight.w500,
      color: context.appColors.textBrandNavyBlue,
      decoration: TextDecoration.underline,
      decorationColor: context.appColors.textBrandNavyBlue,
    );

    /// Builds the rendered span for [body], optionally trailed by the link.
    TextSpan spanFor(String body, {required bool withLink}) => TextSpan(
      children: [
        TextSpan(text: '${comment.label}: ', style: labelStyle),
        TextSpan(text: body, style: valueStyle),
        if (withLink) TextSpan(text: comment.viewMoreLabel, style: linkStyle, recognizer: _viewMoreTap),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final textDirection = Directionality.of(context);
        final textScaler = MediaQuery.textScalerOf(context);

        /// Whether [span] renders within [_maxLines] at the row's width.
        bool fits(TextSpan span) {
          final painter = TextPainter(
            text: span,
            maxLines: _maxLines,
            textDirection: textDirection,
            textScaler: textScaler,
          )..layout(maxWidth: constraints.maxWidth);
          final result = !painter.didExceedMaxLines;
          painter.dispose();
          return result;
        }

        if (fits(spanFor(comment.text, withLink: false))) {
          return Text.rich(spanFor(comment.text, withLink: false));
        }

        // Longest prefix that still fits once the ellipsis and link are added.
        var low = 0;
        var high = comment.text.length;
        while (low < high) {
          final mid = (low + high + 1) ~/ 2;
          if (fits(spanFor(_clip(comment.text, mid), withLink: true))) {
            low = mid;
          } else {
            high = mid - 1;
          }
        }

        return Text.rich(spanFor(_clip(comment.text, low), withLink: true), maxLines: _maxLines);
      },
    );
  }

  /// First [length] characters of [text], closed with the ellipsis separator.
  String _clip(String text, int length) => '${text.substring(0, length).trimRight()}$_kEllipsis';

  /// Opens the untruncated comment in a scrollable dialog.
  Future<void> _showFullComment() {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(widget.comment.label),
        content: SingleChildScrollView(
          child: Text(widget.comment.text, style: _detailValueStyle(dialogContext)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(widget.comment.closeLabel)),
        ],
      ),
    );
  }
}

/// [_kMarkerSize] circular marker whose fill encodes the step's
/// [ServiceRequestStepState].
///
/// Every variant is fully opaque — the marker is what hides the continuous
/// rail painted behind it, so a translucent fill would let the line show
/// through the dot.
class _StepMarker extends StatelessWidget {
  const _StepMarker({required this.state});

  /// Stage state this marker depicts.
  final ServiceRequestStepState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return switch (state) {
      ServiceRequestStepState.completed => Container(
        width: _kMarkerSize,
        height: _kMarkerSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: colors.bgBrandNavyBlue, shape: BoxShape.circle),
        child: const Iconify(Mdi.check, color: Colors.white, size: 12),
      ),
      ServiceRequestStepState.current => Container(
        width: _kMarkerSize,
        height: _kMarkerSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surfaceDefault,
          shape: BoxShape.circle,
          border: Border.all(color: colors.bgBrandNavyBlue, width: 2),
        ),
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: colors.bgBrandNavyBlue, shape: BoxShape.circle),
        ),
      ),
      ServiceRequestStepState.upcoming => Container(
        width: _kMarkerSize,
        height: _kMarkerSize,
        decoration: BoxDecoration(
          color: colors.surfaceDefault,
          shape: BoxShape.circle,
          border: Border.all(color: colors.borderDefault, width: 2),
        ),
      ),
    };
  }
}

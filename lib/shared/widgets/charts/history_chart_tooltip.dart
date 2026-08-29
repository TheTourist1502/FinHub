import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// The tooltip bubble shown above a [HistoryChartCanvas][] when a point is
/// touched.
///
/// [HistoryChartCanvas]: package:finhub/shared/widgets/charts/history_chart_canvas.dart
///
/// Rendered outside the chart's own canvas (via a `Positioned` + `Clip.none`
/// usage in the caller), so it never competes for space with — or gets
/// clipped by — the line and dots it describes. Capped at 250 px wide with
/// the height sized to its (single, unbroken) sentence of content, and
/// finished with a small triangle pointer so it reads as a speech bubble
/// anchored to the chart below it.
class HistoryChartTouchTooltip extends StatelessWidget {
  /// Creates a [HistoryChartTouchTooltip].
  const HistoryChartTouchTooltip({
    required this.text,
    required this.colors,
    required this.width,
    required this.triangleOffset,
    super.key,
  });

  final String text;
  final AppColorTokens colors;

  /// Fixed width of the bubble, in logical pixels (capped at 175 by the
  /// caller).
  final double width;

  /// Horizontal offset, within [width], where the triangle pointer's tip
  /// should land — tracks the touched data point even when the bubble
  /// itself has been shifted to stay clear of the chart's edges.
  final double triangleOffset;

  static const double _triangleWidth = 12;
  static const double _triangleHeight = 6;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surfaceDefault,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.borderDefault),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: colors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
        // Overlaps the bubble's bottom border by 1px so the triangle's fill
        // paints over that seam, reading as one continuous outline instead
        // of two separately bordered shapes.
        Transform.translate(
          offset: const Offset(0, -1),
          child: Padding(
            padding: EdgeInsets.only(left: triangleOffset - _triangleWidth / 2),
            child: CustomPaint(
              size: const Size(_triangleWidth, _triangleHeight),
              painter: _TooltipTrianglePainter(
                fillColor: colors.surfaceDefault,
                borderColor: colors.borderDefault,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Draws the small downward-pointing triangle beneath [HistoryChartTouchTooltip]'s
/// bubble, so the tooltip reads as a speech bubble pointing at the touched
/// data point.
///
/// Only the two slanted sides are stroked — the base is left open so the
/// triangle merges seamlessly with the bubble's border above it instead of
/// reading as a second, separately outlined shape.
class _TooltipTrianglePainter extends CustomPainter {
  const _TooltipTrianglePainter({required this.fillColor, required this.borderColor});

  final Color fillColor;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final fillPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(fillPath, Paint()..color = fillColor);

    final sidesPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0);
    canvas.drawPath(
      sidesPath,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_TooltipTrianglePainter oldDelegate) =>
      fillColor != oldDelegate.fillColor || borderColor != oldDelegate.borderColor;
}

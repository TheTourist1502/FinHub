import 'dart:async';
import 'dart:math' as math;

import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Fraction of the timeline the ring sweep owns.
const Interval _kRingInterval = Interval(0, 0.55, curve: Curves.easeInOut);

/// Fraction of the timeline the checkmark draw owns. Deliberately overlaps
/// [_kRingInterval] so the check starts before the ring has fully closed.
const Interval _kCheckInterval = Interval(0.50, 0.85, curve: Curves.easeOut);

/// Fraction of the timeline the closing elastic overshoot owns.
const Interval _kPopInterval = Interval(0.80, 1);

/// Animated circular checkbox indicator.
///
/// Plays a three-phase sequence when [value] turns `true`:
/// 1. the ring sweeps clockwise from 12 o'clock, wiping in the gradient fill
///    behind it,
/// 2. the checkmark draws itself along its own stroke,
/// 3. the whole glyph pops with a short elastic overshoot.
///
/// Turning [value] back to `false` runs the identical sequence in reverse, so
/// unchecking reads as the inverse of checking rather than a separate
/// animation.
///
/// Purely presentational — it renders [value] and nothing else. Tap handling
/// and semantics belong to the row that hosts it, so the whole label is
/// tappable rather than just the 22px glyph.
class AnimatedCheckCircle extends StatefulWidget {
  /// Creates an [AnimatedCheckCircle].
  const AnimatedCheckCircle({
    required this.value,
    super.key,
    this.playOnMount = false,
    this.size = 22,
    this.strokeWidth = 2,
    this.duration = const Duration(milliseconds: 700),
    this.gradientStart,
    this.gradientEnd,
    this.checkColor,
    this.trackColor,
  });

  /// Whether the box is checked. Changing it drives the animation.
  final bool value;

  /// Whether to play the sequence on first mount when [value] is already
  /// `true`.
  ///
  /// Off by default so a checkbox that mounts checked simply renders checked
  /// rather than animating unprompted. A success screen turns it on, because
  /// there the animation is the reason the widget is on screen at all.
  final bool playOnMount;

  /// Outer diameter of the glyph.
  final double size;

  /// Width of both the ring and the checkmark stroke.
  final double strokeWidth;

  /// How long a full check (or uncheck) takes.
  final Duration duration;

  /// Gradient stop at the top-left of the fill. Defaults to
  /// `bgBrandNavyBlue`.
  final Color? gradientStart;

  /// Gradient stop at the bottom-right of the fill. Defaults to a midpoint
  /// between `bgBrandNavyBlue` and `bgPrimary` — running the gradient all the
  /// way to `bgPrimary` would leave the light half indistinguishable from the
  /// page behind it and swallow the checkmark drawn on top.
  final Color? gradientEnd;

  /// Colour of the checkmark drawn over the fill. Defaults to `bgPrimary`.
  final Color? checkColor;

  /// Colour of the always-present outline, so an unchecked box still reads as
  /// one. Defaults to `borderDefault`.
  final Color? trackColor;

  @override
  State<AnimatedCheckCircle> createState() => _AnimatedCheckCircleState();
}

class _AnimatedCheckCircleState extends State<AnimatedCheckCircle> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _ring;
  late final Animation<double> _check;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    // Seeded at the current value so a box that is already checked when it
    // mounts renders complete instead of animating in unprompted — unless
    // [AnimatedCheckCircle.playOnMount] asked for exactly that.
    final startsComplete = widget.value && !widget.playOnMount;
    _controller = AnimationController(vsync: this, duration: widget.duration, value: startsComplete ? 1 : 0);
    _ring = CurvedAnimation(parent: _controller, curve: _kRingInterval);
    _check = CurvedAnimation(parent: _controller, curve: _kCheckInterval);
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1.08), weight: 40),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.08, end: 1).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: _kPopInterval));

    if (widget.value && widget.playOnMount) unawaited(_controller.forward());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Under "reduce motion" the controller is pinned at the value it would
    // have finished on, so the mark renders complete without a second code
    // path through the build method.
    if (!AppMotion.enabled(context)) _controller.value = widget.value ? 1 : 0;
  }

  @override
  void didUpdateWidget(covariant AnimatedCheckCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value == widget.value) return;
    if (!AppMotion.enabled(context)) {
      _controller.value = widget.value ? 1 : 0;
      return;
    }
    unawaited(widget.value ? _controller.forward() : _controller.reverse());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final start = widget.gradientStart ?? colors.bgBrandNavyBlue;
    final end = widget.gradientEnd ?? Color.lerp(colors.bgBrandNavyBlue, colors.bgPrimary, 0.5)!;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Transform.scale(
        scale: _scale.value,
        child: CustomPaint(
          size: Size.square(widget.size),
          painter: _CheckCirclePainter(
            ringProgress: _ring.value,
            checkProgress: _check.value,
            gradientStart: start,
            gradientEnd: end,
            checkColor: widget.checkColor ?? colors.bgPrimary,
            trackColor: widget.trackColor ?? colors.borderDefault,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );
  }
}

/// Paints one frame of [AnimatedCheckCircle]: the empty track, the swept
/// gradient fill and ring, then the partially drawn checkmark.
class _CheckCirclePainter extends CustomPainter {
  /// Creates a [_CheckCirclePainter].
  const _CheckCirclePainter({
    required this.ringProgress,
    required this.checkProgress,
    required this.gradientStart,
    required this.gradientEnd,
    required this.checkColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  /// How much of the ring (and the fill behind it) has swept in, `0..1`.
  final double ringProgress;

  /// How much of the checkmark has been drawn, `0..1`.
  final double checkProgress;

  final Color gradientStart;
  final Color gradientEnd;
  final Color checkColor;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final bounds = Rect.fromCircle(center: center, radius: radius);
    // 12 o'clock — the sweep's origin for both the fill and the ring.
    const startAngle = -math.pi / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    if (ringProgress <= 0) return;
    final sweep = 2 * math.pi * ringProgress;

    canvas
      // Filled sector, wiped in clockwise like a clock hand.
      ..drawArc(
        bounds,
        startAngle,
        sweep,
        true,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [gradientStart, gradientEnd],
          ).createShader(bounds),
      )
      // Ring, over the fill's outer edge so the silhouette stays crisp.
      ..drawArc(
        bounds,
        startAngle,
        sweep,
        false,
        Paint()
          ..color = gradientStart
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );

    if (checkProgress <= 0) return;

    // Proportional so the glyph holds its shape at any [size].
    final check = Path()
      ..moveTo(size.width * 0.28, size.height * 0.53)
      ..lineTo(size.width * 0.44, size.height * 0.68)
      ..lineTo(size.width * 0.72, size.height * 0.36);

    final checkPaint = Paint()
      ..color = checkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Extracting a prefix of the path is what makes the stroke appear to draw
    // itself rather than fade in whole.
    for (final metric in check.computeMetrics()) {
      canvas.drawPath(metric.extractPath(0, metric.length * checkProgress), checkPaint);
    }
  }

  @override
  bool shouldRepaint(_CheckCirclePainter old) =>
      old.ringProgress != ringProgress ||
      old.checkProgress != checkProgress ||
      old.gradientStart != gradientStart ||
      old.gradientEnd != gradientEnd ||
      old.checkColor != checkColor ||
      old.trackColor != trackColor ||
      old.strokeWidth != strokeWidth;
}

import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/shared/widgets/inputs/animated_check_circle.dart';
import 'package:flutter/material.dart';

/// Animated success mark: a blurred glow, a frosted ring and a check circle.
///
/// The two outer layers are driven by the caller's controller so they land
/// together with the rest of the screen's entrance animation.
class ServiceRequestSuccessIcon extends StatelessWidget {
  /// Creates a [ServiceRequestSuccessIcon].
  const ServiceRequestSuccessIcon({
    required this.controller,
    required this.scale,
    required this.fade,
    super.key,
  });

  /// Drives the repaint of the glow and ring layers.
  final Listenable controller;

  /// Elastic 0→1 scale applied to the glow and ring layers.
  final Animation<double> scale;

  /// Ease-in 0→1 opacity applied to the glow and ring layers.
  final Animation<double> fade;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Stack(
      alignment: Alignment.center,
      children: [
        _FadeScaleLayer(
          controller: controller,
          scale: scale,
          fade: fade,
          baseScale: 0.8,
          scaleRange: 0.2,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
              boxShadow: [
                BoxShadow(
                  color: colors.statusSuccessDefault.withValues(alpha: 0.1),
                  blurRadius: 32,
                  spreadRadius: 12,
                ),
              ],
            ),
          ),
        ),
        _FadeScaleLayer(
          controller: controller,
          scale: scale,
          fade: fade,
          baseScale: 0.85,
          scaleRange: 0.15,
          child: Container(
            width: 144,
            height: 144,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.8),
                    Colors.white.withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Deliberately outside the shared controller: AnimatedCheckCircle owns
        // its own sweep → draw → pop timeline and would bounce twice.
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colors.statusSuccessDefault.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: AnimatedCheckCircle(
            value: true,
            playOnMount: true,
            size: 128,
            strokeWidth: 6,
            duration: AppMotion.hero,
            gradientStart: colors.statusSuccessDefault,
            gradientEnd: colors.statusSuccessDefault.withValues(alpha: 0.7),
            checkColor: Colors.white,
            // No fallback outline: the glyph sweeps in from nothing instead of
            // filling a grey ring that was already on screen.
            trackColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}

/// Fades and scales [child] from the shared entrance animation.
///
/// Each layer starts at its own [baseScale] so the ring trails the glow.
class _FadeScaleLayer extends StatelessWidget {
  const _FadeScaleLayer({
    required this.controller,
    required this.scale,
    required this.fade,
    required this.baseScale,
    required this.scaleRange,
    required this.child,
  });

  /// Repaint trigger for the [AnimatedBuilder]; the values come from [scale]
  /// and [fade], which are driven by this same controller.
  final Listenable controller;

  /// Elastic 0→1 progress, mapped into [baseScale]…[baseScale] + [scaleRange].
  final Animation<double> scale;

  /// Ease-in 0→1 opacity applied directly.
  final Animation<double> fade;

  /// Scale at rest — under 1 so the layer grows into place.
  final double baseScale;

  /// How much [scale] adds on top of [baseScale] at full progress. Varying this
  /// per layer is what makes the ring trail the glow off one shared animation.
  final double scaleRange;

  /// Layer being animated; passed through [AnimatedBuilder]'s `child` so it is
  /// built once rather than on every tick.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Opacity(
        opacity: fade.value,
        child: Transform.scale(
          scale: baseScale + (scale.value * scaleRange),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

import 'dart:async';

import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/shared/animations/animations.dart';
import 'package:finhub/shared/animations/on_scrolled_into_view.dart';
import 'package:flutter/material.dart';

/// Which of the RedStar template's four slide sequences to play.
///
/// The names follow the source keyframes in `animation.txt`, not the direction
/// of travel: `slideLeft` moves leftward, so it *enters from the right*, and
/// `slideUp` moves upward, so it *enters from below*. Each value carries that
/// sequence's offsets as fractions of the child's own width or height, matching
/// CSS percentage translate.
enum SlideDirection {
  /// The `slideLeft` sequence: in from the right, overshooting left.
  left(Axis.horizontal, [1.5, -0.08, 0.04, -0.04, 0.02, 0]),

  /// The `slideRight` sequence: in from the left, overshooting right.
  right(Axis.horizontal, [-1.5, 0.08, -0.04, 0.04, -0.02, 0]),

  /// The `slideUp` sequence: in from below, overshooting upward. The source
  /// starts it one full height away rather than the 1.5 the horizontal
  /// sequences use, so a row rising into a stacked column travels its own
  /// height and no further.
  up(Axis.vertical, [1, -0.08, 0.04, -0.04, 0.02, 0]),

  /// The `slideDown` sequence: in from above, overshooting downward.
  down(Axis.vertical, [-1, 0.08, -0.04, 0.04, -0.02, 0]);

  const SlideDirection(this.axis, this.stops);

  /// The axis the child travels along.
  final Axis axis;

  /// Offset at each of the source's keyframe stops, along [axis].
  final List<double> stops;

  /// Whether the overshoot swings left of — or above — the resting position.
  /// Decides which edge [SlideInClip] leaves headroom on.
  bool get overshootsBefore => stops[1] < 0;

  /// [value] as a translation along this direction's axis.
  Offset offset(double value) => axis == Axis.horizontal ? Offset(value, 0) : Offset(0, value);
}

/// Slides [child] into place along one axis, overshooting and rocking to a stop.
///
/// A direct port of the `slideLeft` / `slideRight` / `slideUp` / `slideDown`
/// keyframes from the RedStar template's `animation.txt`: the child enters a
/// full width or height off-stage to one side, swings 8% past its resting
/// place, then damps back through 4%, 4% and 2% before settling. [direction]
/// picks which sequence plays.
///
/// This is a livelier entrance than [SettleIn] and is deliberately reserved for
/// a single element arriving beside or below something else — the legend next
/// to an allocation donut, the quick-action bar rising under the AUM header.
/// Applying it broadly would put the whole screen in motion at once, which is
/// the failure mode [SettleIn]'s flat 12 px rise exists to avoid. Its overshoot
/// is also the one place in the app where motion is allowed to overshoot at
/// all, and it works there because a legend row or an action tile is a label
/// rather than a figure the advisor reads a value off — never wrap a balance,
/// a chart or a transaction amount in it.
///
/// The child is drawn well outside its own bounds on the way in, so the caller
/// must wrap the region it travels through in a [SlideInClip] of the same
/// [direction].
///
/// [index] staggers siblings by [AppMotion.stagger] each, capped at
/// [_maxStaggerSlots].
class SlideIn extends StatefulWidget {
  /// Creates a [SlideIn].
  const SlideIn({
    required this.child,
    required this.direction,
    this.index = 0,
    this.duration = AppMotion.settle,
    this.revealOnScroll = false,
    super.key,
  });

  /// The widget being slid into place.
  final Widget child;

  /// Which ported sequence to play.
  final SlideDirection direction;

  /// Position among staggered siblings, counting from zero.
  final int index;

  /// How long one child's slide takes. The source keyframes run for a full
  /// second; the default here is shorter so a secondary element does not hold
  /// the screen longer than the hero figures do.
  final Duration duration;

  /// Waits for the child to scroll into view before playing, rather than
  /// playing on mount. Set this wherever the child can start below the fold —
  /// otherwise the entrance is over before the reader reaches it.
  final bool revealOnScroll;

  @override
  State<SlideIn> createState() => _SlideInState();
}

/// Highest [SlideIn.index] that still staggers.
const int _maxStaggerSlots = 8;

/// Room a [SlideInClip] leaves on the overshoot side, in logical pixels. Sized
/// to the card padding the legend sits in, so the overshoot plays out inside
/// the card rather than across its border.
const double _overshootSlack = 12;

/// Relative durations of the source's keyframe segments, from its stops at
/// 0/50/65/80/95/100%.
const List<double> _segmentWeights = [50, 15, 15, 15, 5];

/// Builds the [direction]'s keyframes as one animatable offset track.
Animatable<double> _trackFor(SlideDirection direction) => TweenSequence<double>([
  for (var i = 0; i < _segmentWeights.length; i++)
    TweenSequenceItem(
      tween: Tween<double>(
        begin: direction.stops[i],
        end: direction.stops[i + 1],
      ).chain(CurveTween(curve: AppMotion.keyframe)),
      weight: _segmentWeights[i],
    ),
]);

class _SlideInState extends State<SlideIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _offset;

  @override
  void initState() {
    super.initState();
    // The stagger delay is folded into the controller's own duration as a
    // leading hold rather than scheduled with a timer, so there is no pending
    // callback to cancel if the widget is disposed mid-delay.
    final delay = AppMotion.stagger * widget.index.clamp(0, _maxStaggerSlots);
    final total = delay + widget.duration;
    _controller = AnimationController(vsync: this, duration: total);
    _offset = _trackFor(widget.direction).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(delay.inMilliseconds / total.inMilliseconds, 1),
      ),
    );
    if (!widget.revealOnScroll) unawaited(_controller.forward());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Under "reduce motion" the controller is pinned at its end value, which
    // renders the child at rest without a separate code path — and without
    // waiting on a scroll trigger that would then never be needed.
    if (!animationsEnabled(context)) _controller.value = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animated = AnimatedBuilder(
      animation: _offset,
      // Passed as `child` so the subtree is built once and only the offset is
      // recomputed per frame.
      child: widget.child,
      builder: (context, child) => FractionalTranslation(
        translation: widget.direction.offset(_offset.value),
        child: child,
      ),
    );

    if (!widget.revealOnScroll) return animated;
    return OnScrolledIntoView(
      // Placed at rest when it arrived under a fling — a slide is the most
      // conspicuous entrance of the three, so it is the worst one to leave
      // half-played behind a moving finger.
      onVisible: ({required animate}) {
        if (animate) {
          unawaited(_controller.forward());
        } else {
          _controller.value = 1;
        }
      },
      child: animated,
    );
  }
}

/// Clips the edge a [SlideIn] enters from, so its children arrive from
/// off-stage rather than being drawn across whatever sits beside them.
///
/// The opposite edge is left [_overshootSlack] wider (or taller), because the
/// rock past the resting position swings that way — clipping there would cut a
/// legend row's trailing figure mid-flight. Pass the same [direction] as the
/// children.
class SlideInClip extends StatelessWidget {
  /// Creates a [SlideInClip].
  const SlideInClip({required this.child, required this.direction, super.key});

  /// The region the sliding children travel through.
  final Widget child;

  /// The direction its children slide in from.
  final SlideDirection direction;

  @override
  Widget build(BuildContext context) => ClipRect(clipper: _EntryEdgeClipper(direction), child: child);
}

class _EntryEdgeClipper extends CustomClipper<Rect> {
  const _EntryEdgeClipper(this.direction);

  final SlideDirection direction;

  @override
  Rect getClip(Size size) {
    final slack = direction.overshootsBefore ? -_overshootSlack : 0.0;
    return direction.axis == Axis.horizontal
        ? Rect.fromLTWH(slack, 0, size.width + _overshootSlack, size.height)
        : Rect.fromLTWH(0, slack, size.width, size.height + _overshootSlack);
  }

  @override
  bool shouldReclip(_EntryEdgeClipper oldClipper) => oldClipper.direction != direction;
}

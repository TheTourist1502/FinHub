import 'dart:async';

import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/shared/animations/animations.dart';
import 'package:finhub/shared/animations/on_scrolled_into_view.dart';
import 'package:flutter/material.dart';

/// Fades and lifts [child] into place once, when it first mounts.
///
/// This is the entrance used everywhere content arrives — dashboard sections
/// and list rows alike. The child rises [_rise] logical pixels with a
/// decelerating tail so it reads as having settled rather than appeared.
///
/// [index] staggers sibling entrances by [AppMotion.stagger] each, for the
/// first [_maxStaggerSlots] positions only. Past that the child still animates,
/// but with no delay: a stagger choreographs a group arriving together, and a
/// row the reader scrolled down to individually has no group to be staggered
/// against — it should arrive when it is reached, not [_maxStaggerSlots] steps
/// later.
///
/// A row arriving under a fling is placed at rest instead, which is the case
/// the cap used to stand in for. [OnScrolledIntoView] measures the actual
/// scroll speed, so the entrance is dropped exactly when it would read as the
/// list lagging, rather than for every row past an arbitrary index.
///
/// The animation plays once. Refreshing a section's data does not remount it,
/// so pull-to-refresh updates content in place rather than replaying the
/// entrance.
///
/// By default it plays on mount. Set [revealOnScroll] for anything that can
/// start below the fold — a widget three screens down would otherwise finish
/// its entrance long before the reader scrolls to it.
class SettleIn extends StatelessWidget {
  /// Creates a [SettleIn].
  const SettleIn({
    required this.child,
    this.index = 0,
    this.revealOnScroll = false,
    super.key,
  });

  /// The widget being animated into place.
  final Widget child;

  /// Position among staggered siblings, counting from zero.
  final int index;

  /// Waits for the child to scroll into view before playing, rather than
  /// playing on mount.
  final bool revealOnScroll;

  @override
  Widget build(BuildContext context) {
    return _SettleInAnimation(index: index, revealOnScroll: revealOnScroll, child: child);
  }
}

/// Distance the child travels upward into its resting position.
const double _rise = 12;

/// Highest [SettleIn.index] that still earns a stagger delay, expressed as a
/// number of [AppMotion.stagger] steps. Roughly one screenful of list rows —
/// past that the rows are no longer arriving as a group.
const int _maxStaggerSlots = 8;

/// The animated half of [SettleIn].
class _SettleInAnimation extends StatefulWidget {
  const _SettleInAnimation({required this.index, required this.revealOnScroll, required this.child});

  final int index;
  final bool revealOnScroll;
  final Widget child;

  @override
  State<_SettleInAnimation> createState() => _SettleInState();
}

class _SettleInState extends State<_SettleInAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    // The stagger delay is folded into the controller's own duration as a
    // leading [Interval] rather than scheduled with a timer, so there is no
    // pending callback to cancel if the widget is disposed mid-delay.
    // Past the cap the row is no longer part of a group arriving together, so
    // it drops to no delay rather than to the longest one.
    final slot = widget.index > _maxStaggerSlots ? 0 : widget.index;
    final delay = AppMotion.stagger * slot;
    // `total` is always non-zero because `AppMotion.settle` is, so the
    // interval division below is safe.
    final total = delay + AppMotion.settle;
    _controller = AnimationController(vsync: this, duration: total);
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Interval(delay.inMilliseconds / total.inMilliseconds, 1, curve: AppMotion.enter),
    );
    if (!widget.revealOnScroll) unawaited(_controller.forward());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Under "reduce motion" the controller is pinned at its end value, which
    // renders the child in its final position without a separate code path —
    // and without waiting on a scroll trigger that would then never be needed.
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
      animation: _progress,
      // Passed as `child` so the subtree is built once and only the opacity
      // and offset are recomputed per frame.
      child: widget.child,
      builder: (context, child) => Opacity(
        opacity: _progress.value,
        child: Transform.translate(
          offset: Offset(0, _rise * (1 - _progress.value)),
          child: child,
        ),
      ),
    );

    if (!widget.revealOnScroll) return animated;
    return OnScrolledIntoView(
      // A row that arrived under a fling is placed at rest rather than skipped:
      // an entrance that never runs is invisible content, not a missing
      // animation.
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

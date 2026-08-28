import 'dart:math' as math;

import 'package:finhub/core/motion/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding, SchedulerPhase;

/// Calls [onVisible] once — the first time this widget's box has scrolled far
/// enough up the screen to be worth reading.
///
/// The point is that an entrance below the fold should play when the reader
/// arrives at it, not while it sits unseen three screens down. Without this,
/// every animation on a long page has finished before the reader ever gets
/// there, which is the same as having no animation at all.
///
/// Fires at most once **per mount**: content does not replay its entrance when
/// the reader scrolls back past it, which would turn a page into a flickering
/// mess on the way up. A lazily built list is the exception — a `ListView`
/// disposes rows that leave its cache extent and builds them fresh on return,
/// which resets this trigger with them. That is why the dashboard, the one
/// screen that reveals whole sections on scroll, is a [SingleChildScrollView]:
/// its children stay mounted, so each entrance genuinely plays once.
///
/// With no [Scrollable] ancestor there is no scroll to wait for, so [onVisible]
/// runs on the first frame. That fallback matters — a widget that silently
/// never revealed would be invisible content, not a missing animation.
///
/// A row arriving under a fast fling is handed `animate: false`. Past a certain
/// speed the reader has already thrown the row off-screen before its entrance
/// could finish, so playing one means a screenful of half-faded rows trailing
/// the finger — which reads as the list lagging, not as choreography. See
/// [_maxRevealSpeed].
class OnScrolledIntoView extends StatefulWidget {
  /// Creates an [OnScrolledIntoView].
  const OnScrolledIntoView({required this.onVisible, required this.child, super.key});

  /// Run once, on the frame this widget first counts as visible.
  ///
  /// `animate` is `false` when the list was flung past this row too fast for an
  /// entrance to be read; the caller must then render its final frame straight
  /// away rather than skipping the reveal altogether, or the row would never
  /// appear at all.
  final void Function({required bool animate}) onVisible;

  /// The subtree being watched. Rendered unchanged — this widget only observes.
  final Widget child;

  @override
  State<OnScrolledIntoView> createState() => _OnScrolledIntoViewState();
}

/// Fraction of the widget that must be inside the viewport before it counts as
/// visible. The trigger is the box as a whole rather than its top edge, so a
/// card animates once enough of it is on screen to be worth reading — and a
/// card whose children each carry their own trigger reveals as one piece
/// instead of a few rows at a time.
///
/// A box taller than the viewport can never show 40% of itself, so the
/// threshold is measured against whichever is smaller.
const double _revealFraction = 0.4;

/// Scroll speed, in viewports per second, above which an arriving child is
/// rendered at rest instead of animating.
///
/// Two viewports per second means a row crosses the whole viewport in 500 ms —
/// about the length of an entrance ([AppMotion.settle]). Any faster and the row
/// leaves the screen before it has finished arriving, so there is nothing to
/// see but a smear of half-drawn rows.
const double _maxRevealSpeed = 2;

class _OnScrolledIntoViewState extends State<OnScrolledIntoView> {
  ScrollPosition? _position;
  bool _fired = false;

  /// Current scroll speed in logical pixels per second, unsigned.
  double _speed = 0;

  /// Only read when [_lastStamp] is set, which is written in the same step.
  late double _lastPixels;
  Duration? _lastStamp;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _position?.removeListener(_onScroll);
    _position = Scrollable.maybeOf(context)?.position;
    _position?.addListener(_onScroll);
    // Layout has to happen before there is a box to measure, and content that
    // is already on screen must not sit waiting for a scroll that never comes.
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  /// Tracks how fast the list is moving, then re-tests visibility.
  ///
  /// Speed is measured from the pixel delta between notifications rather than
  /// read off the [ScrollPosition]'s activity, which is `@protected`. The frame
  /// timestamp is the clock because it advances under `pump` in tests, where
  /// wall-clock time does not.
  void _onScroll() {
    // `currentFrameTimeStamp` only exists while a frame is being produced, and
    // asserts otherwise. A scroll driven from outside one is a programmatic
    // `jumpTo` — never a fling — so it resets the reading rather than timing it.
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
      _speed = 0;
      _lastStamp = null;
      _check();
      return;
    }

    final pixels = _position!.pixels;
    final stamp = SchedulerBinding.instance.currentFrameTimeStamp;
    final last = _lastStamp;
    // Two notifications inside one frame carry no elapsed time; keep the last
    // good reading rather than dividing by zero.
    if (last != null && stamp > last) {
      final seconds = (stamp - last).inMicroseconds / Duration.microsecondsPerSecond;
      _speed = ((pixels - _lastPixels) / seconds).abs();
    }
    _lastPixels = pixels;
    _lastStamp = stamp;
    _check();
  }

  /// Whether the list is moving too fast for an entrance to be worth playing.
  bool get _isFlinging {
    final viewport = _position?.viewportDimension ?? 0;
    return viewport > 0 && _speed > viewport * _maxRevealSpeed;
  }

  /// Fires [OnScrolledIntoView.onVisible] once [_revealFraction] of the box is
  /// inside the viewport, then stops listening — this is a one-shot trigger.
  void _check() {
    if (_fired || !mounted) return;

    if (_position != null) {
      final box = context.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) return;
      final screenHeight = MediaQuery.sizeOf(context).height;
      final top = box.localToGlobal(Offset.zero).dy;
      final onScreen = math.min(top + box.size.height, screenHeight) - math.max(top, 0);
      if (onScreen < math.min(box.size.height, screenHeight) * _revealFraction) return;
    }

    _fired = true;
    _position?.removeListener(_onScroll);
    widget.onVisible(animate: !_isFlinging);
  }

  @override
  void dispose() {
    _position?.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

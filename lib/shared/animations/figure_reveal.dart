import 'dart:async';

import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/shared/animations/animations.dart';
import 'package:finhub/shared/animations/on_scrolled_into_view.dart';
import 'package:flutter/material.dart';

/// Drives a one-shot eased progress from 0 to 1 that a numeric display lerps
/// its figures across, so a value rolls into place instead of appearing.
///
/// The progress is handed to [builder] rather than a finished number, so one
/// reveal can drive as many figures as a display needs — an amount and its
/// percentage roll together off the same clock instead of drifting apart on
/// two controllers.
///
/// The reveal runs on mount, and again only when [replayKey] changes. A change
/// to the underlying figure does **not** replay it: dragging along a chart
/// rewrites the displayed number many times a second, and restarting the roll
/// on each of those would leave the figure trailing the reader's finger.
/// Pass whatever genuinely warrants a fresh roll — a selected filter, say — as
/// [replayKey], and leave it `null` where only the first appearance animates.
class FigureReveal extends StatefulWidget {
  /// Creates a [FigureReveal].
  const FigureReveal({
    required this.builder,
    this.replayKey,
    this.duration = AppMotion.hero,
    this.curve = AppMotion.settleCurve,
    this.revealOnScroll = false,
    super.key,
  });

  /// Builds the display for an eased progress between 0 and 1. Lerp every
  /// figure that should roll from this one value.
  final Widget Function(BuildContext context, double t) builder;

  /// Replays the reveal whenever this changes. Compared with `==`, so a record
  /// or a plain value both work. `null` means the reveal runs on mount only.
  final Object? replayKey;

  /// How long the roll takes. Defaults to [AppMotion.hero]; secondary figures
  /// should pass [AppMotion.settle] so they do not compete with a hero value.
  final Duration duration;

  /// Easing applied to the progress.
  final Curve curve;

  /// Waits for the figure to scroll into view before rolling, rather than
  /// rolling on mount. Set this wherever the figure can start below the fold —
  /// a hero value that finishes rolling three screens above the reader has
  /// shown them nothing.
  final bool revealOnScroll;

  @override
  State<FigureReveal> createState() => _FigureRevealState();
}

class _FigureRevealState extends State<FigureReveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _progress = CurvedAnimation(parent: _controller, curve: widget.curve);
    if (!widget.revealOnScroll) unawaited(_controller.forward());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Under "reduce motion" the controller is pinned at its end value, so the
    // builder is handed a finished reveal without a separate code path.
    if (!animationsEnabled(context)) _controller.value = 1;
  }

  @override
  void didUpdateWidget(covariant FigureReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
    if (oldWidget.replayKey == widget.replayKey) return;
    if (animationsEnabled(context)) {
      unawaited(_controller.forward(from: 0));
    } else {
      _controller.value = 1;
    }
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
      builder: (context, _) => widget.builder(context, _progress.value),
    );

    if (!widget.revealOnScroll) return animated;
    return OnScrolledIntoView(
      // Figures that scrolled past under a fling land on their real value at
      // once. Rolling them would leave a screenful of numbers still counting up
      // behind the reader's finger — and a wrong figure on screen, briefly, is
      // worse here than no animation.
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

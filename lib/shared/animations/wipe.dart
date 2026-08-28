import 'package:flutter/material.dart';

/// Uncovers [child] from its left edge out to [progress] of its width.
///
/// For a bar that reads as a proportion — an allocation split, a progress
/// track — where the reader should see the composition being laid down in
/// order. It is the flat-bar counterpart to the allocation donut's clock
/// sweep, and it deliberately neither scales nor fades: a segment's width *is*
/// the value, so growing the whole bar from nothing would show a wrong
/// proportion on every frame until the last one.
///
/// Reveals by clipping rather than by resizing, so nothing in the subtree
/// relayouts as it plays — the segments are laid out once at their real widths
/// and progressively uncovered.
///
/// Stateless on purpose: it takes a progress rather than owning a controller,
/// so a display that also rolls figures drives both from one `FigureReveal`
/// instead of running a second ticker that drifts against the first.
class Wipe extends StatelessWidget {
  /// Creates a [Wipe].
  const Wipe({required this.progress, required this.child, super.key});

  /// How much of the width is uncovered, from 0 to 1.
  final double progress;

  /// The subtree being uncovered.
  final Widget child;

  @override
  Widget build(BuildContext context) => ClipRect(clipper: _WipeClipper(progress), child: child);
}

class _WipeClipper extends CustomClipper<Rect> {
  const _WipeClipper(this.progress);

  final double progress;

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * progress, size.height);

  @override
  bool shouldReclip(_WipeClipper oldClipper) => oldClipper.progress != progress;
}

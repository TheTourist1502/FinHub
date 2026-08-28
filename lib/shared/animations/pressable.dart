import 'package:finhub/core/motion/app_motion.dart';
import 'package:finhub/shared/animations/animations.dart';
import 'package:flutter/material.dart';

/// Dips [child] slightly while a finger rests on it.
///
/// Wraps an already-tappable card without touching how it handles taps. The
/// dip is driven by [Listener], which observes raw pointer events instead of
/// competing in the gesture arena, so the card's own `InkWell` keeps its tap
/// callback and its ripple.
///
/// The dip releases as soon as the pointer travels more than [_slop] pixels,
/// because at that point the reader is scrolling the list rather than pressing
/// the card, and a card left dented under a moving finger looks stuck.
class Pressable extends StatefulWidget {
  /// Creates a [Pressable].
  const Pressable({required this.child, super.key});

  /// The tappable card being pressed.
  final Widget child;

  @override
  State<Pressable> createState() => _PressableState();
}

/// Scale applied while held. Deliberately shallow — the reader should feel it
/// more than see it.
const double _pressedScale = 0.98;

/// Pointer travel, in logical pixels, that reclassifies a press as a scroll.
const double _slop = 12;

class _PressableState extends State<Pressable> {
  bool _pressed = false;
  Offset _origin = Offset.zero;

  void _setPressed({required bool value}) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        _origin = event.position;
        _setPressed(value: true);
      },
      onPointerMove: (event) {
        if ((event.position - _origin).distance > _slop) _setPressed(value: false);
      },
      onPointerUp: (_) => _setPressed(value: false),
      onPointerCancel: (_) => _setPressed(value: false),
      child: AnimatedScale(
        scale: _pressed ? _pressedScale : 1,
        duration: animationDuration(context, AppMotion.quick),
        curve: AppMotion.enter,
        child: widget.child,
      ),
    );
  }
}

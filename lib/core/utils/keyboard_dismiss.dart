import 'package:flutter/widgets.dart';

/// Drops focus from whatever input currently holds it and closes the keyboard.
///
/// Prefer this over `FocusScope.of(context).unfocus()`. That call unfocuses the
/// enclosing *scope*, which keeps the field as the scope's `focusedChild` — so
/// the moment a dialog, bottom sheet, or any other route is pushed and popped
/// on top, the route restores that child and the keyboard springs back. This
/// unfocuses the focused node itself, clearing the scope's `focusedChild`, so
/// nothing is restored afterwards.
///
/// Works for any input type — text fields, sheet-backed read-only fields, and
/// custom [Focus] widgets alike — because it targets the primary focus rather
/// than a particular part of the tree.
void dismissKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

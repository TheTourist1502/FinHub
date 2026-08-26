import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Severity level of a snackbar notification.
enum SnackbarType {
  /// Indicates a successful operation.
  success,

  /// Indicates an error or failure.
  error,

  /// Neutral informational message.
  info,
}

/// Global key wired into [MaterialApp.scaffoldMessengerKey].
///
/// Allows [SnackbarService] to reach [ScaffoldMessengerState] from anywhere
/// — including Riverpod notifiers — without requiring a [BuildContext].
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Provides a [SnackbarService] instance backed by [scaffoldMessengerKey].
final snackbarServiceProvider = Provider<SnackbarService>((ref) => SnackbarService(scaffoldMessengerKey));

/// Fire-and-forget service for displaying snackbar notifications.
///
/// Backed by a [GlobalKey<ScaffoldMessengerState>] so it works from any
/// Riverpod notifier or widget without needing [BuildContext].
///
/// Usage:
/// ```dart
/// ref.read(snackbarServiceProvider).showError('Login failed');
/// ref.read(snackbarServiceProvider).showSuccess('Saved successfully');
/// ref.read(snackbarServiceProvider).showInfo('Coming soon');
/// ```
class SnackbarService {
  const SnackbarService(this._key);

  final GlobalKey<ScaffoldMessengerState> _key;

  /// Shows a red error snackbar.
  ///
  /// When [title] is provided (e.g. a server-authored RFC 7807 `title`), it
  /// is rendered as a bold heading above [message].
  void showError(String message, {String? title}) => _show(message, SnackbarType.error, title: title);

  /// Shows a green success snackbar.
  void showSuccess(String message) => _show(message, SnackbarType.success);

  /// Shows a neutral info snackbar.
  void showInfo(String message) => _show(message, SnackbarType.info);

  void _show(String message, SnackbarType type, {String? title}) {
    final color = switch (type) {
      SnackbarType.error => Colors.red.shade700,
      SnackbarType.success => Colors.green.shade700,
      SnackbarType.info => Colors.blueGrey.shade700,
    };
    _key.currentState?.showSnackBar(
      SnackBar(
        content: title == null || title.isEmpty
            ? Text(message)
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(message),
                ],
              ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

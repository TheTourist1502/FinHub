import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Labelled text input field backed by the `reactive_forms` library.
///
/// Renders a [Text] label above a [ReactiveTextField] so the label sits
/// outside the input border, matching the Figma design. The caller is
/// responsible for placing this widget inside a [ReactiveForm] that owns
/// the control named [formControlName].
///
/// For password fields, set [isPassword] to `true` and supply
/// [isObscured] + [onToggleObscure] to manage the show/hide toggle state.
///
/// Omitting [hint] falls back to the app-wide `Type...` placeholder, so an
/// empty field is never left with no prompt at all.
class AppTextField extends StatelessWidget {
  /// Creates an [AppTextField].
  const AppTextField({
    required this.label,
    required this.formControlName,
    this.hint,
    this.isPassword = false,
    this.isObscured = false,
    this.onToggleObscure,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.validationMessages,
    super.key,
  });

  /// Label text rendered above the input box.
  final String label;

  /// Placeholder text shown when the field is empty.
  ///
  /// Defaults to the shared `Type...` hint when `null`.
  final String? hint;

  /// Name of the [FormControl] in the parent [ReactiveForm]'s [FormGroup].
  final String formControlName;

  /// When `true`, the field renders in password mode with an eye toggle icon.
  final bool isPassword;

  /// Controls whether the password text is currently obscured.
  /// Only relevant when [isPassword] is `true`.
  final bool isObscured;

  /// Called when the user taps the eye icon to toggle password visibility.
  final VoidCallback? onToggleObscure;

  /// When `false`, the field is non-interactive.
  final bool enabled;

  /// Keyboard type hint passed to the underlying [TextField].
  final TextInputType? keyboardType;

  /// IME action passed to the underlying [TextField].
  final TextInputAction? textInputAction;

  /// Validation error messages keyed by [ValidationMessage] constants.
  ///
  /// Example:
  /// ```dart
  /// {
  ///   ValidationMessage.required: (_) => 'Email is required',
  ///   ValidationMessage.email:    (_) => 'Enter a valid email',
  /// }
  /// ```
  final Map<String, ValidationMessageFunction>? validationMessages;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelMedium),
        const SizedBox(height: 8),
        ReactiveTextField<String>(
          formControlName: formControlName,
          obscureText: isPassword && isObscured,
          readOnly: !enabled,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: AppTypography.inputText,
          validationMessages: validationMessages ?? {},
          decoration: InputDecoration(
            hintText: hint ?? context.l10n.commonInputHint,
            suffixIcon: isPassword ? _PasswordToggle(isObscured: isObscured, onToggle: onToggleObscure) : null,
          ),
        ),
      ],
    );
  }
}

/// Eye icon button that toggles password visibility inside [AppTextField].
class _PasswordToggle extends StatelessWidget {
  const _PasswordToggle({required this.isObscured, this.onToggle});

  final bool isObscured;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isObscured ? 'Show password' : 'Hide password',
      button: true,
      child: IconButton(
        icon: Iconify(isObscured ? Mdi.eye : Mdi.eye_off, size: 20, color: context.appColors.textSecondary),
        onPressed: onToggle,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: AppDimensions.minTouchTarget,
          minHeight: AppDimensions.minTouchTarget,
        ),
      ),
    );
  }
}

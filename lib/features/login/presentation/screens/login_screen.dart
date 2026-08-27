import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/core/theme/app_typography.dart';
import 'package:finhub/core/utils/keyboard_dismiss.dart';
import 'package:finhub/features/login/presentation/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Username-or-email and password sign-in. There is no SSO.
class LoginScreen extends ConsumerStatefulWidget {
  /// Creates the screen. [redirectTo] is the path the guard bounced the user
  /// off, restored after a successful sign-in.
  const LoginScreen({this.redirectTo, super.key});

  /// Where to go once signed in, if the user was heading somewhere specific.
  final String? redirectTo;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _obscured = true;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final reason = await ref
        .read(authNotifierProvider.notifier)
        .signIn(identifier: _identifier.text, password: _password.text);
    if (!mounted || reason == null) return;
    // The reason is a diagnostic, never shown — sign-in surfaces one message
    // whatever half of the credential was wrong.
    setState(() => _failed = true);
    _formKey.currentState?.validate();
  }

  /// Set once a sign-in has been refused, so the form can show the message
  /// under the fields rather than in a snackbar that scrolls away.
  bool _failed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final busy = ref.watch(authNotifierProvider) is AuthAuthenticating;

    // A signed-in state means the guard is about to redirect; follow the
    // caller's intended destination if there was one.
    ref.listen(authNotifierProvider, (_, next) {
      final target = widget.redirectTo;
      if (next is AuthAuthenticated && target != null && target.isNotEmpty) context.go(target);
    });

    return Scaffold(
      body: GestureDetector(
        onTap: dismissKeyboard,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.cardHorizontalMargin,
                vertical: AppDimensions.cardVerticalPadding,
              ),
              child: ConstrainedBox(
                // Keeps the form readable on a tablet or in landscape rather
                // than stretching the fields the full width of the screen.
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Iconify(Mdi.finance, color: colors.textBrandNavyBlue, size: 40),
                          const SizedBox(width: AppDimensions.spaceSm),
                          Text(l10n.appName, style: AppTypography.logoStyle.copyWith(color: colors.textPrimary)),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spaceXl),
                      Text(
                        l10n.authLoginTitle,
                        textAlign: TextAlign.center,
                        style: AppTypography.pageTitle.copyWith(color: colors.textPrimary),
                      ),
                      const SizedBox(height: AppDimensions.spaceSx),
                      Text(
                        l10n.authLoginSubtitle,
                        textAlign: TextAlign.center,
                        style: AppTypography.pageSubtitle.copyWith(color: colors.textSecondary),
                      ),
                      const SizedBox(height: AppDimensions.spaceXl),
                      TextFormField(
                        controller: _identifier,
                        enabled: !busy,
                        onChanged: (_) => _clearFailure(),
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: l10n.authIdentifierLabel,
                          hintText: l10n.authIdentifierHint,
                        ),
                        validator: (value) =>
                            (value ?? '').trim().isEmpty ? l10n.validationIdentifierRequired : _failureMessage(l10n),
                      ),
                      const SizedBox(height: AppDimensions.spaceMd),
                      TextFormField(
                        controller: _password,
                        enabled: !busy,
                        onChanged: (_) => _clearFailure(),
                        obscureText: _obscured,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => busy ? null : _submit(),
                        decoration: InputDecoration(
                          labelText: l10n.authPasswordLabel,
                          hintText: l10n.authPasswordHint,
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscured = !_obscured),
                            tooltip: _obscured ? l10n.authShowPassword : l10n.authHidePassword,
                            icon: Iconify(
                              _obscured ? Mdi.eye_outline : Mdi.eye_off_outline,
                              color: colors.iconSecondary,
                              size: 20,
                            ),
                          ),
                        ),
                        validator: (value) =>
                            (value ?? '').isEmpty ? l10n.validationPasswordRequired : _failureMessage(l10n),
                      ),
                      const SizedBox(height: AppDimensions.spaceLg),
                      SizedBox(
                        height: AppDimensions.buttonHeight,
                        child: FilledButton(
                          onPressed: busy ? null : _submit,
                          child: busy
                              ? const SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(l10n.authLoginButton),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Drops the refusal message the moment the user edits either field, so a
  /// second attempt starts clean.
  void _clearFailure() {
    if (_failed) setState(() => _failed = false);
  }

  /// The refusal message, shown under both fields after a refused attempt.
  String? _failureMessage(AppLocalizations l10n) => _failed ? l10n.authInvalidCredentials : null;
}

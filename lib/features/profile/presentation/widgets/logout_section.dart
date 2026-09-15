import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_dimensions.dart';
import 'package:finhub/core/theme/app_theme.dart';
import 'package:finhub/features/login/presentation/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

/// Profile footer section containing the Log Out button.
///
/// Tapping it calls [AuthNotifier.signOut], which clears the locally-minted
/// session then discards the whole Riverpod container via
/// `SessionRoot.restartSession` — the same call every other sign-out entry
/// point in the app uses; this widget adds no sign-out bookkeeping of its own.
/// The route guard then redirects to `/login` automatically.
class LogoutSection extends ConsumerWidget {
  /// Creates a [LogoutSection].
  const LogoutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onError = Theme.of(context).colorScheme.onError;
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        style: AppTheme.dangerStyle(context),
        onPressed: () => ref.read(authNotifierProvider.notifier).signOut(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Iconify(Mdi.logout, size: 18, color: onError),
            const SizedBox(width: 8),
            Text(context.l10n.profileSignOutButton),
          ],
        ),
      ),
    );
  }
}

import 'package:finhub/features/my_commissions/presentation/screens/my_commissions_screen.dart';
import 'package:flutter/material.dart';

/// Commissions tab content for a [UserRole.leadership] user.
///
/// Renders the same content as the advisor's [MyCommissionsScreen] — trend
/// card, tab layout, summary and detail lists — showing the **selected
/// advisor's** commissions rather than the signed-in user's. That scoping is
/// handled entirely by `DataScope` inside `MyCommissionsMockRepository`, so nothing here
/// or below is leadership-aware.
///
/// The only difference is chrome: [MyCommissionsScreen.showAppBar] is `false`
/// because this renders inside the bottom-nav shell, which supplies the
/// header. The advisor's version is pushed over the shell and keeps its own
/// app bar with a back arrow, which would be wrong on a tab root — there is
/// nothing to pop back to.
///
/// It exists as its own screen rather than a flag at the route, so the
/// leadership Commissions tab has a name to grow into if the two diverge.
class LeadershipCommissionsScreen extends StatelessWidget {
  /// Creates a [LeadershipCommissionsScreen].
  const LeadershipCommissionsScreen({super.key});

  @override
  Widget build(BuildContext context) => const MyCommissionsScreen(showAppBar: false);
}

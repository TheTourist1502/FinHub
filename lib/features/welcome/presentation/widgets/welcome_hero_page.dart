import 'package:finhub/core/l10n/l10n.dart';
import 'package:finhub/core/theme/app_color_tokens.dart';
import 'package:finhub/shared/animations/settle_in.dart';
import 'package:finhub/shared/widgets/brand/app_logos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// First page of the welcome carousel — brand mark, hero copy, and a full-
/// width illustration. `WelcomeScreen` renders the CTA/pagination footer
/// shared across both pages.
class WelcomeHeroPage extends StatelessWidget {
  /// Creates a [WelcomeHeroPage].
  const WelcomeHeroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo ──────────────────────────────────────────────────────
          // Three slots, arriving in reading order: wordmark, then the hero
          // copy, then the illustration. The page is a single screenful above
          // the fold, so each plays on mount rather than waiting on a scroll.
          const SettleIn(child: Center(child: AppWordmarkLogo(width: 145))),
          const SizedBox(height: 40),

          // ── Hero copy ─────────────────────────────────────────────────
          // Title and subtitle share one entrance — they are one block of
          // copy, and splitting them would cost a second controller to say
          // the same thing.
          SettleIn(
            index: 1,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    context.l10n.welcomeHeroTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 23,
                      height: 1.2,
                      color: colors.textBrandNavyBlue,
                      letterSpacing: -0.25,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    context.l10n.welcomeHeroSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      height: 1.5,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Illustration ──────────────────────────────────────────────
          Expanded(
            child: SettleIn(
              index: 2,
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = MediaQuery.sizeOf(context).width * 0.7;
                    return SvgPicture.asset('assets/images/welcome_page.svg', width: width);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

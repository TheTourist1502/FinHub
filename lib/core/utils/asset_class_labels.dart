/// Localised label resolvers for displaying asset-class names at different
/// label lengths.
library;

import 'package:finhub/generated/l10n/app_localizations.dart';

/// Short abbreviation — used in compact bar labels and summaries.
///
/// Returns a 2–5 character abbreviation, or [assetClass] unchanged if unknown.
String assetClassShortLabel(AppLocalizations l10n, String assetClass) => switch (assetClass) {
  'Equity' => l10n.assetClassShortEquity,
  'EQUITIES' => l10n.assetClassShortEquity,
  'Fixed Income' => l10n.assetClassShortFixedIncome,
  'BONDS' => l10n.assetClassShortBonds,
  'REAL_ESTATE' => l10n.assetClassShortRealEstate,
  'DEBENTURES' => l10n.assetClassShortDebentures,
  'Alts' => l10n.assetClassShortAlts,
  'Cash' => l10n.assetClassShortCash,
  'Alternative Investment' => l10n.assetClassShortAlternativeInvestment,
  'Alternative Investments' => l10n.assetClassShortAlternativeInvestment,
  'Structured Products' => l10n.assetClassShortStructuredProducts,
  'Cash & Cash Equivalent' => l10n.assetClassShortCash,
  'Mutual Funds' => l10n.assetClassShortMutualFunds,
  'Mutual Fund' => l10n.assetClassShortMutualFunds,
  'Derivatives' => l10n.assetClassShortDerivatives,
  'Annuities' => l10n.assetClassShortAnnuities,
  'Others' => l10n.assetClassShortOthers,
  'Rest' => l10n.assetClassShortRest,
  _ => assetClass,
};

/// Medium label — used in chart legends and donut-centre labels.
///
/// Returns a readable abbreviated name, or [assetClass] unchanged if unknown.
String assetClassMediumLabel(AppLocalizations l10n, String assetClass) => switch (assetClass) {
  'Equity' => l10n.assetClassMediumEquity,
  'EQUITIES' => l10n.assetClassMediumEquity,
  'Fixed Income' => l10n.assetClassMediumFixedIncome,
  'BONDS' => l10n.assetClassMediumBonds,
  'REAL_ESTATE' => l10n.assetClassMediumRealEstate,
  'DEBENTURES' => l10n.assetClassMediumDebentures,
  'Alts' => l10n.assetClassMediumAlts,
  'Cash' => l10n.assetClassMediumCash,
  'Alternative Investment' => l10n.assetClassMediumAlternativeInvestment,
  'Alternative Investments' => l10n.assetClassMediumAlternativeInvestments,
  'Structured Products' => l10n.assetClassMediumStructuredProducts,
  'Cash & Cash Equivalent' => l10n.assetClassMediumCash,
  'Mutual Funds' => l10n.assetClassMediumMutualFunds,
  'Mutual Fund' => l10n.assetClassMediumMutualFunds,
  'Derivatives' => l10n.assetClassMediumDerivatives,
  'Annuities' => l10n.assetClassMediumAnnuities,
  'Others' => l10n.assetClassMediumOthers,
  'Rest' => l10n.assetClassMediumRest,
  _ => assetClass,
};

/// Long label — used where horizontal space allows the full asset-class name,
/// such as position subtitles and detail rows.
///
/// Returns the unabbreviated name, or [assetClass] unchanged if unknown.
String assetClassLongLabel(AppLocalizations l10n, String assetClass) => switch (assetClass) {
  'Equity' => l10n.assetClassLongEquity,
  'EQUITIES' => l10n.assetClassLongEquity,
  'Fixed Income' => l10n.assetClassLongFixedIncome,
  'BONDS' => l10n.assetClassLongBonds,
  'REAL_ESTATE' => l10n.assetClassLongRealEstate,
  'DEBENTURES' => l10n.assetClassLongDebentures,
  'Alts' => l10n.assetClassLongAlts,
  'Cash' => l10n.assetClassLongCash,
  'Alternative Investment' => l10n.assetClassLongAlternativeInvestment,
  'Alternative Investments' => l10n.assetClassLongAlternativeInvestments,
  'Structured Products' => l10n.assetClassLongStructuredProducts,
  'Cash & Cash Equivalent' => l10n.assetClassLongCash,
  'Mutual Funds' => l10n.assetClassLongMutualFunds,
  'Mutual Fund' => l10n.assetClassLongMutualFunds,
  'Derivatives' => l10n.assetClassLongDerivatives,
  'Annuities' => l10n.assetClassLongAnnuities,
  'Others' => l10n.assetClassLongOthers,
  'Rest' => l10n.assetClassLongRest,
  _ => assetClass,
};

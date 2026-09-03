// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'FinHub';

  @override
  String get errorNetwork => 'No internet connection. Please check your network and try again.';

  @override
  String errorServer(String statusCode) {
    return 'Server error ($statusCode). Please try again later.';
  }

  @override
  String get errorUnauthorized => 'Your session has expired. Please log in again.';

  @override
  String get errorForbidden => 'You do not have permission to perform this action.';

  @override
  String get errorNotFound => 'The requested resource was not found.';

  @override
  String get errorUnknown => 'An unexpected error occurred. Please try again.';

  @override
  String get commonInvalidEmail => 'Enter a valid email address.';

  @override
  String commonInvalidMobileNumber(int min, int max) {
    return 'Must be between $min and $max digits.';
  }

  @override
  String get commonInvalidPostalCode => 'Enter a valid postal code.';

  @override
  String commonMaxLengthExceeded(int max) {
    return 'Maximum $max characters allowed.';
  }

  @override
  String validationFieldRequired(String fieldName) {
    return '$fieldName is required !';
  }

  @override
  String get authLoginTitle => 'Welcome back';

  @override
  String get authLoginSubtitle => 'Sign in to your advisor workspace.';

  @override
  String get authIdentifierLabel => 'Username or email';

  @override
  String get authIdentifierHint => 'e.g. daniel.alvarez';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHint => 'Enter your password';

  @override
  String get authShowPassword => 'Show password';

  @override
  String get authHidePassword => 'Hide password';

  @override
  String get authLoginButton => 'Sign in';

  @override
  String get authSignOutButton => 'Sign out';

  @override
  String get authInvalidCredentials => 'That username or password is not correct.';

  @override
  String get validationIdentifierRequired => 'Enter your username or email.';

  @override
  String get validationPasswordRequired => 'Enter your password.';

  @override
  String get accessDeniedTitle => 'Access denied';

  @override
  String get accessDeniedMessage => 'Your role does not have access to this area.';

  @override
  String get accessDeniedBackButton => 'Back to home';

  @override
  String get navHome => 'Home';

  @override
  String get navHouseholds => 'Households';

  @override
  String get navRealTime => 'Real-Time';

  @override
  String get navServiceRequests => 'Requests';

  @override
  String get navCommissions => 'Commissions';

  @override
  String get navInsights => 'Insights';

  @override
  String get roleAdvisor => 'Advisor';

  @override
  String get roleLeadership => 'Leadership';

  @override
  String comingSoonTitle(String tab) {
    return '$tab is on the way';
  }

  @override
  String get comingSoonMessage => 'This tab is wired up and waiting for its screens.';

  @override
  String dashboardGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String dashboardSessionSummary(String role, String advisorId) {
    return 'Signed in as $role · advisor $advisorId';
  }

  @override
  String get appErrorWidgetEmptyDescription => 'There\'s no data to show right now.';

  @override
  String get appErrorWidgetEmptyTitle => 'Nothing Here Yet';

  @override
  String get appErrorWidgetForbiddenDescription => 'You do not have permission to perform this action.';

  @override
  String get appErrorWidgetForbiddenTitle => 'Access Denied';

  @override
  String get appErrorWidgetMaintenanceDescription =>
      'This feature is temporarily unavailable while we make improvements.';

  @override
  String get appErrorWidgetMaintenanceTitle => 'Under Maintenance';

  @override
  String get appErrorWidgetNetworkDescription => 'No internet connection. Please check your network and try again.';

  @override
  String get appErrorWidgetNetworkTitle => 'No Connection';

  @override
  String get appErrorWidgetNotFoundDescription => 'The item you\'re looking for doesn\'t exist or has been moved.';

  @override
  String get appErrorWidgetNotFoundTitle => 'Not Found';

  @override
  String get appErrorWidgetServerDescription => 'Something went wrong on our end. Please try again later.';

  @override
  String get appErrorWidgetServerTitle => 'Server Error';

  @override
  String get appErrorWidgetServiceUnavailableDescription =>
      'The service is temporarily unavailable. Please try again shortly.';

  @override
  String get appErrorWidgetServiceUnavailableTitle => 'Service Unavailable';

  @override
  String get appErrorWidgetTimeoutDescription => 'The request took too long to respond. Please try again.';

  @override
  String get appErrorWidgetTimeoutTitle => 'Request Timed Out';

  @override
  String get appErrorWidgetUnauthorizedDescription => 'Your session has expired. Please log in again.';

  @override
  String get appErrorWidgetUnauthorizedTitle => 'Session Expired';

  @override
  String get appErrorWidgetUnknownDescription => 'An unexpected error occurred. Please try again.';

  @override
  String get appErrorWidgetUnknownTitle => 'Something Went Wrong';

  @override
  String get appErrorWidgetValidationDescription =>
      'Some of the information provided isn\'t valid. Please review and try again.';

  @override
  String get appErrorWidgetValidationTitle => 'Invalid Information';

  @override
  String get commonBrowseFile => 'Browse File';

  @override
  String get commonButtonCancel => 'Cancel';

  @override
  String get commonButtonClear => 'Clear';

  @override
  String get commonButtonOk => 'OK';

  @override
  String get commonButtonRetry => 'Try Again';

  @override
  String commonDuplicateFile(String fileName) {
    return 'A file with $fileName already exists.';
  }

  @override
  String get commonFilePickFailed => 'Couldn\'t open the file picker. Please try again.';

  @override
  String commonFileTooLarge(String limit) {
    return 'File must be smaller than $limit.';
  }

  @override
  String commonFileTypeNotAllowed(String rejected, num allowedCount, String allowed) {
    String _temp0 = intl.Intl.pluralLogic(
      allowedCount,
      locale: localeName,
      other: 'types are',
      one: 'type is',
    );
    return 'File type with $rejected is not allowed. Allowed file $_temp0 $allowed !';
  }

  @override
  String get commonInputHint => 'Type...';

  @override
  String commonMaxFilesReached(int count) {
    return 'Max file count is $count.';
  }

  @override
  String get commonNoRecordFound => 'No Record Found!';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonSearchClear => 'Clear search';

  @override
  String get commonUnsupportedFileType => 'Unsupported file type. Please choose a supported file.';

  @override
  String get commonUploadedDocumentsTitle => 'Uploaded Documents';

  @override
  String selectNSelected(int count) {
    return '$count selected';
  }

  @override
  String get selectSearchHint => 'Search...';

  @override
  String get statusApproved => 'Approved';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusEscalated => 'Escalated';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusNone => 'None';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get allocationChartRoundingNote =>
      'ⓘ Values are rounded to two decimal places and percentages to one decimal place.';

  @override
  String get assetAllocationLabel => 'Asset Allocation';

  @override
  String get assetClassLongAlternativeInvestment => 'Alternative Investment';

  @override
  String get assetClassLongAlternativeInvestments => 'Alternative Investments';

  @override
  String get assetClassLongAlts => 'Alternatives';

  @override
  String get assetClassLongAnnuities => 'Annuities';

  @override
  String get assetClassLongBonds => 'Bonds';

  @override
  String get assetClassLongCash => 'Cash & Cash Equivalent';

  @override
  String get assetClassLongDebentures => 'Debentures';

  @override
  String get assetClassLongDerivatives => 'Derivatives';

  @override
  String get assetClassLongEquity => 'Equity';

  @override
  String get assetClassLongFixedIncome => 'Fixed Income';

  @override
  String get assetClassLongMutualFunds => 'Mutual Funds';

  @override
  String get assetClassLongOthers => 'Others';

  @override
  String get assetClassLongRealEstate => 'Real Estate';

  @override
  String get assetClassLongRest => 'Rest';

  @override
  String get assetClassLongStructuredProducts => 'Structured Products';

  @override
  String get assetClassMediumAlternativeInvestment => 'Alt. Inv.';

  @override
  String get assetClassMediumAlternativeInvestments => 'Alt. Invs.';

  @override
  String get assetClassMediumAlts => 'Alt';

  @override
  String get assetClassMediumAnnuities => 'Annuities';

  @override
  String get assetClassMediumBonds => 'Bonds';

  @override
  String get assetClassMediumCash => 'Cash';

  @override
  String get assetClassMediumDebentures => 'Debentures';

  @override
  String get assetClassMediumDerivatives => 'Derivatives';

  @override
  String get assetClassMediumEquity => 'Equity';

  @override
  String get assetClassMediumFixedIncome => 'Fixed Inc.';

  @override
  String get assetClassMediumMutualFunds => 'Mutual Funds';

  @override
  String get assetClassMediumOthers => 'Others';

  @override
  String get assetClassMediumRealEstate => 'Real Est.';

  @override
  String get assetClassMediumRest => 'Rest';

  @override
  String get assetClassMediumStructuredProducts => 'Str. Prod.';

  @override
  String get assetClassShortAlternativeInvestment => 'Alt. Invest.';

  @override
  String get assetClassShortAlts => 'Alt';

  @override
  String get assetClassShortAnnuities => 'Annty.';

  @override
  String get assetClassShortBonds => 'Bonds';

  @override
  String get assetClassShortCash => 'Cash';

  @override
  String get assetClassShortDebentures => 'Dbnt';

  @override
  String get assetClassShortDerivatives => 'Deriv.';

  @override
  String get assetClassShortEquity => 'Eq';

  @override
  String get assetClassShortFixedIncome => 'FI';

  @override
  String get assetClassShortMutualFunds => 'MF';

  @override
  String get assetClassShortOthers => 'Other';

  @override
  String get assetClassShortRealEstate => 'RE';

  @override
  String get assetClassShortRest => 'Rest';

  @override
  String get assetClassShortStructuredProducts => 'Str. Prod.';

  @override
  String get commonButtonChange => 'Change';

  @override
  String get commonSortBy => 'Sort By';

  @override
  String get historyChartBreadcrumbSeparator => ' > ';

  @override
  String get historyChartChangeRowSeparator => ' • ';

  @override
  String historyChartCommissionDataAsOf(String date) {
    return 'ⓘ This chart is based on data as of $date. YTD commission amounts are tentative and subject to pending validation.';
  }

  @override
  String historyChartDataAsOf(String date) {
    return 'ⓘ This chart is based on data as of $date.';
  }

  @override
  String get riskProfileConservative => 'Conservative';

  @override
  String get riskProfileGrowth => 'Growth';

  @override
  String get riskProfileHighRisk => 'High Risk';

  @override
  String get riskProfileLowRisk => 'Low Risk';

  @override
  String get riskProfileModerate => 'Moderate';

  @override
  String get riskProfileModerateRisk => 'Moderate Risk';

  @override
  String get riskProfileModeratelyAggressive => 'Moderately Aggressive';

  @override
  String get riskProfileModeratelyConservative => 'Moderately Conservative';

  @override
  String get riskProfileSignificantRisk => 'Significant Risk';

  @override
  String get riskProfileSpeculative => 'Speculative';

  @override
  String get dashboardAssetAllocation => 'Asset Allocation';

  @override
  String get dashboardAumLabel => 'AUM';

  @override
  String get dashboardByAum => '( By AUM )';

  @override
  String get dashboardHeroYtdLabel => 'YTD';

  @override
  String dashboardHouseholdIdLabel(String code) {
    return 'Household ID: #$code';
  }

  @override
  String get dashboardQuickActionAccountMaintenance => 'Account Maintenance';

  @override
  String get dashboardQuickActionAssetMovement => 'Asset Movement';

  @override
  String get dashboardQuickActionClientSearch => 'Client Search';

  @override
  String get dashboardQuickActionInvestorPortal => 'Investor Portal';

  @override
  String get dashboardQuickActionInvestorPortalLaunchFailedMessage =>
      'Could not open the Investor Portal. Please try again.';

  @override
  String get dashboardQuickActionMeetingNotes => 'Meeting Notes';

  @override
  String get dashboardQuickActionMyCommissions => 'Commissions';

  @override
  String get dashboardQuickActionOnlineAccess => 'Online Access';

  @override
  String get dashboardQuickActionTasksDashboard => 'Tasks Dashboard';

  @override
  String get dashboardRecentTransactions => 'Recent Transactions';

  @override
  String dashboardRecentTransactionsAsOf(String date) {
    return '( As of $date )';
  }

  @override
  String get dashboardTopHouseholds => 'Top 5 Households';

  @override
  String get dashboardTopHouseholdsShort => 'Top Households';

  @override
  String get dashboardTotalAum => 'TOTAL AUM';

  @override
  String get dashboardTotalCommissions => 'TOTAL COMMISSION';

  @override
  String get dashboardTransactionDateToday => 'Today';

  @override
  String get dashboardTransactionDateYesterday => 'Yesterday';

  @override
  String get dashboardViewAll => 'View All';

  @override
  String get dashboardViewTransactionHistory => 'View Transaction History';

  @override
  String get dashboardYtdChangeLabel => 'YTD Change';

  @override
  String get historyChartNoData => 'No data available for this period.';

  @override
  String get historyChartRangeCurrentMonth => 'Current Month';

  @override
  String get historyChartRangePastSixMonths => 'Past 6M';

  @override
  String get historyChartRangePastThreeMonths => 'Past 3M';

  @override
  String get historyChartRangeYtd => 'YTD';

  @override
  String historyChartWeekTooltip(int week, String date, String value) {
    return 'Commission of Week$week $date is $value';
  }

  @override
  String get transactionTypeNonTrade => 'Non-Trade';

  @override
  String get viewTransactionsTypeBuy => 'Buy';

  @override
  String get viewTransactionsTypeSell => 'Sell';

  @override
  String get viewTransactionsTitle => 'Transactions History';

  @override
  String accountsAllLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ALL ACCOUNTS ($count)',
      one: 'ALL ACCOUNT ($count)',
      zero: 'ALL ACCOUNT ($count)',
    );
    return '$_temp0';
  }

  @override
  String accountsCustodianLabel(String name) {
    return 'Custodian : $name';
  }

  @override
  String get accountsFilterAll => 'All';

  @override
  String get accountsFilterHouseholdLinked => 'Household-linked';

  @override
  String get accountsFilterStandalone => 'Standalone';

  @override
  String accountsIdLabel(String number) {
    return 'Account Number : $number';
  }

  @override
  String get accountsPaginationError => 'Failed to load more accounts';

  @override
  String get commonName => 'Name';

  @override
  String get dashboardViewDetails => 'View Details';

  @override
  String accountDetailAccountNumberLabel(String number) {
    return 'Account: $number';
  }

  @override
  String accountDetailAllHoldings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ALL HOLDINGS ($count)',
      one: 'ALL HOLDING ($count)',
      zero: 'ALL HOLDING ($count)',
    );
    return '$_temp0';
  }

  @override
  String get accountDetailAllTransactionsHeader => 'Last 30 Transactions';

  @override
  String get accountDetailAssetAllocation => 'Asset Allocation';

  @override
  String get accountDetailAumTrend => 'AUM Trend';

  @override
  String get accountDetailAumTrendEmpty => 'No AUM trend data yet';

  @override
  String get accountDetailHeroYtdLabel => 'YTD';

  @override
  String get accountDetailLatestActivity => 'Latest Activity';

  @override
  String get accountDetailPositions => 'Positions';

  @override
  String get accountDetailPositionsEmptyFilter => 'No holdings in this asset class';

  @override
  String get accountDetailPositionsFilterAll => 'All Asset Classes';

  @override
  String get accountDetailRiskProfileLabel => 'Risk Profile:';

  @override
  String get accountDetailScreenTitle => 'Account Details';

  @override
  String get accountDetailTabOverview => 'Overview';

  @override
  String get accountDetailTabTransactions => 'Transactions';

  @override
  String get accountDetailToday => 'TODAY';

  @override
  String get accountDetailTransactionsEmptySearch => 'No transactions match your search';

  @override
  String get accountDetailTransactionsSearchHint => 'Search';

  @override
  String get commonAmount => 'Amount';

  @override
  String get commonDate => 'Date';

  @override
  String get commonValue => 'Value';

  @override
  String get transactionFilterAllTransactions => 'All Transactions';

  @override
  String get transactionFilterNonTrade => 'Non-Trade';

  @override
  String get transactionFilterTrade => 'Trade';

  @override
  String transactionPrice(String price) {
    return 'Price: $price';
  }

  @override
  String viewTransactionsAssetClass(String assetClass) {
    return 'Asset Class: $assetClass';
  }

  @override
  String viewTransactionsDescription(String description) {
    return 'Description: $description';
  }

  @override
  String get viewTransactionsDetailClose => 'Close';

  @override
  String get viewTransactionsDetailLabelAmount => 'Transaction Amount';

  @override
  String get viewTransactionsDetailLabelAssetClass => 'Asset Class';

  @override
  String get viewTransactionsDetailLabelDate => 'Transaction Date';

  @override
  String get viewTransactionsDetailLabelDescription => 'Description';

  @override
  String get viewTransactionsDetailLabelPricePerUnit => 'Price Per Unit';

  @override
  String get viewTransactionsDetailLabelQuantity => 'Quantity';

  @override
  String get viewTransactionsDetailLabelTradeDetails => 'Additional Details';

  @override
  String get viewTransactionsDetailLabelTradeId => 'Trade ID';

  @override
  String get viewTransactionsDetailTitle => 'Transaction Details';

  @override
  String viewTransactionsQuantity(double qty) {
    final intl.NumberFormat qtyNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String qtyString = qtyNumberFormat.format(qty);

    return 'Quantity: $qtyString';
  }

  @override
  String viewTransactionsQuantityShort(double qty) {
    final intl.NumberFormat qtyNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String qtyString = qtyNumberFormat.format(qty);

    return 'Qty: $qtyString';
  }

  @override
  String get viewTransactionsViewDetails => 'View Details';

  @override
  String get viewTransactionsEmpty => 'No transactions match this filter';

  @override
  String get viewTransactionsPaginationError => 'Failed to load more transactions';

  @override
  String get viewTransactionsSearchHint => 'Search';

  @override
  String get viewTransactionsAllHeader => 'Last 30 Transactions';

  @override
  String get accountsSearchHint => 'Search by account...';

  @override
  String get householdsSearchHint => 'Search by household...';

  @override
  String get householdsTitle => 'Households';

  @override
  String get householdsAccountsTabLabel => 'Accounts';

  @override
  String householdsAllLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ALL HOUSEHOLDS ($count)',
      one: 'ALL HOUSEHOLD ($count)',
      zero: 'ALL HOUSEHOLD ($count)',
    );
    return '$_temp0';
  }

  @override
  String householdsHouseholdIdLabel(String code) {
    return 'ID: $code';
  }

  @override
  String householdsTotalAccounts(int count) {
    return '$count Accounts';
  }

  @override
  String get householdsPaginationError => 'Failed to load more households';

  @override
  String get householdDetailScreenTitle => 'Household Details';

  @override
  String get householdDetailTabOverview => 'Overview';

  @override
  String get householdDetailTabAccounts => 'Accounts';

  @override
  String get householdDetailTabTransactions => 'Transactions';

  @override
  String householdDetailSubtitle(String code, int count) {
    return '$code • $count Accounts';
  }

  @override
  String get householdDetailTotalAum => 'Total AUM';

  @override
  String get householdDetailYtdPerformance => 'YTD Change';

  @override
  String get householdDetailAssetAllocation => 'Asset Allocation';

  @override
  String get householdDetailTopAccounts => 'Top Accounts';

  @override
  String householdDetailSeeAll(int count) {
    return 'See all ($count)';
  }

  @override
  String householdDetailAccountTypeLabel(String type) {
    return 'Account Type: $type';
  }

  @override
  String householdDetailAccountNumberLabel(String number) {
    return 'Account Number: $number';
  }

  @override
  String householdDetailAllAccountsHeader(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ALL ACCOUNTS ($count)',
      one: 'ALL ACCOUNT ($count)',
      zero: 'ALL ACCOUNT ($count)',
    );
    return '$_temp0';
  }

  @override
  String get householdDetailNoAccountsFound => 'No accounts found.';

  @override
  String get householdDetailAllTransactionsHeader => 'Last 30 Transactions';

  @override
  String get householdDetailNoTransactionsFound => 'No transactions found.';

  @override
  String get householdDetailTransactionsEmptySearch => 'No transactions match your search';

  @override
  String get householdDetailTransactionsSearchHint => 'Search';

  @override
  String get householdDetailToday => 'TODAY';
}

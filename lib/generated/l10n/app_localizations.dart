import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('es'), Locale('pt'), Locale('pt', 'BR')];

  /// App name displayed in OS dialogs and the app shell.
  ///
  /// In en, this message translates to:
  /// **'FinHub'**
  String get appName;

  /// Shown when a NetworkError is thrown (no connectivity).
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get errorNetwork;

  /// Shown when a ServerError (HTTP 5xx) is thrown. statusCode is passed as a string and may be empty when unknown.
  ///
  /// In en, this message translates to:
  /// **'Server error ({statusCode}). Please try again later.'**
  String errorServer(String statusCode);

  /// Shown when an UnauthorizedError (HTTP 401) is thrown.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get errorUnauthorized;

  /// Shown when a ForbiddenError (HTTP 403) is thrown.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action.'**
  String get errorForbidden;

  /// Shown when a NotFoundError (HTTP 404) is thrown.
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found.'**
  String get errorNotFound;

  /// Shown when an UnknownError is thrown with no server-provided message.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get errorUnknown;

  /// Inline error under an email field whose value isn't a valid address.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get commonInvalidEmail;

  /// Inline error under a mobile number field whose value isn't between the minimum and maximum digit count.
  ///
  /// In en, this message translates to:
  /// **'Must be between {min} and {max} digits.'**
  String commonInvalidMobileNumber(int min, int max);

  /// Inline error under a postal code field whose value isn't a plausible postal code.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid postal code.'**
  String get commonInvalidPostalCode;

  /// Inline error under a text field that has run past its character limit.
  ///
  /// In en, this message translates to:
  /// **'Maximum {max} characters allowed.'**
  String commonMaxLengthExceeded(int max);

  /// Generic required-field validation message. fieldName is the translated label of the field.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is required !'**
  String validationFieldRequired(String fieldName);

  /// Heading on the sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authLoginTitle;

  /// Subheading under the sign-in title.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your advisor workspace.'**
  String get authLoginSubtitle;

  /// Label of the sign-in identifier field.
  ///
  /// In en, this message translates to:
  /// **'Username or email'**
  String get authIdentifierLabel;

  /// Placeholder of the sign-in identifier field.
  ///
  /// In en, this message translates to:
  /// **'e.g. daniel.alvarez'**
  String get authIdentifierHint;

  /// Label of the password field.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// Placeholder of the password field.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authPasswordHint;

  /// Tooltip on the reveal-password button.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get authShowPassword;

  /// Tooltip on the hide-password button.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get authHidePassword;

  /// Submit button on the sign-in form.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authLoginButton;

  /// Ends the session and returns to the sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get authSignOutButton;

  /// Shown under both fields after a refused sign-in. Deliberately does not say which half was wrong.
  ///
  /// In en, this message translates to:
  /// **'That username or password is not correct.'**
  String get authInvalidCredentials;

  /// Validation error when the identifier field is empty.
  ///
  /// In en, this message translates to:
  /// **'Enter your username or email.'**
  String get validationIdentifierRequired;

  /// Validation error when the password field is empty.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get validationPasswordRequired;

  /// Title of the screen shown when a role check fails.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get accessDeniedTitle;

  /// Body of the access-denied screen.
  ///
  /// In en, this message translates to:
  /// **'Your role does not have access to this area.'**
  String get accessDeniedMessage;

  /// Returns the user to their landing tab.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get accessDeniedBackButton;

  /// Bottom navigation label for the home tab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom navigation label for the households tab.
  ///
  /// In en, this message translates to:
  /// **'Households'**
  String get navHouseholds;

  /// Bottom navigation label for the real-time tab.
  ///
  /// In en, this message translates to:
  /// **'Real-Time'**
  String get navRealTime;

  /// Bottom navigation label for the service-requests tab.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get navServiceRequests;

  /// Bottom navigation label for the leadership commissions tab.
  ///
  /// In en, this message translates to:
  /// **'Commissions'**
  String get navCommissions;

  /// Bottom navigation label for the market-insights tab.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get navInsights;

  /// Display name of the advisor role.
  ///
  /// In en, this message translates to:
  /// **'Advisor'**
  String get roleAdvisor;

  /// Display name of the leadership role.
  ///
  /// In en, this message translates to:
  /// **'Leadership'**
  String get roleLeadership;

  /// Placeholder shown in a bottom-nav tab whose feature has not shipped yet.
  ///
  /// In en, this message translates to:
  /// **'{tab} is on the way'**
  String comingSoonTitle(String tab);

  /// Body of the not-yet-built tab placeholder.
  ///
  /// In en, this message translates to:
  /// **'This tab is wired up and waiting for its screens.'**
  String get comingSoonMessage;

  /// Personalised greeting shown at the top of the dashboard.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String dashboardGreeting(String name);

  /// Dashboard subtitle naming the signed-in role and advisor id.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {role} · advisor {advisorId}'**
  String dashboardSessionSummary(String role, String advisorId);

  /// AppErrorWidget default description for AppErrorCode.emptyResponse.
  ///
  /// In en, this message translates to:
  /// **'There\'s no data to show right now.'**
  String get appErrorWidgetEmptyDescription;

  /// AppErrorWidget default title for AppErrorCode.emptyResponse.
  ///
  /// In en, this message translates to:
  /// **'Nothing Here Yet'**
  String get appErrorWidgetEmptyTitle;

  /// AppErrorWidget default description for AppErrorCode.forbidden.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action.'**
  String get appErrorWidgetForbiddenDescription;

  /// AppErrorWidget default title for AppErrorCode.forbidden.
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get appErrorWidgetForbiddenTitle;

  /// AppErrorWidget default description for AppErrorCode.maintenance.
  ///
  /// In en, this message translates to:
  /// **'This feature is temporarily unavailable while we make improvements.'**
  String get appErrorWidgetMaintenanceDescription;

  /// AppErrorWidget default title for AppErrorCode.maintenance.
  ///
  /// In en, this message translates to:
  /// **'Under Maintenance'**
  String get appErrorWidgetMaintenanceTitle;

  /// AppErrorWidget default description for AppErrorCode.networkError.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get appErrorWidgetNetworkDescription;

  /// AppErrorWidget default title for AppErrorCode.networkError.
  ///
  /// In en, this message translates to:
  /// **'No Connection'**
  String get appErrorWidgetNetworkTitle;

  /// AppErrorWidget default description for AppErrorCode.notFound.
  ///
  /// In en, this message translates to:
  /// **'The item you\'re looking for doesn\'t exist or has been moved.'**
  String get appErrorWidgetNotFoundDescription;

  /// AppErrorWidget default title for AppErrorCode.notFound.
  ///
  /// In en, this message translates to:
  /// **'Not Found'**
  String get appErrorWidgetNotFoundTitle;

  /// AppErrorWidget default description for AppErrorCode.serverError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our end. Please try again later.'**
  String get appErrorWidgetServerDescription;

  /// AppErrorWidget default title for AppErrorCode.serverError.
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get appErrorWidgetServerTitle;

  /// AppErrorWidget default description for AppErrorCode.serviceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The service is temporarily unavailable. Please try again shortly.'**
  String get appErrorWidgetServiceUnavailableDescription;

  /// AppErrorWidget default title for AppErrorCode.serviceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service Unavailable'**
  String get appErrorWidgetServiceUnavailableTitle;

  /// AppErrorWidget default description for AppErrorCode.timeout.
  ///
  /// In en, this message translates to:
  /// **'The request took too long to respond. Please try again.'**
  String get appErrorWidgetTimeoutDescription;

  /// AppErrorWidget default title for AppErrorCode.timeout.
  ///
  /// In en, this message translates to:
  /// **'Request Timed Out'**
  String get appErrorWidgetTimeoutTitle;

  /// AppErrorWidget default description for AppErrorCode.unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get appErrorWidgetUnauthorizedDescription;

  /// AppErrorWidget default title for AppErrorCode.unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Session Expired'**
  String get appErrorWidgetUnauthorizedTitle;

  /// AppErrorWidget default description for AppErrorCode.unknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get appErrorWidgetUnknownDescription;

  /// AppErrorWidget default title for AppErrorCode.unknown.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get appErrorWidgetUnknownTitle;

  /// AppErrorWidget default description for AppErrorCode.validationError.
  ///
  /// In en, this message translates to:
  /// **'Some of the information provided isn\'t valid. Please review and try again.'**
  String get appErrorWidgetValidationDescription;

  /// AppErrorWidget default title for AppErrorCode.validationError.
  ///
  /// In en, this message translates to:
  /// **'Invalid Information'**
  String get appErrorWidgetValidationTitle;

  /// Button label to pick a document for upload.
  ///
  /// In en, this message translates to:
  /// **'Browse File'**
  String get commonBrowseFile;

  /// No description provided for @commonButtonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonButtonCancel;

  /// Button that clears the currently selected value in a select sheet.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonButtonClear;

  /// No description provided for @commonButtonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonButtonOk;

  /// Retry action button label for error states.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get commonButtonRetry;

  /// Snackbar shown when a picked document is already attached to the same upload card.
  ///
  /// In en, this message translates to:
  /// **'A file with {fileName} already exists.'**
  String commonDuplicateFile(String fileName);

  /// Snackbar shown when the native file picker fails to open.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the file picker. Please try again.'**
  String get commonFilePickFailed;

  /// Snackbar shown when a picked document exceeds the upload size limit.
  ///
  /// In en, this message translates to:
  /// **'File must be smaller than {limit}.'**
  String commonFileTooLarge(String limit);

  /// Snackbar naming the rejected file extension(s) and the ones the card accepts. allowedCount drives the singular/plural wording of the second sentence.
  ///
  /// In en, this message translates to:
  /// **'File type with {rejected} is not allowed. Allowed file {allowedCount, plural, =1{type is} other{types are}} {allowed} !'**
  String commonFileTypeNotAllowed(String rejected, num allowedCount, String allowed);

  /// Default placeholder for any text input that has no more specific hint of its own.
  ///
  /// In en, this message translates to:
  /// **'Type...'**
  String get commonInputHint;

  /// Snackbar shown when a pick would exceed the maximum number of files the request accepts. States the ceiling itself rather than the slots still free, which is zero on the pick that hits the limit.
  ///
  /// In en, this message translates to:
  /// **'Max file count is {count}.'**
  String commonMaxFilesReached(int count);

  /// Empty-state message shown when a list has no items.
  ///
  /// In en, this message translates to:
  /// **'No Record Found!'**
  String get commonNoRecordFound;

  /// Icon button tooltip to remove an attached document.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// Tooltip and accessibility label for the clear button in any search box.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get commonSearchClear;

  /// Snackbar shown when a picked document's extension isn't accepted.
  ///
  /// In en, this message translates to:
  /// **'Unsupported file type. Please choose a supported file.'**
  String get commonUnsupportedFileType;

  /// Section header listing every document attached to an upload card.
  ///
  /// In en, this message translates to:
  /// **'Uploaded Documents'**
  String get commonUploadedDocumentsTitle;

  /// Chip label and trigger text showing how many options are selected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectNSelected(int count);

  /// Placeholder text in the search bar inside select bottom sheets.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get selectSearchHint;

  /// Overall request/task status chip: approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get statusApproved;

  /// Overall request/task status chip: completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// Overall request/task status chip: escalated to a higher review tier.
  ///
  /// In en, this message translates to:
  /// **'Escalated'**
  String get statusEscalated;

  /// Overall request/task status chip: in progress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// Overall request/task status chip: no status set.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get statusNone;

  /// Overall request/task status chip: rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// Footnote below every asset-allocation donut chart, explaining the rounding applied to values and percentages.
  ///
  /// In en, this message translates to:
  /// **'ⓘ Values are rounded to two decimal places and percentages to one decimal place.'**
  String get allocationChartRoundingNote;

  /// Label above the asset-allocation segmented bar on household and account cards.
  ///
  /// In en, this message translates to:
  /// **'Asset Allocation'**
  String get assetAllocationLabel;

  /// Full-length label for the Alternative Investment asset class.
  ///
  /// In en, this message translates to:
  /// **'Alternative Investment'**
  String get assetClassLongAlternativeInvestment;

  /// Full-length label for the Alternative Investments (plural) asset class.
  ///
  /// In en, this message translates to:
  /// **'Alternative Investments'**
  String get assetClassLongAlternativeInvestments;

  /// Full-length label for the Alts asset class.
  ///
  /// In en, this message translates to:
  /// **'Alternatives'**
  String get assetClassLongAlts;

  /// Full-length label for the Annuities asset class.
  ///
  /// In en, this message translates to:
  /// **'Annuities'**
  String get assetClassLongAnnuities;

  /// Full-length label for the Bonds asset class.
  ///
  /// In en, this message translates to:
  /// **'Bonds'**
  String get assetClassLongBonds;

  /// Full-length label for the Cash asset class.
  ///
  /// In en, this message translates to:
  /// **'Cash & Cash Equivalent'**
  String get assetClassLongCash;

  /// Full-length label for the Debentures asset class.
  ///
  /// In en, this message translates to:
  /// **'Debentures'**
  String get assetClassLongDebentures;

  /// Full-length label for the Derivatives asset class.
  ///
  /// In en, this message translates to:
  /// **'Derivatives'**
  String get assetClassLongDerivatives;

  /// Full-length label for the Equity asset class.
  ///
  /// In en, this message translates to:
  /// **'Equity'**
  String get assetClassLongEquity;

  /// Full-length label for the Fixed Income asset class.
  ///
  /// In en, this message translates to:
  /// **'Fixed Income'**
  String get assetClassLongFixedIncome;

  /// Full-length label for the Mutual Funds asset class.
  ///
  /// In en, this message translates to:
  /// **'Mutual Funds'**
  String get assetClassLongMutualFunds;

  /// Full-length label for the 'Others' asset class.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get assetClassLongOthers;

  /// Full-length label for the Real Estate asset class.
  ///
  /// In en, this message translates to:
  /// **'Real Estate'**
  String get assetClassLongRealEstate;

  /// Full-length label for the synthetic 'Rest' asset-class bucket (allocations collapsed beyond the top 3).
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get assetClassLongRest;

  /// Full-length label for the Structured Products asset class.
  ///
  /// In en, this message translates to:
  /// **'Structured Products'**
  String get assetClassLongStructuredProducts;

  /// Medium-length label for the Alternative Investment asset class.
  ///
  /// In en, this message translates to:
  /// **'Alt. Inv.'**
  String get assetClassMediumAlternativeInvestment;

  /// Medium-length label for the Alternative Investments (plural) asset class.
  ///
  /// In en, this message translates to:
  /// **'Alt. Invs.'**
  String get assetClassMediumAlternativeInvestments;

  /// Medium-length label for the Alts asset class.
  ///
  /// In en, this message translates to:
  /// **'Alt'**
  String get assetClassMediumAlts;

  /// Medium-length label for the Annuities asset class.
  ///
  /// In en, this message translates to:
  /// **'Annuities'**
  String get assetClassMediumAnnuities;

  /// Medium-length label for the Bonds asset class.
  ///
  /// In en, this message translates to:
  /// **'Bonds'**
  String get assetClassMediumBonds;

  /// Medium-length label for the Cash asset class.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get assetClassMediumCash;

  /// Medium-length label for the Debentures asset class.
  ///
  /// In en, this message translates to:
  /// **'Debentures'**
  String get assetClassMediumDebentures;

  /// Medium-length label for the Derivatives asset class.
  ///
  /// In en, this message translates to:
  /// **'Derivatives'**
  String get assetClassMediumDerivatives;

  /// Medium-length label for the Equity asset class.
  ///
  /// In en, this message translates to:
  /// **'Equity'**
  String get assetClassMediumEquity;

  /// Medium-length label for the Fixed Income asset class.
  ///
  /// In en, this message translates to:
  /// **'Fixed Inc.'**
  String get assetClassMediumFixedIncome;

  /// Medium-length label for the Mutual Funds asset class.
  ///
  /// In en, this message translates to:
  /// **'Mutual Funds'**
  String get assetClassMediumMutualFunds;

  /// Medium-length label for the 'Others' asset class.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get assetClassMediumOthers;

  /// Medium-length label for the Real Estate asset class.
  ///
  /// In en, this message translates to:
  /// **'Real Est.'**
  String get assetClassMediumRealEstate;

  /// Medium-length label for the synthetic 'Rest' asset-class bucket (allocations collapsed beyond the top 3).
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get assetClassMediumRest;

  /// Medium-length label for the Structured Products asset class.
  ///
  /// In en, this message translates to:
  /// **'Str. Prod.'**
  String get assetClassMediumStructuredProducts;

  /// Short abbreviation for the Alternative Investment asset class.
  ///
  /// In en, this message translates to:
  /// **'Alt. Invest.'**
  String get assetClassShortAlternativeInvestment;

  /// Short abbreviation for the Alts asset class.
  ///
  /// In en, this message translates to:
  /// **'Alt'**
  String get assetClassShortAlts;

  /// Short abbreviation for the Annuities asset class.
  ///
  /// In en, this message translates to:
  /// **'Annty.'**
  String get assetClassShortAnnuities;

  /// Short abbreviation for the Bonds asset class.
  ///
  /// In en, this message translates to:
  /// **'Bonds'**
  String get assetClassShortBonds;

  /// Short abbreviation for the Cash asset class.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get assetClassShortCash;

  /// Short abbreviation for the Debentures asset class.
  ///
  /// In en, this message translates to:
  /// **'Dbnt'**
  String get assetClassShortDebentures;

  /// Short abbreviation for the Derivatives asset class.
  ///
  /// In en, this message translates to:
  /// **'Deriv.'**
  String get assetClassShortDerivatives;

  /// Short abbreviation for the Equity asset class.
  ///
  /// In en, this message translates to:
  /// **'Eq'**
  String get assetClassShortEquity;

  /// Short abbreviation for the Fixed Income asset class.
  ///
  /// In en, this message translates to:
  /// **'FI'**
  String get assetClassShortFixedIncome;

  /// Short abbreviation for the Mutual Funds asset class.
  ///
  /// In en, this message translates to:
  /// **'MF'**
  String get assetClassShortMutualFunds;

  /// Short abbreviation for the 'Others' asset class.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get assetClassShortOthers;

  /// Short abbreviation for the Real Estate asset class.
  ///
  /// In en, this message translates to:
  /// **'RE'**
  String get assetClassShortRealEstate;

  /// Short abbreviation for the synthetic 'Rest' asset-class bucket (allocations collapsed beyond the top 3).
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get assetClassShortRest;

  /// Short abbreviation for the Structured Products asset class.
  ///
  /// In en, this message translates to:
  /// **'Str. Prod.'**
  String get assetClassShortStructuredProducts;

  /// No description provided for @commonButtonChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get commonButtonChange;

  /// Heading label displayed at the top of the sort options popup menu.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get commonSortBy;

  /// Separator between the filter chip label and the drilled-into month name in the change row breadcrumb, e.g. "YTD > Mar".
  ///
  /// In en, this message translates to:
  /// **' > '**
  String get historyChartBreadcrumbSeparator;

  /// Separator between the amount, filter label, and mode label in the commission chart's change row, e.g. "$3,402 • YTD • Absolute" — used in both value modes.
  ///
  /// In en, this message translates to:
  /// **' • '**
  String get historyChartChangeRowSeparator;

  /// Footnote below the commission chart, showing the most recent data point's date and the pending-validation disclaimer.
  ///
  /// In en, this message translates to:
  /// **'ⓘ This chart is based on data as of {date}. YTD commission amounts are tentative and subject to pending validation.'**
  String historyChartCommissionDataAsOf(String date);

  /// Footnote below the AUM and commission charts, showing the most recent data point's date.
  ///
  /// In en, this message translates to:
  /// **'ⓘ This chart is based on data as of {date}.'**
  String historyChartDataAsOf(String date);

  /// Risk-profile badge label for the lowest tier of the Conservative to Significant Risk scale.
  ///
  /// In en, this message translates to:
  /// **'Conservative'**
  String get riskProfileConservative;

  /// Risk-profile badge label for the Growth mandate, which sits outside both severity scales.
  ///
  /// In en, this message translates to:
  /// **'Growth'**
  String get riskProfileGrowth;

  /// Risk-profile badge label for the second-highest tier of the Low/Moderate/High/Speculative scale.
  ///
  /// In en, this message translates to:
  /// **'High Risk'**
  String get riskProfileHighRisk;

  /// Risk-profile badge label for the lowest tier of the Low/Moderate/High/Speculative scale.
  ///
  /// In en, this message translates to:
  /// **'Low Risk'**
  String get riskProfileLowRisk;

  /// Risk-profile badge label for the middle tier of the Conservative to Significant Risk scale.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get riskProfileModerate;

  /// Risk-profile badge label for the middle tier of the Low/Moderate/High/Speculative scale.
  ///
  /// In en, this message translates to:
  /// **'Moderate Risk'**
  String get riskProfileModerateRisk;

  /// Risk-profile badge label for the second-highest tier of the Conservative to Significant Risk scale.
  ///
  /// In en, this message translates to:
  /// **'Moderately Aggressive'**
  String get riskProfileModeratelyAggressive;

  /// Risk-profile badge label for the second-lowest tier of the Conservative to Significant Risk scale.
  ///
  /// In en, this message translates to:
  /// **'Moderately Conservative'**
  String get riskProfileModeratelyConservative;

  /// Risk-profile badge label for the highest tier of the Conservative to Significant Risk scale.
  ///
  /// In en, this message translates to:
  /// **'Significant Risk'**
  String get riskProfileSignificantRisk;

  /// Risk-profile badge label for the highest tier of the Low/Moderate/High/Speculative scale.
  ///
  /// In en, this message translates to:
  /// **'Speculative'**
  String get riskProfileSpeculative;

  /// Section heading for the asset allocation donut chart on the dashboard.
  ///
  /// In en, this message translates to:
  /// **'Asset Allocation'**
  String get dashboardAssetAllocation;

  /// AUM column label on household cards.
  ///
  /// In en, this message translates to:
  /// **'AUM'**
  String get dashboardAumLabel;

  /// De-emphasized suffix appended after the top households section heading, indicating the ranking metric.
  ///
  /// In en, this message translates to:
  /// **'( By AUM )'**
  String get dashboardByAum;

  /// Period label shown next to the Total AUM / Total Commissions hero value on the dashboard.
  ///
  /// In en, this message translates to:
  /// **'YTD'**
  String get dashboardHeroYtdLabel;

  /// Household code label shown on household cards.
  ///
  /// In en, this message translates to:
  /// **'Household ID: #{code}'**
  String dashboardHouseholdIdLabel(String code);

  /// Quick action label for account maintenance.
  ///
  /// In en, this message translates to:
  /// **'Account Maintenance'**
  String get dashboardQuickActionAccountMaintenance;

  /// Quick action label for asset movement.
  ///
  /// In en, this message translates to:
  /// **'Asset Movement'**
  String get dashboardQuickActionAssetMovement;

  /// Quick action label for client search.
  ///
  /// In en, this message translates to:
  /// **'Client Search'**
  String get dashboardQuickActionClientSearch;

  /// Quick action label for opening Investor Portal in an external browser.
  ///
  /// In en, this message translates to:
  /// **'Investor Portal'**
  String get dashboardQuickActionInvestorPortal;

  /// Error shown when the Investor Portal external link fails to open.
  ///
  /// In en, this message translates to:
  /// **'Could not open the Investor Portal. Please try again.'**
  String get dashboardQuickActionInvestorPortalLaunchFailedMessage;

  /// Quick action label for meeting notes.
  ///
  /// In en, this message translates to:
  /// **'Meeting Notes'**
  String get dashboardQuickActionMeetingNotes;

  /// Quick action label for my commissions.
  ///
  /// In en, this message translates to:
  /// **'Commissions'**
  String get dashboardQuickActionMyCommissions;

  /// Quick action label for online access.
  ///
  /// In en, this message translates to:
  /// **'Online Access'**
  String get dashboardQuickActionOnlineAccess;

  /// Quick action label for tasks dashboard.
  ///
  /// In en, this message translates to:
  /// **'Tasks Dashboard'**
  String get dashboardQuickActionTasksDashboard;

  /// Section heading for the recent transactions list on the dashboard.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get dashboardRecentTransactions;

  /// Qualifier appended to the recent transactions heading, showing the snapshot date of the newest transaction.
  ///
  /// In en, this message translates to:
  /// **'( As of {date} )'**
  String dashboardRecentTransactionsAsOf(String date);

  /// Section heading for the top-5 household cards on the dashboard. Shown when there are 5 or more households.
  ///
  /// In en, this message translates to:
  /// **'Top 5 Households'**
  String get dashboardTopHouseholds;

  /// Section heading for the top household cards on the dashboard. Shown instead of dashboardTopHouseholds when there are fewer than 5 households, since 'Top 5' would overstate the count.
  ///
  /// In en, this message translates to:
  /// **'Top Households'**
  String get dashboardTopHouseholdsShort;

  /// Eyebrow label above the Total AUM hero value on the dashboard.
  ///
  /// In en, this message translates to:
  /// **'TOTAL AUM'**
  String get dashboardTotalAum;

  /// Eyebrow label above the Total Commission hero value on the dashboard.
  ///
  /// In en, this message translates to:
  /// **'TOTAL COMMISSION'**
  String get dashboardTotalCommissions;

  /// Relative date label for transactions that occurred today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dashboardTransactionDateToday;

  /// Relative date label for transactions that occurred yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dashboardTransactionDateYesterday;

  /// Link button label to view all households.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get dashboardViewAll;

  /// Link button label at the bottom of the recent transactions section.
  ///
  /// In en, this message translates to:
  /// **'View Transaction History'**
  String get dashboardViewTransactionHistory;

  /// YTD Change column label on household cards.
  ///
  /// In en, this message translates to:
  /// **'YTD Change'**
  String get dashboardYtdChangeLabel;

  /// Message shown in place of the chart when the selected filter window has no data points.
  ///
  /// In en, this message translates to:
  /// **'No data available for this period.'**
  String get historyChartNoData;

  /// Spelled-out name of the 1M filter window, shown in the chart's change row (the chip itself still reads "1M").
  ///
  /// In en, this message translates to:
  /// **'Current Month'**
  String get historyChartRangeCurrentMonth;

  /// Spelled-out name of the 6M filter window, shown in the chart's change row (the chip itself still reads "6M").
  ///
  /// In en, this message translates to:
  /// **'Past 6M'**
  String get historyChartRangePastSixMonths;

  /// Spelled-out name of the 3M filter window, shown in the chart's change row (the chip itself still reads "3M").
  ///
  /// In en, this message translates to:
  /// **'Past 3M'**
  String get historyChartRangePastThreeMonths;

  /// Name of the YTD filter window, shown in the chart's change row.
  ///
  /// In en, this message translates to:
  /// **'YTD'**
  String get historyChartRangeYtd;

  /// Sentence shown in the commission chart's touch tooltip — the only chart that still shows one.
  ///
  /// In en, this message translates to:
  /// **'Commission of Week{week} {date} is {value}'**
  String historyChartWeekTooltip(int week, String date, String value);

  /// Placeholder transaction-type label shown when a transaction has no type.
  ///
  /// In en, this message translates to:
  /// **'Non-Trade'**
  String get transactionTypeNonTrade;

  /// Badge label for a BUY transaction type on the transaction history card.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get viewTransactionsTypeBuy;

  /// Badge label for a SELL transaction type on the transaction history card.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get viewTransactionsTypeSell;

  /// AppBar title for the full-screen transaction history screen.
  ///
  /// In en, this message translates to:
  /// **'Transactions History'**
  String get viewTransactionsTitle;

  /// Header label above the accounts list showing the total count. Pluralised only when the count is greater than 1.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{ALL ACCOUNT ({count})} =1{ALL ACCOUNT ({count})} other{ALL ACCOUNTS ({count})}}'**
  String accountsAllLabel(int count);

  /// Custodian label shown on an account card.
  ///
  /// In en, this message translates to:
  /// **'Custodian : {name}'**
  String accountsCustodianLabel(String name);

  /// Filter chip label to show all accounts (no type filter).
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get accountsFilterAll;

  /// Filter chip label to show only accounts linked to a household.
  ///
  /// In en, this message translates to:
  /// **'Household-linked'**
  String get accountsFilterHouseholdLinked;

  /// Filter chip label to show only standalone accounts (not linked to any household).
  ///
  /// In en, this message translates to:
  /// **'Standalone'**
  String get accountsFilterStandalone;

  /// Account Number label shown on an account card.
  ///
  /// In en, this message translates to:
  /// **'Account Number : {number}'**
  String accountsIdLabel(String number);

  /// Inline error shown when fetching the next account page fails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load more accounts'**
  String get accountsPaginationError;

  /// Short label for the name sort field.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get commonName;

  /// Link button label for asset allocation details.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get dashboardViewDetails;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

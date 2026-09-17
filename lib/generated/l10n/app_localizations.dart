import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

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

  /// Bottom navigation label for the leadership commissions tab.
  ///
  /// In en, this message translates to:
  /// **'Commissions'**
  String get navCommissions;

  /// Bottom navigation label for the advisor markets tab.
  ///
  /// In en, this message translates to:
  /// **'Markets'**
  String get navMarkets;

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

  /// Account number label on the account detail top card.
  ///
  /// In en, this message translates to:
  /// **'Account: {number}'**
  String accountDetailAccountNumberLabel(String number);

  /// Header showing total position count on the Positions tab. Pluralised only when the count is greater than 1.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{ALL HOLDING ({count})} =1{ALL HOLDING ({count})} other{ALL HOLDINGS ({count})}}'**
  String accountDetailAllHoldings(int count);

  /// Header above the transaction list on the Transactions tab.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Transactions'**
  String get accountDetailAllTransactionsHeader;

  /// Section heading for the asset allocation donut chart on the account detail screen.
  ///
  /// In en, this message translates to:
  /// **'Asset Allocation'**
  String get accountDetailAssetAllocation;

  /// Section header for the AUM trend chart in the Overview tab.
  ///
  /// In en, this message translates to:
  /// **'AUM Trend'**
  String get accountDetailAumTrend;

  /// Empty-state message shown in place of the AUM trend chart when no history is available.
  ///
  /// In en, this message translates to:
  /// **'No AUM trend data yet'**
  String get accountDetailAumTrendEmpty;

  /// Period label shown next to the hero value on the account detail and household detail top cards.
  ///
  /// In en, this message translates to:
  /// **'YTD'**
  String get accountDetailHeroYtdLabel;

  /// Section heading for the latest activity list on the Overview tab.
  ///
  /// In en, this message translates to:
  /// **'Latest Activity'**
  String get accountDetailLatestActivity;

  /// Section heading for the holdings/positions table on the account detail screen.
  ///
  /// In en, this message translates to:
  /// **'Positions'**
  String get accountDetailPositions;

  /// Empty-state message on the Positions tab when the selected asset-class filter matches no holdings.
  ///
  /// In en, this message translates to:
  /// **'No holdings in this asset class'**
  String get accountDetailPositionsEmptyFilter;

  /// Filter chip label on the Positions tab that clears the asset-class filter.
  ///
  /// In en, this message translates to:
  /// **'All Asset Classes'**
  String get accountDetailPositionsFilterAll;

  /// Label preceding the risk-profile badge on the account detail top card.
  ///
  /// In en, this message translates to:
  /// **'Risk Profile:'**
  String get accountDetailRiskProfileLabel;

  /// AppBar label on the account detail screen.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get accountDetailScreenTitle;

  /// Label for the Overview tab on the account detail screen.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get accountDetailTabOverview;

  /// Label for the Transactions tab on the account detail screen.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get accountDetailTabTransactions;

  /// Date group header label for today's transactions on the Transactions tab.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get accountDetailToday;

  /// Empty-state message on the Transactions tab when a search query returns no results.
  ///
  /// In en, this message translates to:
  /// **'No transactions match your search'**
  String get accountDetailTransactionsEmptySearch;

  /// Placeholder text in the search field on the Transactions tab.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get accountDetailTransactionsSearchHint;

  /// Short popup label for amount sort option.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get commonAmount;

  /// Label for a transaction's total amount.
  ///
  /// In en, this message translates to:
  /// **'Transaction Amount'**
  String get commonTrnxAmount;

  /// Short popup label for date sort option.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get commonDate;

  /// Short label for the market value sort field.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get commonValue;

  /// Filter chip label to show every transaction type.
  ///
  /// In en, this message translates to:
  /// **'All Transactions'**
  String get transactionFilterAllTransactions;

  /// Filter chip label to show only non-trade transactions (everything other than BUY and SELL).
  ///
  /// In en, this message translates to:
  /// **'Non-Trade'**
  String get transactionFilterNonTrade;

  /// Filter chip label to show only trades (BUY and SELL transactions).
  ///
  /// In en, this message translates to:
  /// **'Trade'**
  String get transactionFilterTrade;

  /// Unit price label on a transaction card (no share suffix).
  ///
  /// In en, this message translates to:
  /// **'Price: {price}'**
  String transactionPrice(String price);

  /// Asset class label on a transaction history card.
  ///
  /// In en, this message translates to:
  /// **'Asset Class: {assetClass}'**
  String viewTransactionsAssetClass(String assetClass);

  /// Description label on a transaction card, shown in place of the type badge when the transaction has no type.
  ///
  /// In en, this message translates to:
  /// **'Description: {description}'**
  String viewTransactionsDescription(String description);

  /// Close button label on the transaction detail bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get viewTransactionsDetailClose;

  /// Transaction amount field label in the transaction detail bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Transaction Amount'**
  String get viewTransactionsDetailLabelAmount;

  /// Asset class field label in the transaction detail bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Asset Class'**
  String get viewTransactionsDetailLabelAssetClass;

  /// Transaction date field label in the transaction detail bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Transaction Date'**
  String get viewTransactionsDetailLabelDate;

  /// Row label for the transaction description in the transaction detail bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get viewTransactionsDetailLabelDescription;

  /// Per-unit share price field label in the transaction detail bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Price Per Unit'**
  String get viewTransactionsDetailLabelPricePerUnit;

  /// Quantity field label in the transaction detail bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get viewTransactionsDetailLabelQuantity;

  /// Section header for the additional details fields in the transaction detail bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Additional Details'**
  String get viewTransactionsDetailLabelTradeDetails;

  /// Trade ID field label in the transaction detail bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Trade ID'**
  String get viewTransactionsDetailLabelTradeId;

  /// Title of the transaction detail bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get viewTransactionsDetailTitle;

  /// Quantity label on a transaction history card.
  ///
  /// In en, this message translates to:
  /// **'Quantity: {qty}'**
  String viewTransactionsQuantity(double qty);

  /// Abbreviated form of viewTransactionsQuantity, used only when the full wording would wrap to a second line.
  ///
  /// In en, this message translates to:
  /// **'Qty: {qty}'**
  String viewTransactionsQuantityShort(double qty);

  /// View Details button label on a transaction history card.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewTransactionsViewDetails;

  /// Empty-state message on the transaction history screen when the active filter or search matches no loaded transactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions match this filter'**
  String get viewTransactionsEmpty;

  /// Inline error message shown below the transaction list when a pagination request fails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load more transactions'**
  String get viewTransactionsPaginationError;

  /// Placeholder text in the search field on the transaction history screen.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get viewTransactionsSearchHint;

  /// Header label on the transaction history screen.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Transactions'**
  String get viewTransactionsAllHeader;

  /// Placeholder text in the search field when the Accounts tab is active.
  ///
  /// In en, this message translates to:
  /// **'Search by account...'**
  String get accountsSearchHint;

  /// Placeholder text in the search field when the Households tab is active.
  ///
  /// In en, this message translates to:
  /// **'Search by household...'**
  String get householdsSearchHint;

  /// Screen title for the Households feature.
  ///
  /// In en, this message translates to:
  /// **'Households'**
  String get householdsTitle;

  /// Label for the Accounts pill tab on the Households shell screen.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get householdsAccountsTabLabel;

  /// Header label above the household list showing the total count. Pluralised only when the count is greater than 1.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{ALL HOUSEHOLD ({count})} =1{ALL HOUSEHOLD ({count})} other{ALL HOUSEHOLDS ({count})}}'**
  String householdsAllLabel(int count);

  /// Sub-heading on a household card showing the household identifier.
  ///
  /// In en, this message translates to:
  /// **'ID: {code}'**
  String householdsHouseholdIdLabel(String code);

  /// Total account count shown on a household card.
  ///
  /// In en, this message translates to:
  /// **'{count} Accounts'**
  String householdsTotalAccounts(int count);

  /// Inline error shown when fetching the next household page fails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load more households'**
  String get householdsPaginationError;

  /// AppBar title on the household detailed view screen.
  ///
  /// In en, this message translates to:
  /// **'Household Details'**
  String get householdDetailScreenTitle;

  /// Overview tab label on the household detail screen.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get householdDetailTabOverview;

  /// Accounts tab label on the household detail screen.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get householdDetailTabAccounts;

  /// Transactions tab label on the household detail screen.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get householdDetailTabTransactions;

  /// Sub-heading on the household detail top card showing code and account count.
  ///
  /// In en, this message translates to:
  /// **'{code} • {count} Accounts'**
  String householdDetailSubtitle(String code, int count);

  /// Eyebrow label above the total AUM value on the household detail top card.
  ///
  /// In en, this message translates to:
  /// **'Total AUM'**
  String get householdDetailTotalAum;

  /// Label next to the YTD return figure on the household detail top card.
  ///
  /// In en, this message translates to:
  /// **'YTD Change'**
  String get householdDetailYtdPerformance;

  /// Section heading for the asset allocation donut on the overview tab.
  ///
  /// In en, this message translates to:
  /// **'Asset Allocation'**
  String get householdDetailAssetAllocation;

  /// Section heading for the top accounts list on the overview tab.
  ///
  /// In en, this message translates to:
  /// **'Top Accounts'**
  String get householdDetailTopAccounts;

  /// Link to see all top accounts. {count} is the total number of accounts.
  ///
  /// In en, this message translates to:
  /// **'See all ({count})'**
  String householdDetailSeeAll(int count);

  /// Account type label on the top accounts row in the household overview tab.
  ///
  /// In en, this message translates to:
  /// **'Account Type: {type}'**
  String householdDetailAccountTypeLabel(String type);

  /// Short account number label on the top accounts card in the overview tab.
  ///
  /// In en, this message translates to:
  /// **'Account Number: {number}'**
  String householdDetailAccountNumberLabel(String number);

  /// Header above the accounts list showing the total count. Pluralised only when the count is greater than 1.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{ALL ACCOUNT ({count})} =1{ALL ACCOUNT ({count})} other{ALL ACCOUNTS ({count})}}'**
  String householdDetailAllAccountsHeader(int count);

  /// Empty-state when no accounts match the search query.
  ///
  /// In en, this message translates to:
  /// **'No accounts found.'**
  String get householdDetailNoAccountsFound;

  /// Header label above the transaction list on the household detail screen.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Transactions'**
  String get householdDetailAllTransactionsHeader;

  /// Empty-state when no transactions match the search.
  ///
  /// In en, this message translates to:
  /// **'No transactions found.'**
  String get householdDetailNoTransactionsFound;

  /// Empty-state message on the Transactions tab when a search query returns no results.
  ///
  /// In en, this message translates to:
  /// **'No transactions match your search'**
  String get householdDetailTransactionsEmptySearch;

  /// Placeholder in the transactions search field on the household detail screen.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get householdDetailTransactionsSearchHint;

  /// Date group header for today's transactions.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get householdDetailToday;

  /// No description provided for @commonButtonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonButtonContinue;

  /// Heading on the real-time account selector screen.
  ///
  /// In en, this message translates to:
  /// **'Select a Financial Account'**
  String get realTimeSelectAccountTitle;

  /// Subtitle beneath the heading on the real-time account selector screen.
  ///
  /// In en, this message translates to:
  /// **'Access live positions and transactions for an account. Data is retrieved directly from the source and exists for Pershing only after account selection.'**
  String get realTimeSelectAccountSubtitle;

  /// Field label above the account dropdown on the real-time screen.
  ///
  /// In en, this message translates to:
  /// **'Select Account Number'**
  String get realTimeSelectAccountLabel;

  /// Placeholder text in the account selector dropdown.
  ///
  /// In en, this message translates to:
  /// **'Select Account Number'**
  String get realTimeSelectAccountHint;

  /// Title shown in the app bar of the real-time detailed view screen.
  ///
  /// In en, this message translates to:
  /// **'Real-Time Detailed View'**
  String get realTimeDetailedViewTitle;

  /// Label for the Positions tab on the real-time detailed view screen.
  ///
  /// In en, this message translates to:
  /// **'Positions'**
  String get realTimePositionsTab;

  /// Label for the Transactions tab on the real-time detailed view screen.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get realTimeTransactionsTab;

  /// Button label to switch the selected account on the real-time detailed view.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get realTimeChangeAccount;

  /// Footnote noting real-time figures lag by 15 minutes.
  ///
  /// In en, this message translates to:
  /// **'Market feed for real-time positions and transactions is delayed by 15 min.'**
  String get realTimeDelayNote;

  /// CUSIP label shown above each position card.
  ///
  /// In en, this message translates to:
  /// **'CUSIP IDENTIFIER: {cusip}'**
  String realTimeCusipIdentifier(String cusip);

  /// Label above the intraday market price value on a position card.
  ///
  /// In en, this message translates to:
  /// **'MARKET PRICE'**
  String get realTimeMarketPriceLabel;

  /// Label above the prior-session closing price value on a position card.
  ///
  /// In en, this message translates to:
  /// **'CLOSE PRICE'**
  String get realTimeClosePriceLabel;

  /// Empty-state message when no positions match the search query.
  ///
  /// In en, this message translates to:
  /// **'No positions found.'**
  String get realTimeNoPositions;

  /// Empty-state message when no transactions match the search query.
  ///
  /// In en, this message translates to:
  /// **'No transactions found.'**
  String get realTimeNoTransactions;

  /// Placeholder in the positions search field on the real-time detailed view.
  ///
  /// In en, this message translates to:
  /// **'Search positions...'**
  String get realTimeSearchPositions;

  /// Placeholder in the transactions search field on the real-time detailed view.
  ///
  /// In en, this message translates to:
  /// **'Search transactions...'**
  String get realTimeSearchTransactions;

  /// Section heading for the holdings list on the positions tab. Pluralised only when the count is greater than 1.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{ALL HOLDING ({count})} =1{ALL HOLDING ({count})} other{ALL HOLDINGS ({count})}}'**
  String realTimeAllHoldings(int count);

  /// Header above the real-time activity list, with the number of transactions shown.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{All Transaction} =1{All Transaction} other{All Transactions}} ({count})'**
  String realTimeAllTransactionsHeader(int count);

  /// Label above the activity description value on a transaction card.
  ///
  /// In en, this message translates to:
  /// **'ACTIVITY DESCRIPTION'**
  String get realTimeAccountActivityLabel;

  /// Title for the My Commissions screen.
  ///
  /// In en, this message translates to:
  /// **'Commissions'**
  String get myCommissionsTitle;

  /// Heading for the commission summary card.
  ///
  /// In en, this message translates to:
  /// **'Total Commission'**
  String get myCommissionsTotalCommissions;

  /// Period label shown next to the hero value on the My Commissions trend card.
  ///
  /// In en, this message translates to:
  /// **'YTD'**
  String get myCommissionsHeroYtdLabel;

  /// Overview tab label on the My Commissions screen.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get myCommissionsTabOverview;

  /// Details tab label on the My Commissions screen.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get myCommissionsTabDetails;

  /// Placeholder text in the account search field.
  ///
  /// In en, this message translates to:
  /// **'Search Account Name or Number...'**
  String get myCommissionsSearchHint;

  /// Inline error shown when fetching the next commission transactions page fails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load more transactions'**
  String get myCommissionsPaginationError;

  /// Label for the commission earned amount in a commission card.
  ///
  /// In en, this message translates to:
  /// **'COMMISSION EARNED'**
  String get myCommissionsCommissionEarned;

  /// Account number label in a commission transaction card.
  ///
  /// In en, this message translates to:
  /// **'Account Number: {number}'**
  String myCommissionsAccountNumber(String number);

  /// Short account number label on the top accounts card in the overview tab.
  ///
  /// In en, this message translates to:
  /// **'Account Number: {number}'**
  String myCommissionsAccountLabel(String number);

  /// Link label to view commission transaction details.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get myCommissionsViewDetails;

  /// Section heading for the top-5 accounts list on the overview tab, shown when there are 5 or more accounts.
  ///
  /// In en, this message translates to:
  /// **'Top 5 Accounts'**
  String get myCommissionsTopAccounts;

  /// Section heading for the top accounts list when there are 2-4 accounts.
  ///
  /// In en, this message translates to:
  /// **'Top Accounts'**
  String get myCommissionsTopAccountsPlural;

  /// Section heading for the top accounts list when there is exactly 1 account.
  ///
  /// In en, this message translates to:
  /// **'Top Account'**
  String get myCommissionsTopAccountSingular;

  /// Label for the households KPI tile on the overview tab.
  ///
  /// In en, this message translates to:
  /// **'Households'**
  String get myCommissionsHouseholds;

  /// Label for the accounts KPI tile on the overview tab.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get myCommissionsAccountsLabel;

  /// Sublabel shown below the count on the KPI metric tiles.
  ///
  /// In en, this message translates to:
  /// **'Contributing'**
  String get myCommissionsContributing;

  /// Uppercase label below the commission amount on top-account cards.
  ///
  /// In en, this message translates to:
  /// **'TOTAL COMMISSION'**
  String get myCommissionsTotalCommission;

  /// AppBar title on the commission detailed view screen.
  ///
  /// In en, this message translates to:
  /// **'Commission Details'**
  String get commissionDetailedViewTitle;

  /// Placeholder in the transaction search field on the detailed view screen.
  ///
  /// In en, this message translates to:
  /// **'Search Transactions...'**
  String get commissionDetailedViewSearchHint;

  /// Quantity and unit price shown after the transaction type on a commission transaction card.
  ///
  /// In en, this message translates to:
  /// **'{qty} Shares @ {price}'**
  String commissionDetailedViewSharesAtPrice(String qty, String price);

  /// Footer label showing the trade date on a detail transaction card.
  ///
  /// In en, this message translates to:
  /// **'Trade Date: {date}'**
  String commissionDetailedViewTradeDateLabel(String date);

  /// Footer label showing the trade ID on a detail transaction card.
  ///
  /// In en, this message translates to:
  /// **'Trade ID: {id}'**
  String commissionDetailedViewTxnIdLabel(String id);

  /// Label above the commission amount on the detail header card.
  ///
  /// In en, this message translates to:
  /// **'Total Commission'**
  String get commissionDetailedViewTotalCommission;

  /// Label shown next to the total commission hero value on the detail header card.
  ///
  /// In en, this message translates to:
  /// **'YTD'**
  String get commissionDetailedViewYtdLabel;

  /// Header label above the transaction list on the commission detailed view, next to the sort control.
  ///
  /// In en, this message translates to:
  /// **'All Commissions'**
  String get commissionDetailedViewAllCommissions;

  /// Sort option label for sorting the commission detailed view list by commission earned.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get commissionDetailedViewSortCommission;

  /// Sort option label for sorting the commission detailed view list by transaction amount.
  ///
  /// In en, this message translates to:
  /// **'Trnx. Amt'**
  String get commissionDetailedViewSortTransactionAmount;

  /// Empty-state message when no transactions match the search on the detailed view.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get commissionDetailedViewNoTransactions;

  /// App bar title for the Task Dashboard screen.
  ///
  /// In en, this message translates to:
  /// **'Task Dashboard'**
  String get taskDashboardTitle;

  /// Placeholder text for the Task Dashboard search field.
  ///
  /// In en, this message translates to:
  /// **'Search tasks'**
  String get taskDashboardSearchHint;

  /// Filter chip label showing every task category.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get taskDashboardFilterAll;

  /// Filter chip label showing only overdue tasks.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get taskDashboardFilterOverdue;

  /// Filter chip label showing only tasks due today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get taskDashboardFilterToday;

  /// Filter chip label showing only tasks due in the future.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get taskDashboardFilterUpcoming;

  /// Filter chip label showing only closed tasks.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get taskDashboardFilterClosed;

  /// Heading above the task list on the All filter, with the visible task count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{All Task ({count})} =1{All Task ({count})} other{All Tasks ({count})}}'**
  String taskDashboardHeadingAll(int count);

  /// Heading above the task list on the Overdue filter, with the visible task count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Overdue Task ({count})} =1{Overdue Task ({count})} other{Overdue Tasks ({count})}}'**
  String taskDashboardHeadingOverdue(int count);

  /// Heading above the task list on the Today filter, with the visible task count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Today\'s Task ({count})} =1{Today\'s Task ({count})} other{Today\'s Tasks ({count})}}'**
  String taskDashboardHeadingToday(int count);

  /// Heading above the task list on the Upcoming filter, with the visible task count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Upcoming Task ({count})} =1{Upcoming Task ({count})} other{Upcoming Tasks ({count})}}'**
  String taskDashboardHeadingUpcoming(int count);

  /// Heading above the task list on the Closed filter, with the server's total closed-task count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Closed Task ({count})} =1{Closed Task ({count})} other{Closed Tasks ({count})}}'**
  String taskDashboardHeadingClosed(int count);

  /// Uppercase section label grouping overdue tasks in the All filter.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get taskDashboardSectionOverdue;

  /// Uppercase section label grouping today's tasks in the All filter.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get taskDashboardSectionToday;

  /// Uppercase section label grouping upcoming tasks in the All filter.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get taskDashboardSectionUpcoming;

  /// Uppercase section label grouping open tasks with no due date.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get taskDashboardSectionOpen;

  /// Uppercase section label grouping closed tasks in the All filter.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get taskDashboardSectionClosed;

  /// Empty-state message when a search query matches no tasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks match your search.'**
  String get taskDashboardEmptySearch;

  /// Empty-state message when the active filter has no tasks at all.
  ///
  /// In en, this message translates to:
  /// **'No tasks to show right now.'**
  String get taskDashboardNoTasks;

  /// Inline error shown when fetching the next closed-task page fails.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load more tasks.'**
  String get taskDashboardPaginationError;

  /// Trailing link on a task row that opens the task detail sheet.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get taskDashboardView;

  /// Live 'last updated' label shown under a minute after the dashboard's most recent fetch.
  ///
  /// In en, this message translates to:
  /// **'Updated just now'**
  String get taskDashboardUpdatedJustNow;

  /// Live 'last updated' label exactly one minute after the dashboard's most recent fetch.
  ///
  /// In en, this message translates to:
  /// **'Updated 1 min ago'**
  String get taskDashboardUpdatedMinutesAgoSingular;

  /// Live 'last updated' label for two or more minutes since the dashboard's most recent fetch.
  ///
  /// In en, this message translates to:
  /// **'Updated {count} mins ago'**
  String taskDashboardUpdatedMinutesAgo(int count);

  /// Live 'last updated' label exactly one hour after the dashboard's most recent fetch.
  ///
  /// In en, this message translates to:
  /// **'Updated 1 hr ago'**
  String get taskDashboardUpdatedHoursAgoSingular;

  /// Live 'last updated' label for two or more hours since the dashboard's most recent fetch.
  ///
  /// In en, this message translates to:
  /// **'Updated {count} hrs ago'**
  String taskDashboardUpdatedHoursAgo(int count);

  /// Live 'last updated' label exactly one day after the dashboard's most recent fetch.
  ///
  /// In en, this message translates to:
  /// **'Updated 1 day ago'**
  String get taskDashboardUpdatedDaysAgoSingular;

  /// Live 'last updated' label for two or more days since the dashboard's most recent fetch.
  ///
  /// In en, this message translates to:
  /// **'Updated {count} days ago'**
  String taskDashboardUpdatedDaysAgo(int count);

  /// Full-width button that dismisses the task detail sheet.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get taskDashboardDetailClose;

  /// Heading over the task's description paragraph in the detail sheet.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get taskDashboardDetailDescription;

  /// Heading over the task's pending-action paragraph in the detail sheet.
  ///
  /// In en, this message translates to:
  /// **'Action Pending'**
  String get taskDashboardDetailActionPending;

  /// Heading over the task's workflow-status paragraph in the detail sheet.
  ///
  /// In en, this message translates to:
  /// **'Workflow Progress'**
  String get taskDashboardDetailWorkflowProgress;

  /// Section label opening the reference id / account number / created date grid in the detail sheet.
  ///
  /// In en, this message translates to:
  /// **'Additional Details'**
  String get taskDashboardDetailAdditionalDetails;

  /// Label above the task id in the detail sheet's additional-details grid.
  ///
  /// In en, this message translates to:
  /// **'Reference ID'**
  String get taskDashboardDetailReferenceId;

  /// Label above the account number in the detail sheet's additional-details grid.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get taskDashboardDetailAccountNumber;

  /// Label above the creation date in the detail sheet's additional-details grid.
  ///
  /// In en, this message translates to:
  /// **'Created On'**
  String get taskDashboardDetailCreatedOn;

  /// Relative due-date label for a task due today.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get taskDueToday;

  /// Relative due-date label for a task that was due exactly one day ago.
  ///
  /// In en, this message translates to:
  /// **'Due 1 day ago'**
  String get taskDueDaysAgoSingular;

  /// Relative due-date label for a task overdue by two or more days.
  ///
  /// In en, this message translates to:
  /// **'Due {count} days ago'**
  String taskDueDaysAgo(int count);

  /// Relative due-date label for a task due exactly one day from now.
  ///
  /// In en, this message translates to:
  /// **'Due in 1 day'**
  String get taskDueInDaySingular;

  /// Relative due-date label for a task due two or more days from now.
  ///
  /// In en, this message translates to:
  /// **'Due in {count} days'**
  String taskDueInDays(int count);

  /// Title of the Notifications screen.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// Placeholder text for the Notifications screen's search field.
  ///
  /// In en, this message translates to:
  /// **'Search notifications'**
  String get notificationsSearchHint;

  /// Filter chip label showing every notification.
  ///
  /// In en, this message translates to:
  /// **'All Notifications'**
  String get notificationsFilterAll;

  /// Filter chip label showing only unread notifications.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notificationsFilterUnread;

  /// Empty-state message when the notification list has no rows.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsEmpty;

  /// Overflow menu action marking every notification as read.
  ///
  /// In en, this message translates to:
  /// **'Mark All as Read'**
  String get notificationsMenuMarkAllRead;

  /// Overflow menu action deleting every notification.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get notificationsMenuClearAll;

  /// Title of the confirmation dialog shown before clearing all notifications.
  ///
  /// In en, this message translates to:
  /// **'Clear all notifications?'**
  String get notificationsClearAllConfirmTitle;

  /// Body text of the confirmation dialog shown before clearing all notifications.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove every notification. This action cannot be undone.'**
  String get notificationsClearAllConfirmMessage;

  /// Error snackbar shown when marking all notifications as read fails.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t mark all notifications as read. Please try again.'**
  String get notificationsMarkAllReadError;

  /// Error snackbar shown when clearing all notifications fails.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t clear notifications. Please try again.'**
  String get notificationsClearAllError;

  /// Error snackbar shown when pull-to-refresh fails on the Notifications screen.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh notifications. Please try again.'**
  String get notificationsRefreshError;

  /// Confirms a staged multi-select choice, e.g. the region/market-served picker.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonButtonSave;

  /// App bar title of the Profile screen.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// Role badge text under the user's name on the Profile header.
  ///
  /// In en, this message translates to:
  /// **'{role}'**
  String profileRoleBadge(String role);

  /// Section header above the login-history row on the Profile screen.
  ///
  /// In en, this message translates to:
  /// **'SECURITY & ACCESS'**
  String get profileSecurityAccessTitle;

  /// Title of the Security & Access section's login-history row.
  ///
  /// In en, this message translates to:
  /// **'Login History'**
  String get profileLoginHistoryTitle;

  /// Fallback subtitle of the login-history row when no dated login exists.
  ///
  /// In en, this message translates to:
  /// **'No recent login recorded'**
  String get profileLoginHistorySubtitle;

  /// Subtitle of the login-history row once a dated login is available.
  ///
  /// In en, this message translates to:
  /// **'Last login on {date}'**
  String profileLastLoginOn(String date);

  /// Header of the bottom sheet listing every recent login.
  ///
  /// In en, this message translates to:
  /// **'Login History'**
  String get profileLoginHistoryAllTitle;

  /// Section header above the preference rows on the Profile screen.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get profilePreferencesTitle;

  /// Label of the Profile screen's registered-country preference row.
  ///
  /// In en, this message translates to:
  /// **'Advisor Residence Country'**
  String get profileCountryLabel;

  /// Subtitle of the Profile screen's registered-country preference row.
  ///
  /// In en, this message translates to:
  /// **'The country you are based in'**
  String get profileCountrySubtitle;

  /// Label of the Profile screen's top-client-country preference row.
  ///
  /// In en, this message translates to:
  /// **'Top Client Country'**
  String get profileTopClientCountryLabel;

  /// Subtitle of the Profile screen's top-client-country preference row.
  ///
  /// In en, this message translates to:
  /// **'Where most of your clients are based'**
  String get profileTopClientCountrySubtitle;

  /// Label of the Profile screen's region/market-served preference row.
  ///
  /// In en, this message translates to:
  /// **'Region / Market Served'**
  String get profileRegionLabel;

  /// Subtitle of the Profile screen's region/market-served preference row.
  ///
  /// In en, this message translates to:
  /// **'Markets you actively serve'**
  String get profileRegionSubtitle;

  /// Label of the Profile screen's language preference row.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguageLabel;

  /// Subtitle of the Profile screen's language preference row.
  ///
  /// In en, this message translates to:
  /// **'App display language'**
  String get profileLanguageSubtitle;

  /// Title of the country-selection bottom sheet opened from the residence-country row.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get profileSelectCountryTitle;

  /// Title of the country-selection bottom sheet opened from the top-client-country row.
  ///
  /// In en, this message translates to:
  /// **'Select Top Client Country'**
  String get profileSelectTopClientCountryTitle;

  /// Title of the region-selection bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Select Region / Market Served'**
  String get profileSelectRegionTitle;

  /// Title of the language-selection bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get profileSelectLangTitle;

  /// Validation note shown in the region-selection sheet when every region has been cleared.
  ///
  /// In en, this message translates to:
  /// **'Select at least one region'**
  String get profileRegionSelectionRequired;

  /// Legend explaining the asterisk drawn beside a required preference row.
  ///
  /// In en, this message translates to:
  /// **'* Required field'**
  String get profileMandatoryFieldsNote;

  /// Label of the Profile screen's sign-out button.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileSignOutButton;

  /// Section header above the licensed-geographies card.
  ///
  /// In en, this message translates to:
  /// **'TAX JURISDICTION'**
  String get profileTaxJurisdictionTitle;

  /// Title of the licensed-geographies card listing an advisor's state chips.
  ///
  /// In en, this message translates to:
  /// **'Licensed Geographies'**
  String get profileLicensedGeosTitle;

  /// App bar title of the leadership advisor-selection screen.
  ///
  /// In en, this message translates to:
  /// **'Select Advisor'**
  String get selectAdvisorTitle;

  /// Heading of the leadership advisor-selection screen and its picker sheet.
  ///
  /// In en, this message translates to:
  /// **'Choose a financial advisor'**
  String get selectAdvisorHeading;

  /// Subtitle under the heading on the leadership advisor-selection screen.
  ///
  /// In en, this message translates to:
  /// **'Select the advisor whose book of business you\'d like to view.'**
  String get selectAdvisorSubtitle;

  /// Placeholder/label of the advisor-picker field before an advisor is chosen.
  ///
  /// In en, this message translates to:
  /// **'Select FA'**
  String get selectAdvisorFieldHint;

  /// Label of the button that commits the picked advisor as the active context.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get selectAdvisorContinue;

  /// Placeholder of the search field inside the advisor picker sheet.
  ///
  /// In en, this message translates to:
  /// **'Search by name, email or ID'**
  String get selectAdvisorSearchHint;

  /// Message shown in the advisor picker sheet when the advisor list fails to load.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load advisors. Please try again.'**
  String get selectAdvisorLoadFailed;

  /// Retry action label shown alongside a failed or empty advisor list.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get selectAdvisorRetry;

  /// Message shown in the advisor picker sheet when a search matches no advisors.
  ///
  /// In en, this message translates to:
  /// **'No advisors match your search.'**
  String get selectAdvisorEmpty;

  /// Message shown in the advisor picker sheet when the advisor roster is empty.
  ///
  /// In en, this message translates to:
  /// **'No advisors are available.'**
  String get selectAdvisorNoneAvailable;

  /// Heading on the first welcome carousel page, shown after a fresh sign-in.
  ///
  /// In en, this message translates to:
  /// **'Welcome to FinHub'**
  String get welcomeHeroTitle;

  /// Subtitle on the first welcome carousel page.
  ///
  /// In en, this message translates to:
  /// **'Your all-in-one platform to manage clients, portfolios, and service requests — securely, from anywhere.'**
  String get welcomeHeroSubtitle;

  /// CTA button on the first welcome carousel page — advances to the second page.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get welcomeGetStarted;

  /// Heading on the second welcome carousel page.
  ///
  /// In en, this message translates to:
  /// **'Personalize Your Experience'**
  String get welcomePersonalizeTitle;

  /// Subtitle on the second welcome carousel page.
  ///
  /// In en, this message translates to:
  /// **'Tell us where you work and who you serve, so we can tailor your dashboard and regional settings.'**
  String get welcomePersonalizeSubtitle;

  /// Label on the advisor residence country preference card on the second welcome carousel page.
  ///
  /// In en, this message translates to:
  /// **'Advisor Residence Country'**
  String get welcomeAdvisorCountryLabel;

  /// Placeholder subtitle on the advisor residence country preference card before a country is selected.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get welcomeAdvisorCountrySubtitle;

  /// Label on the region/market-served preference card on the second welcome carousel page.
  ///
  /// In en, this message translates to:
  /// **'Region / Market Served'**
  String get welcomeRegionLabel;

  /// Placeholder subtitle on the region/market-served preference card before a region is selected.
  ///
  /// In en, this message translates to:
  /// **'Select Region / Market Served'**
  String get welcomeRegionSubtitle;

  /// Label on the language preference card on the second welcome carousel page.
  ///
  /// In en, this message translates to:
  /// **'Preferred Language'**
  String get welcomeLanguageLabel;

  /// Placeholder subtitle on the language preference card before a language is selected.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get welcomeLanguageSubtitle;

  /// Note shown below the preference cards on the second welcome carousel page, explaining the red asterisk on each card label.
  ///
  /// In en, this message translates to:
  /// **'* All fields are mandatory'**
  String get welcomePersonalizeMandatoryNote;

  /// Snackbar error shown when Continue is tapped on the second welcome carousel page with required fields left unfilled. fields is a comma-joined list of the untranslated field labels; count drives is/are agreement.
  ///
  /// In en, this message translates to:
  /// **'{fields} {count, plural, one{is required} other{are required}}!'**
  String welcomeMissingFieldsError(String fields, int count);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

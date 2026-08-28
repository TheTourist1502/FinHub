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

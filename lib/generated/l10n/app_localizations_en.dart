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
}

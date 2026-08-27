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
}

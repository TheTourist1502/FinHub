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
}

/// Application-wide constants shared across all layers.
class AppConstants {
  const AppConstants._();

  /// Display name used in OS dialogs, notifications, and the app shell.
  static const String appName = 'FinHub';

  /// How long the app can sit backgrounded before a returning session must
  /// pass biometric re-authentication.
  ///
  /// Only applies to a warm resume (backgrounded, same process). A fully
  /// closed and relaunched app always requires re-authentication regardless
  /// of this value — see `AuthNotifier._evaluateLockState`.
  ///
  /// Temporarily shortened to 5 seconds for testing; restore to a longer
  /// value (e.g. 5 minutes) before release.
  static const Duration appLockTimeout = Duration(seconds: 1800);

  /// How far ahead of its actual expiry an access token is proactively
  /// refreshed by [TokenRefreshService.ensureFreshToken].
  static const Duration tokenRefreshLeadTime = Duration(minutes: 2);

  /// How long `AuthNotifier.signOut` waits on the best-effort
  /// `v1/auth/logout` call before tearing the session down locally anyway.
  ///
  /// Deliberately far below the client's 60-second receive timeout: the
  /// server-side invalidation is a courtesy, and a slow or hung response must
  /// never strand the user on the app-lock screen while local sign-out waits.
  static const Duration signOutTimeout = Duration(seconds: 5);


  /// Maximum number of documents a single upload card (`DocumentUploadCard`)
  /// accepts before further picks are rejected.
  static const int maxDocumentUploadCount = 5;

  /// Maximum accepted size of one picked document, in bytes, for forms that
  /// do not set a tighter limit of their own — see
  /// [maxInlineAttachmentSizeBytes].
  ///
  /// Measured against the raw file, before base64 encoding inflates it by
  /// roughly a third.
  static const int maxDocumentSizeBytes = 10 * 1024 * 1024;

  /// Maximum accepted size of one attachment on a service request whose
  /// submit endpoint embeds attachments inline — 1 MB of raw file content,
  /// before base64 encoding. Applies to Account Maintenance and Online
  /// Access.
  ///
  /// Tighter than [maxDocumentSizeBytes] because those endpoints carry every
  /// attachment inside the submit payload rather than uploading them
  /// separately.
  static const int maxInlineAttachmentSizeBytes = 1024 * 1024;

  /// Maximum number of attachments one inline-attachment service request may
  /// carry, counted across *every* upload card that feeds the same request
  /// rather than per card — the limit belongs to the request, not to any one
  /// card.
  static const int maxInlineAttachmentCount = 4;

  /// Maximum accepted length of a free-text form input.
  ///
  /// On service request forms this is enforced *at the keyboard* — typing
  /// stops at the limit and the field says why, see `LengthLimitedInput` in
  /// `lib/shared/widgets/inputs/length_limited_input.dart`. It stays a
  /// validation rule too (`maxLengthErrorText` in `input_validation.dart`),
  /// since a value prefilled from the backend never passes through the
  /// keyboard and can still arrive over-long.
  static const int maxInputFieldLength = 500;

  /// Maximum accepted length of the Account Maintenance confirmation note,
  /// tighter than the general [maxInputFieldLength] because the Salesforce
  /// field the note lands in is.
  static const int maxConfirmationNoteLength = 200;

  /// Maximum accepted length of a single postal address line — attention line
  /// detail, address lines 1–4 and city — matching the Salesforce address
  /// fields behind them. Postal Code is narrower still, see
  /// [maxPostalCodeLength].
  static const int maxAddressFieldLength = 100;

  /// Minimum number of characters a postal code must carry.
  ///
  /// Country-agnostic: the address form accepts addresses worldwide, so the
  /// bound only rules out the lengths no postal system uses rather than
  /// matching any one country's grammar.
  static const int minPostalCodeLength = 3;

  /// Maximum number of characters a postal code may carry — long enough for
  /// every practical format, including a spaced Canadian code (`K1A 0B1`).
  static const int maxPostalCodeLength = 10;

  /// Maximum accepted length of an email address, matching the 254-character
  /// ceiling an SMTP forward/reverse path allows (RFC 5321 §4.5.3.1).
  ///
  /// This is the protocol ceiling and the default for [isValidEmail]. A form
  /// whose backing record is narrower passes its own limit instead — see
  /// [maxEmailFieldLength].
  static const int maxEmailLength = 254;

  /// Maximum accepted length of an email address typed into a service request
  /// form, tighter than the [maxEmailLength] protocol ceiling because the
  /// Salesforce field behind it is.
  static const int maxEmailFieldLength = 100;

  /// Maximum accepted length of a person-name form field (mother's maiden
  /// name and the like).
  static const int maxNameFieldLength = 100;

  /// Maximum accepted length of an online access User ID.
  ///
  /// Applies to every field that carries one, including the availability-check
  /// sheet that feeds the form — a User ID confirmed there must never come
  /// back too long for the field it lands in.
  static const int maxUserIdLength = 50;

  /// Minimum number of digits a subscriber mobile number must carry, excluding
  /// the dial code (which is picked separately).
  static const int minMobileNumberLength = 7;

  /// Maximum number of digits a subscriber mobile number may carry, excluding
  /// the dial code — the E.164 ceiling of 15 digits.
  ///
  /// Unlike [maxInputFieldLength] this one is enforced *at the keyboard* by
  /// `LengthLimitingTextInputFormatter`, so the advisor is stopped at 15 rather
  /// than shown an error afterwards — see `OnlineAccessMobileNumberField`.
  static const int maxMobileNumberLength = 15;
}

/// Keys used to read and write persisted values via the storage service.
///
/// Storage strategy:
/// - Tokens and sensitive credentials → `secure: true` (FlutterSecureStorage).
/// - User profile fields and app preferences → `secure: false` (SharedPreferences).
class StorageKeys {
  const StorageKeys._();

  // --- Sensitive (always use secure: true) ---

  /// JWT access token for authenticated API requests.
  static const String accessToken = 'access_token';

  /// JWT refresh token used to obtain a new access token.
  static const String refreshToken = 'refresh_token';

  /// Cached `GET /v1/profile` response body (raw JSON string), written by
  /// `AuthService.saveUserInfo`.
  ///
  /// Written once immediately after a fresh login and read back for the rest
  /// of the session, including through biometric re-auth — see
  /// `AuthNotifier._cacheProfile`. Cleared on sign-out via
  /// [StorageService.clearAllData]. Stored securely because it carries PII
  /// beyond the auth session fields below (legal name, financial advisor ID,
  /// login history).
  static const String userInfo = 'user_info';

  // --- Non-sensitive (SharedPreferences) ---
  //
  // The signed-in user's id, email, name, role and financial advisor ID were
  // once mirrored here. They are not any more: every one is a claim in the
  // access token, `AuthService.getCurrentUser` decodes them from there, and a
  // plaintext copy of the role only ever served as something to tamper with.
  // Do not reintroduce them — see the class doc on `AuthService`.

  /// Financial advisor ID currently selected by a leadership user, whose data
  /// the app is displaying. Absent for roles that own their own book.
  static const String selectedAdvisorId = 'selected_advisor_id';

  /// Whether the user has opted in to biometric authentication.
  static const String biometricEnabled = 'biometric_enabled';

  /// Whether the user has completed the onboarding flow.
  static const String onboardingComplete = 'onboarding_complete';

  /// BCP 47 language tag of the user's selected locale (e.g. 'en', 'es').
  static const String locale = 'locale';

  /// Stable UUID generated on first launch and persisted in secure storage.
  ///
  /// Stable per-install device identifier.
  static const String deviceId = 'device_id';

  /// ISO-8601 timestamp of the last time the app was backgrounded while
  /// authenticated. Used to compute elapsed away-time on resume/cold start
  /// against [AppConstants.appLockTimeout].
  static const String lastBackgroundedAt = 'last_backgrounded_at';

  /// ISO-8601 UTC timestamp of when the current access token expires.
  ///
  /// Computed from the `expiresIn` seconds field returned by login
  /// exchange, and refresh responses. Not sensitive — stored non-securely.
  /// Used by [TokenRefreshService.ensureFreshToken] to proactively refresh
  /// before the token actually expires.
  static const String accessTokenExpiresAt = 'access_token_expires_at';
}

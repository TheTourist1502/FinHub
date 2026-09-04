/// Business-function classification for a service request.
///
/// Drives both the icon shown on list cards and the options offered on the
/// "Select Request Type - Business Function" field of the New Service Request
/// form — see [selectable] for why those two sets differ.
enum ServiceRequestType {
  /// Account-level maintenance (address changes, beneficiary updates, etc.).
  accountMaintenance,

  /// Online/portal access provisioning or resets.
  onlineAccess,

  /// Withdrawal-type asset movement requests.
  assetMovementWithdrawals;

  /// Parses the snake_case key used by the service request APIs.
  static ServiceRequestType fromApiKey(String raw) => switch (raw) {
    'account_maintenance' => ServiceRequestType.accountMaintenance,
    'online_access' => ServiceRequestType.onlineAccess,
    'asset_movement_withdrawals' => ServiceRequestType.assetMovementWithdrawals,
    _ => ServiceRequestType.accountMaintenance,
  };

  /// Infers the type from a Salesforce record name (e.g. "Maintain-000000023").
  ///
  /// `GET /v1/service-requests/status` does not send the business function, so
  /// the record-number prefix Salesforce assigns per request type is the only
  /// signal available. Unrecognised prefixes fall back to
  /// [accountMaintenance] — the list card still needs an icon and a label.
  static ServiceRequestType fromRecordName(String name) {
    final prefix = name.split('-').first.toLowerCase();
    return switch (prefix) {
      'maintain' => ServiceRequestType.accountMaintenance,
      'online' || 'edelivery' => ServiceRequestType.onlineAccess,
      'withdraw' || 'withdrawal' => ServiceRequestType.assetMovementWithdrawals,
      _ => ServiceRequestType.accountMaintenance,
    };
  }

  /// The types an advisor may pick in the New Service Request form's business
  /// function dropdown.
  ///
  /// Excludes [assetMovementWithdrawals]: the flow behind it is not built yet,
  /// so it must not be offered. The value itself stays in the enum because
  /// existing requests still come back with it and need their icon and label
  /// rendered on the list and detail screens.
  static const List<ServiceRequestType> selectable = [accountMaintenance, onlineAccess];
}

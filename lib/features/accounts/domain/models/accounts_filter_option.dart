/// Account-type filter shown as chips above the accounts list.
///
/// Lives in `domain/` because the data layer sends [wireValue] as the API's
/// `filter` parameter, and `data/` may not import from `presentation/`.
enum AccountsFilterOption {
  /// Every account — the API's default, so nothing is sent.
  all(null),

  /// Only accounts that belong to a household.
  householdLinked('household-linked'),

  /// Only accounts with no household.
  standalone('standalone');

  /// Creates an [AccountsFilterOption].
  const AccountsFilterOption(this.wireValue);

  /// Value sent as the `filter` query parameter; `null` omits it.
  final String? wireValue;
}

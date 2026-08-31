/// Columns the accounts list can be sorted by.
///
/// Holds both names for the same column so neither side has to hardcode the
/// other's: [id] is what `SortMenuButton` uses, [wireValue] is what the API's
/// `sortBy` parameter expects.
enum AccountSortField {
  /// Current account value.
  aum('aum', 'accountAum'),

  /// Account display name.
  name('name', 'accountName');

  /// Creates an [AccountSortField].
  const AccountSortField(this.id, this.wireValue);

  /// Identifier used by `SortMenuButton`.
  final String id;

  /// Value sent as the `sortBy` query parameter.
  final String wireValue;

  /// Looks up a field by its [id], defaulting to [aum] if unknown.
  static AccountSortField fromId(String id) => values.firstWhere((field) => field.id == id, orElse: () => aum);
}

/// Columns the households list can be sorted by.
///
/// Holds both names for the same column so neither side has to hardcode the
/// other's: [id] is what `SortMenuButton` uses, [wireValue] is what the API's
/// `sortBy` parameter expects.
enum HouseholdSortField {
  /// Total assets under management.
  aum('aum', 'householdAum'),

  /// Household display name.
  name('name', 'householdName');

  /// Creates a [HouseholdSortField].
  const HouseholdSortField(this.id, this.wireValue);

  /// Identifier used by `SortMenuButton`.
  final String id;

  /// Value sent as the `sortBy` query parameter.
  final String wireValue;

  /// Looks up a field by its [id], defaulting to [aum] if unknown.
  static HouseholdSortField fromId(String id) => values.firstWhere((field) => field.id == id, orElse: () => aum);
}

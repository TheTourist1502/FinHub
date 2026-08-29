/// Sort direction for the list endpoints' `sortOrder` parameter.
///
/// Mirrors the backend enum. Always send [wireValue] — the Dart enum names
/// are lower-case and the API would reject them.
enum SortOrder {
  /// Ascending.
  asc('ASC'),

  /// Descending.
  desc('DESC');

  /// Creates a [SortOrder].
  const SortOrder(this.wireValue);

  /// Value sent as the `sortOrder` query parameter.
  final String wireValue;

  /// Converts the UI's `isDescending` flag into an enum value.
  static SortOrder fromDescending({required bool descending}) => descending ? desc : asc;
}

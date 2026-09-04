import 'package:finhub/features/real_time_detailed_view/domain/models/real_time_position.dart';
import 'package:flutter/foundation.dart';

/// The tab's local search + sort selection, and the filtering it implies.
///
/// Immutable so it can drive a [ValueNotifier] and rebuild only the list.
@immutable
class RealTimePositionsViewState {
  /// Creates a view state; defaults to descending sort by market price.
  const RealTimePositionsViewState({
    this.query = '',
    this.sortField = fieldValue,
    this.sortDescending = true,
  });

  /// Sort-by-market-price field id.
  static const fieldValue = 'value';

  /// Sort-by-security-description field id.
  static const fieldName = 'name';

  /// Raw search text typed by the user.
  final String query;

  /// Active sort field id ([fieldValue] or [fieldName]).
  final String sortField;

  /// Whether the active sort runs high-to-low / Z-to-A.
  final bool sortDescending;

  /// Returns a copy with the given fields replaced.
  RealTimePositionsViewState copyWith({String? query, String? sortField, bool? sortDescending}) =>
      RealTimePositionsViewState(
        query: query ?? this.query,
        sortField: sortField ?? this.sortField,
        sortDescending: sortDescending ?? this.sortDescending,
      );

  /// Filters [positions] by [query] and sorts them by the active field.
  ///
  /// Makes a single copy — the filtered result is sorted in place.
  List<RealTimePosition> apply(List<RealTimePosition> positions) {
    final q = query.toLowerCase();
    return (q.isEmpty ? List<RealTimePosition>.of(positions) : positions.where((p) => _matches(p, q)).toList())
      ..sort(_compare);
  }

  /// Whether a position's description or ticker contains the query.
  bool _matches(RealTimePosition p, String q) =>
      p.securityDescription.toLowerCase().contains(q) || (p.tickerSymbol ?? '').toLowerCase().contains(q);

  /// Orders two positions by the active field and direction.
  int _compare(RealTimePosition a, RealTimePosition b) {
    if (sortField == fieldName) {
      return sortDescending
          ? b.securityDescription.compareTo(a.securityDescription)
          : a.securityDescription.compareTo(b.securityDescription);
    }
    return sortDescending ? b.marketPrice.compareTo(a.marketPrice) : a.marketPrice.compareTo(b.marketPrice);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RealTimePositionsViewState &&
          other.query == query &&
          other.sortField == sortField &&
          other.sortDescending == sortDescending;

  @override
  int get hashCode => Object.hash(query, sortField, sortDescending);
}

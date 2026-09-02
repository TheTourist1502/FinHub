/// Type filter applied to a list of transactions.
enum TransactionFilter {
  /// Show every transaction type.
  all,

  /// Show only trades — `BUY` and `SELL`.
  trade,

  /// Show every non-trade type (dividends, fees, transfers, and anything
  /// else that is neither `BUY` nor `SELL`).
  nonTrade;

  /// Returns whether a transaction with [transactionType] passes this filter.
  ///
  /// The trade / non-trade split is driven solely by the raw type string, so
  /// unrecognised or newly added server types fall into [nonTrade] rather
  /// than disappearing from every chip. Matching is case-insensitive: a
  /// `"Buy"` from the API must not silently fall out of the Trade chip.
  bool matches(String transactionType) {
    final type = transactionType.toUpperCase();
    final isTrade = type == 'BUY' || type == 'SELL';
    return switch (this) {
      TransactionFilter.all => true,
      TransactionFilter.trade => isTrade,
      TransactionFilter.nonTrade => !isTrade,
    };
  }
}

/// Returns whether a transaction matches a search [query] (already
/// lower-cased) against every one of its searchable fields.
///
/// Used by transaction list search bars so a query matches on security name,
/// ticker, trade ID, account name/type, asset class, or transaction type —
/// not just the security name.
///
/// Fields are nullable because the API omits several of them on cash
/// movements; a null field simply never matches.
bool transactionMatchesSearch({
  required String query,
  String? securityName,
  String? tickerSymbol,
  String? transactionId,
  String? accountName,
  String? accountType,
  String? assetClass,
  String? transactionType,
}) {
  bool matches(String? field) => field != null && field.toLowerCase().contains(query);

  return matches(securityName) ||
      matches(tickerSymbol) ||
      matches(transactionId) ||
      matches(accountName) ||
      matches(accountType) ||
      matches(assetClass) ||
      matches(transactionType);
}

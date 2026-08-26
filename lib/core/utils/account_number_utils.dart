/// Masks [number] down to its last four digits, e.g. `"1234567890"` →
/// `"XXXX7890"`. Numbers shorter than four characters are shown in full
/// (still prefixed with `"XXXX"`) rather than throwing.
String maskAccountNumber(String number) {
  final suffix = number.length >= 4 ? number.substring(number.length - 4) : number;
  return 'XXXX$suffix';
}

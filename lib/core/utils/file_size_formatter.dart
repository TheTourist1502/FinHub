/// Human-readable form of a byte count, e.g. `842 B`, `245 KB`, `1.2 MB`.
///
/// Shared by every surface that shows a file's weight — attached-document
/// tiles, the OCR sheet's PDF tile, and the "file too large" snackbar — so a
/// limit and the file measured against it are never phrased two different
/// ways.
///
/// Whole megabytes drop the decimal (`1 MB`, not `1.0 MB`), which is what a
/// stated limit should read as; anything in between keeps one decimal place.
String formatFileSize(int bytes) {
  const kb = 1024;
  const mb = kb * 1024;
  if (bytes < kb) return '$bytes B';
  if (bytes < mb) return '${(bytes / kb).toStringAsFixed(0)} KB';
  final megabytes = bytes / mb;
  return megabytes == megabytes.roundToDouble()
      ? '${megabytes.toStringAsFixed(0)} MB'
      : '${megabytes.toStringAsFixed(1)} MB';
}

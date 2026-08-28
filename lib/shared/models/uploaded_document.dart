import 'package:finhub/core/utils/file_size_formatter.dart';
import 'package:flutter/foundation.dart';

/// A file picked via [DocumentUploadCard], held in memory until the owning
/// form submits it.
///
/// Feature-agnostic on purpose: both a shared presentation widget
/// (`document_upload_card.dart`) and per-feature domain models (e.g. Online
/// Access's submit-request payload) need this same shape, and `domain/` is
/// not allowed to import a feature's `presentation/` — `lib/shared/` is the
/// only layer both sides may depend on.
@immutable
class UploadedDocument {
  /// Creates an [UploadedDocument].
  const UploadedDocument({required this.fileName, required this.sizeBytes, required this.base64Content});

  /// File name including its extension, e.g. `edelivery_authorization.pdf`.
  final String fileName;

  /// Size of the original (pre-base64) file content, in bytes.
  final int sizeBytes;

  /// Base64-encoded file content, ready to embed in a submit payload.
  final String base64Content;

  /// Lowercase extension parsed from [fileName], without the leading dot —
  /// e.g. `pdf`. Empty string if [fileName] has no extension.
  String get extension {
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == fileName.length - 1) return '';
    return fileName.substring(dotIndex + 1).toLowerCase();
  }

  /// Human-readable [sizeBytes], e.g. `"842 B"`, `"245 KB"`, `"1.2 MB"`.
  String get formattedSize => formatFileSize(sizeBytes);
}

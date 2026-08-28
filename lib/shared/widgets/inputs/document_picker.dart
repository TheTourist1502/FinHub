import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:finhub/core/config/app_constants.dart';
import 'package:finhub/core/feedback/snackbar_service.dart';
import 'package:finhub/core/l10n/locale_provider.dart';
import 'package:finhub/core/observability/observability_provider.dart';
import 'package:finhub/core/utils/app_logger.dart';
import 'package:finhub/core/utils/file_size_formatter.dart';
import 'package:finhub/generated/l10n/app_localizations.dart';
import 'package:finhub/shared/models/uploaded_document.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Guards against file_picker's own re-entrancy limit: only one native
/// picker session can be active at a time, and invoking it again before the
/// first resolves throws a platform exception (`already_active`) — most
/// commonly from a fast double-tap on "Browse". A call arriving while one is
/// already in flight is ignored instead of hitting that exception.
bool _pickerActive = false;

/// Picks one or more documents via the native file picker, validates each
/// one's size and extension, and returns the resulting [UploadedDocument]s.
///
/// [remainingSlots] is how many more documents the calling card can still
/// accept (its ceiling minus how many are already attached, which for a form
/// whose cards share one budget means minus the *other* card's files too) — a
/// value of `0` or less shows the "max files" snackbar and returns without
/// opening the picker at all. If more files are picked than [remainingSlots]
/// allows, only the first [remainingSlots] are kept and the same snackbar
/// explains why the rest were dropped. Files that fail size or extension
/// validation are skipped individually (each failure reason shown at most
/// once per call) rather than aborting the whole pick, so one bad file
/// doesn't discard the good ones picked alongside it.
///
/// [maxFileCount] is that ceiling itself, and is only ever used to phrase the
/// snackbar above. It is passed separately rather than derived from
/// [remainingSlots] because the two disagree exactly when the message is
/// shown: on the pick that hits the limit there are no slots left, so a
/// message built from [remainingSlots] would tell the advisor they may upload
/// zero files instead of naming the real limit.
///
/// [maxFileSizeBytes] is the largest raw (pre-base64) file this caller
/// accepts, defaulting to the app-wide [AppConstants.maxDocumentSizeBytes]. A
/// form whose endpoint embeds attachments inline passes its own tighter limit
/// — see [AppConstants.maxInlineAttachmentSizeBytes]. It must match the
/// "(Max …)" hint the calling upload card renders, or the advisor is rejected
/// by a rule the card never stated.
///
/// [existingFileNames] are the names already attached to the calling card. A
/// pick that repeats one of them — or repeats another file within the same
/// pick — is abandoned outright: the duplicate is named in a snackbar and
/// *nothing* is returned, since silently keeping the non-duplicates would
/// leave the advisor unsure which of their files actually landed.
///
/// Opens the picker with [FileType.any] (no OS-level MIME filtering) rather
/// than [FileType.custom] with `allowedExtensions`: several Android file
/// managers — notably MIUI's — mishandle custom-extension filtering and show
/// an empty folder instead of the expected files. Extension enforcement is
/// done ourselves below instead, after the pick.
///
/// Deliberately picks without `withData: true`. Loading every picked file's
/// bytes eagerly, before size/extension validation runs, means a single
/// oversized or wrong-type file (e.g. an accidentally-selected video) gets
/// fully read into memory before there's any chance to reject it — enough to
/// hard-crash the app with a native `OutOfMemoryError` on a memory-
/// constrained device, observed with a ~750MB file. Instead, only cheap
/// metadata ([PlatformFile.size]/`.extension`, no I/O) is used to filter,
/// and bytes are read afterwards via [File.readAsBytes] — one file at a
/// time, and only for files that already passed validation.
///
/// Deliberately takes a Riverpod [Ref] rather than a [BuildContext] or
/// [WidgetRef]. The OS can reclaim the hosting Activity while the native
/// picker is in the foreground (observed in practice on some Android
/// devices), which tears down and rebuilds the calling widget before this
/// `Future` resolves — a `BuildContext`-gated callback then silently
/// discards an otherwise-successful pick, since the widget that started it
/// no longer exists to receive it. Call this from a [Notifier] method
/// instead of directly from a widget, so the result reaches provider state
/// regardless of what's currently mounted by the time it resolves.
Future<List<UploadedDocument>> pickDocuments(
  Ref ref, {
  required List<String> allowedExtensions,
  required int remainingSlots,
  required int maxFileCount,
  int maxFileSizeBytes = AppConstants.maxDocumentSizeBytes,
  List<String> existingFileNames = const [],
}) async {
  final l10n = lookupAppLocalizations(ref.read(localeProvider).value ?? const Locale('en'));
  AppLogger.d('pickDocuments: opening picker (allowedExtensions=$allowedExtensions, remainingSlots=$remainingSlots)');

  if (remainingSlots <= 0) {
    AppLogger.w('pickDocuments: no remaining slots, not opening picker');
    ref.read(snackbarServiceProvider).showError(l10n.commonMaxFilesReached(maxFileCount));
    return const [];
  }

  if (_pickerActive) {
    AppLogger.w('pickDocuments: picker already active, ignoring duplicate request');
    return const [];
  }

  List<PlatformFile> picked;
  _pickerActive = true;
  try {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    picked = result?.files ?? const [];
  } on Exception catch (e, s) {
    AppLogger.e('pickDocuments: picker threw', e, s);
    ref.read(errorReporterProvider).report(e, stackTrace: s, context: 'pickDocuments');
    ref.read(snackbarServiceProvider).showError(l10n.commonFilePickFailed);
    return const [];
  } finally {
    _pickerActive = false;
  }

  if (picked.isEmpty) {
    AppLogger.d('pickDocuments: picker returned no files (cancelled)');
    return const [];
  }
  AppLogger.d('pickDocuments: picked ${picked.length} file(s)');

  if (picked.length > remainingSlots) {
    AppLogger.w('pickDocuments: picked ${picked.length} exceeds remainingSlots=$remainingSlots, truncating');
    ref.read(snackbarServiceProvider).showError(l10n.commonMaxFilesReached(maxFileCount));
    picked = picked.sublist(0, remainingSlots);
  }

  // Names are matched case-insensitively: a file manager that hands back
  // "Report.PDF" for a file already attached as "report.pdf" is still the
  // same document to the advisor, and to the backend.
  final seenNames = existingFileNames.map((name) => name.toLowerCase()).toSet();
  for (final file in picked) {
    if (!seenNames.add(file.name.toLowerCase())) {
      AppLogger.w('pickDocuments: "${file.name}" is already attached, abandoning pick');
      ref.read(snackbarServiceProvider).showError(l10n.commonDuplicateFile(file.name));
      return const [];
    }
  }

  final documents = <UploadedDocument>[];
  final rejectedExtensions = <String>{};
  var sawTooLarge = false;
  var sawMissingBytes = false;

  for (final file in picked) {
    if (file.size > maxFileSizeBytes) {
      AppLogger.w('pickDocuments: "${file.name}" exceeds max size (${file.size} bytes)');
      sawTooLarge = true;
      continue;
    }

    final extension = file.extension?.toLowerCase() ?? '';
    if (!allowedExtensions.contains(extension)) {
      AppLogger.w('pickDocuments: "${file.name}" extension "$extension" not in $allowedExtensions');
      rejectedExtensions.add(extension);
      continue;
    }

    final path = file.path;
    if (path == null) {
      AppLogger.w('pickDocuments: "${file.name}" picked with no file path, discarding');
      sawMissingBytes = true;
      continue;
    }

    List<int> bytes;
    try {
      bytes = await File(path).readAsBytes();
    } on IOException catch (e, s) {
      AppLogger.e('pickDocuments: failed reading "${file.name}"', e, s);
      ref.read(errorReporterProvider).report(e, stackTrace: s, context: 'pickDocuments.readAsBytes');
      sawMissingBytes = true;
      continue;
    }

    AppLogger.d('pickDocuments: attaching "${file.name}" (${bytes.length} bytes read)');
    documents.add(UploadedDocument(fileName: file.name, sizeBytes: file.size, base64Content: base64Encode(bytes)));
  }

  if (sawTooLarge) {
    ref.read(snackbarServiceProvider).showError(l10n.commonFileTooLarge(formatFileSize(maxFileSizeBytes)));
  }
  if (rejectedExtensions.isNotEmpty) {
    // An extensionless file has nothing nameable to put in the message, so
    // those fall back to the generic copy.
    final named = rejectedExtensions.where((e) => e.isNotEmpty).toList();
    ref
        .read(snackbarServiceProvider)
        .showError(
          named.isEmpty
              ? l10n.commonUnsupportedFileType
              : l10n.commonFileTypeNotAllowed(
                  _formatExtensions(named, separator: ' or '),
                  allowedExtensions.length,
                  _formatExtensions(allowedExtensions, separator: ', '),
                ),
        );
  }
  if (sawMissingBytes) ref.read(snackbarServiceProvider).showError(l10n.commonFilePickFailed);

  return documents;
}

/// Renders [extensions] for a user-facing message — uppercased and joined by
/// [separator], e.g. `{jpg, png}` → `JPG or PNG`.
String _formatExtensions(Iterable<String> extensions, {required String separator}) =>
    extensions.map((e) => e.toUpperCase()).join(separator);

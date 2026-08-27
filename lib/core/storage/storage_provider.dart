import 'package:finhub/core/storage/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides the app-wide [StorageService].
///
/// Overridden with a ready instance in `main.dart` so every consumer can read
/// it synchronously — the [SharedPreferences] handle is resolved once, before
/// `runApp`, rather than being awaited on each read.
final storageServiceProvider = Provider<StorageService>(
  (ref) => throw UnimplementedError('storageServiceProvider must be overridden in main()'),
);

/// Builds the service. Called once during startup.
Future<StorageService> createStorageService() async {
  final prefs = await SharedPreferences.getInstance();
  return StorageService(prefs, const FlutterSecureStorage());
}

import 'package:finhub/core/auth/auth_service.dart';
import 'package:finhub/core/storage/storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the app-wide [AuthService].
final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref.watch(storageServiceProvider)));

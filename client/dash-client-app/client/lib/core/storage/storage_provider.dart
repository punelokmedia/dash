// lib/core/storage/storage_provider.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

final tokenProvider = FutureProvider.autoDispose<String>((ref) async {
  final storage = ref.read(secureStorageProvider);
  return await storage.read(key: 'token') ?? '';
});

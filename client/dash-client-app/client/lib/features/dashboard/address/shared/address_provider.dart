import 'package:dash_logistics/core/network/dio_provider.dart';
import 'package:dash_logistics/core/storage/storage_provider.dart';
import 'package:dash_logistics/features/dashboard/address/infra/address_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── No FutureProvider needed — repo reads token fresh per request ─────────────
final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  final dio     = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return AddressRepository(dio, storage);
});
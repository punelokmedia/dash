import 'package:delivary_partner/core/network/dio_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());
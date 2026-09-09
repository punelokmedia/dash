import 'package:delivary_partner/core/infra/driver_online_status.dart';
import 'package:delivary_partner/core/shared/dio_client_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final onlineApiProvider = Provider<OnlineApi>(
  (ref) => OnlineApi(
    ref.read(dioClientProvider),
  ), // token auto-added by DioClient interceptor
);

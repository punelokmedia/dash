import 'package:dio/dio.dart';
import 'dev_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dioProvider=Provider<Dio>((ref){
  final dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      // baseUrl: "http://10.0.2.2:3000/", 
      connectTimeout: const Duration(seconds: 5),
    )
  );
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
    // Callers use both /addresses and api/user paths; all backend routes
    // share the /api/v1 prefix.
    if (!Uri.parse(options.path).hasScheme) {
      var path = options.path.replaceFirst(RegExp(r'^/'), '');
      if (path.startsWith('api/')) path = path.substring(4);
      if (path.startsWith('v1/')) path = path.substring(3);
      options.path = '/api/v1/$path';
    }
    handler.next(options);
  }));
  return dio;
});

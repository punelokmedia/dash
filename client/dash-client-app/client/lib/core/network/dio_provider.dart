import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dioProvider=Provider<Dio>((ref){
  return Dio(
    BaseOptions(
      baseUrl: "http://192.168.1.10:3000/",
      // baseUrl: "http://10.0.2.2:3000/", 
      connectTimeout: const Duration(seconds: 5),
    )
  );
});
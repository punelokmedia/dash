import 'package:delivary_partner/core/infra/secured_storage.dart';
import 'package:delivary_partner/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options
      ..baseUrl = APIEndpoints.baseUrl
      ..connectTimeout = const Duration(seconds: 30)
      ..receiveTimeout = const Duration(seconds: 30)
      ..headers = {
        'content-Type': 'application/json',
      };
          _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

  }
  //   Future<Response> get(String path,
  //     {Map<String, dynamic>? queryParameters}) async {
  //   return await _dio.get(path, queryParameters: queryParameters);
  // }

  Future<Response> post(String path, {dynamic data, required Options options}) async {
    return await _dio.post(path, data: data);
  }
  // Future<Response> get(String endPoint,
  //     {Map<String, dynamic>? queryparameters}) async {
  //   try {
  //     // ignore: non_constant_identifier_names
  //     final Response =
  //         await _dio.get(endPoint, queryParameters: queryparameters);
  //     // log(
  //     //   Response.data.toString(),
  //     // );
  //     return Response;
  //   } catch (e) {
  //     return Future.error(e);
  //   }
  // }

  // Future<Response> post(String endPoint, {dynamic body}) async {
  //   try {
  //     // ignore: non_constant_identifier_names
  //     final Response = await _dio.post(endPoint, data: body);

  //     return Response;
  //   } catch (e) {
  //     return Future.error(e);
  //   }
  // }
}


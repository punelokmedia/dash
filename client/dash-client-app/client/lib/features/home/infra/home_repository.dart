import 'dart:developer';
import 'package:dash_logistics/core/errors/error_handler.dart';
import 'package:dash_logistics/features/home/domain/models/banner_model.dart';
import 'package:dash_logistics/features/home/domain/models/past_order_model.dart';
import 'package:dash_logistics/features/home/domain/models/rewards_model.dart';
import 'package:dash_logistics/features/home/domain/models/service_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class HomeRepository {
  Future<List<BannerModel>> fetchBanners();
  Future<List<ServiceModel>> fetchServices();
  Future<List<PastOrderModel>> fetchPastOrders();
  Future<RewardsModel> fetchRewards();
}

class HomeRepositoryImpl implements HomeRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  HomeRepositoryImpl(this._dio, this._storage);

  Future<Options> get _authOptions async {
    final token = await _storage.read(key: 'token');
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<List<BannerModel>> fetchBanners() async {
    try {
      final response = await _dio.get(
        'api/home/banners',
        options: await _authOptions,
      );
      log('fetchBanners: ${response.data}');
      final list = response.data['data'] as List;
      return list
          .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to load banners');
    }
  }

  @override
  Future<List<ServiceModel>> fetchServices() async {
    try {
      final token = await _storage.read(key: 'token') ?? '';
      final response = await _dio.get(
        '/booking/services',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final List<dynamic> data = response.data['data'] as List;
      return data
          .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .where((s) => s.isActive) // ✅ only show active services
          .toList();
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  @override
  Future<List<PastOrderModel>> fetchPastOrders() async {
    try {
      final response = await _dio.get(
        'api/orders/past',
        options: await _authOptions,
      );
      log('fetchPastOrders: ${response.data}');
      final list = response.data['data'] as List;
      return list
          .map((e) => PastOrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to load orders');
    }
  }

  @override
  Future<RewardsModel> fetchRewards() async {
    try {
      final response = await _dio.get(
        'api/user/rewards',
        options: await _authOptions,
      );
      log('fetchRewards: ${response.data}');
      return RewardsModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to load rewards');
    }
  }
}

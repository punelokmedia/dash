import 'package:dash_logistics/core/routes/app_routes_name.dart';
import 'package:dash_logistics/core/theme/app_colors.dart';
import 'package:dash_logistics/core/theme/app_text_styles.dart';
import 'package:dash_logistics/features/home/shared/service_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dash_logistics/core/network/dio_provider.dart';
import 'package:dash_logistics/core/storage/storage_provider.dart';
import 'package:dash_logistics/features/home/domain/models/service_model.dart';
import 'package:dio/dio.dart';
import 'dart:developer' as dev;

// ── Services API provider ─────────────────────────────────────────────────────
final sheetServicesProvider =
    FutureProvider.autoDispose<List<ServiceModel>>((ref) async {
  final dio     = ref.read(dioProvider);
  final storage = ref.read(secureStorageProvider);
  final token   = await storage.read(key: 'token') ?? '';

  // ✅ DEBUG — remove after confirming token is correct
  dev.log('=== sheetServicesProvider ===', name: 'ServiceSheet');
  dev.log('token: ${token.isEmpty ? "EMPTY ❌" : "${token.substring(0, token.length.clamp(0, 20))}... ✅"}', name: 'ServiceSheet');

  if (token.isEmpty) {
    throw Exception('No auth token found. Please log in again.');
  }

  try {
    final response = await dio.get(
      '/booking/services',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    dev.log('services response: ${response.data}', name: 'ServiceSheet');

    final List<dynamic> data = response.data['data'] as List;
    return data
        .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
        .where((s) => s.isActive)
        .toList();
  } on DioException catch (e) {
    dev.log('DioException: ${e.response?.statusCode} — ${e.response?.data}', name: 'ServiceSheet');
    final msg = e.response?.data?['message'] as String?;
    throw Exception(msg ?? 'Failed to load services');
  }
});

// ── Show function ─────────────────────────────────────────────────────────────
void showServiceSheet(BuildContext context, String serviceTitle) {
  final container = ProviderScope.containerOf(context);

  showModalBottomSheet(
    context:            context,
    backgroundColor:    Colors.transparent,
    isScrollControlled: false,
    useRootNavigator:   false,
    builder: (ctx) => UncontrolledProviderScope(
      container: container,
      child: ServiceBottomSheet(serviceTitle: serviceTitle),
    ),
  );
}

String _serviceLabel(String type) {
  switch (type) {
    case 'WITHIN_CITY': return 'Within City';
    case 'OUTSTATION':  return 'Outstation';
    default:            return type; // shows raw value as fallback
  }
}

// ── Bottom Sheet ──────────────────────────────────────────────────────────────
class ServiceBottomSheet extends ConsumerWidget {
  final String serviceTitle;
  const ServiceBottomSheet({super.key, required this.serviceTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState  = ref.watch(serviceSessionProvider);
    final servicesAsync = ref.watch(sheetServicesProvider);

    return Container(
      height: 500.h,
      decoration: BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.only(
        top:    20.h,
        left:   16.w,
        right:  16.w,
        bottom: MediaQuery.of(context).padding.bottom + 20.h,
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // ── Title row ────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Choose your service',
                    style: TextStyle(
                      fontSize:   18.sp,
                      fontWeight: FontWeight.w600,
                      color:      AppColors.black,
                      fontFamily: AppTextStyles.fontFamilyRoboto,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, size: 20.sp, color: Colors.black54),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // ── Services list ─────────────────────────────────────────
              servicesAsync.when(
                loading: () => Column(
                  children: [
                    _ShimmerOption(),
                    SizedBox(height: 16.h),
                    _ShimmerOption(),
                  ],
                ),

                // ✅ Shows the actual API error message in the list area,
                //    NOT in the session error banner at the bottom.
                error: (error, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fallback static options so the user can still proceed
                    _ServiceOption(
                      label:     'Within City',
                      imagePath: 'assets/Icons/vehicles/tata_ace.png',
                      isLoading: sessionState.isLoading,
                      onTap: () => _onServiceTap(
                          context, ref, ServiceType.WITHIN_CITY),
                    ),
                    SizedBox(height: 16.h),
                    _ServiceOption(
                      label:     'Outstation',
                      imagePath: 'assets/Icons/vehicles/14ft.png',
                      isLoading: sessionState.isLoading,
                      onTap: () => _onServiceTap(
                          context, ref, ServiceType.OUTSTATION),
                    ),
                    SizedBox(height: 8.h),
                    // ✅ Show fetch error inline (not the session error banner)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color:        Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8.r),
                        border:       Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 14.sp, color: Colors.orange.shade700),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              'Using default services. (${error.toString().replaceAll("Exception: ", "")})',
                              style: TextStyle(
                                fontSize:   11.sp,
                                color:      Colors.orange.shade800,
                                fontFamily: AppTextStyles.fontFamilyRoboto,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                data: (services) => Column(
                  children: services.map((service) => Column(
                    children: [
                      _ServiceOption(
                        label:     _serviceLabel(service.type),
                        imagePath: service.fallbackAsset,
                        iconUrl:   service.icon,
                        isLoading: sessionState.isLoading,
                        onTap: () => _onServiceTap(
                          context,
                          ref,
                          service.type == 'WITHIN_CITY'
                              ? ServiceType.WITHIN_CITY
                              : ServiceType.OUTSTATION,
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  )).toList(),
                ),
              ),

              SizedBox(height: 10.h),

              Image.asset(
                "assets/Images/home/outstation.png",
                height: 164.h,
                width:  165.w,
              ),
            ],
          ),

          // ── Session error banner (ONLY for createSession errors) ──────
          if (sessionState.error != null)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color:        Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  sessionState.error!,
                  style: TextStyle(
                    color:      Colors.red.shade800,
                    fontSize:   13.sp,
                    fontFamily: AppTextStyles.fontFamilyRoboto,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onServiceTap(
    BuildContext context,
    WidgetRef    ref,
    ServiceType  type,
  ) async {
    final success = await ref
        .read(serviceSessionProvider.notifier)
        .createSession(type);

    if (!context.mounted) return;

    if (success) {
      context.pop();
      if (type == ServiceType.WITHIN_CITY) {
        context.pushNamed(AppRoutesName.locationPageName);
      }
    }
  }
}

// ── Shimmer placeholder ───────────────────────────────────────────────────────
class _ShimmerOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height:  68.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
      decoration: BoxDecoration(
        color:        Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Container(
            width: 90.w, height: 54.h,
            decoration: BoxDecoration(
              color:        Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Container(
              height: 16.h,
              decoration: BoxDecoration(
                color:        Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single option row ─────────────────────────────────────────────────────────
class _ServiceOption extends StatelessWidget {
  final String       label;
  final String       imagePath;
  final String?      iconUrl;
  final VoidCallback onTap;
  final bool         isLoading;

  const _ServiceOption({
    required this.label,
    required this.imagePath,
    required this.onTap,
    this.iconUrl,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height:  68.h,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 7.h),
        decoration: BoxDecoration(
          color:        Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 90.w, height: 54.h,
              child: iconUrl != null && iconUrl!.isNotEmpty
                  ? Image.network(
                      iconUrl!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) =>
                          Image.asset(imagePath, fit: BoxFit.contain),
                    )
                  : Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.local_shipping_outlined,
                        size:  36.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
            ),
            SizedBox(width: 55.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize:   16.sp,
                  fontWeight: FontWeight.w600,
                  color:      AppColors.black26,
                  fontFamily: AppTextStyles.fontFamilyRoboto,
                ),
              ),
            ),
            isLoading
                ? SizedBox(
                    width: 20.w, height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color:       AppColors.green71,
                    ),
                  )
                : Icon(Icons.chevron_right,
                    size: 24.sp, color: AppColors.black28),
          ],
        ),
      ),
    );
  }
}
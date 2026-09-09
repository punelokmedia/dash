import 'dart:developer';

import 'package:delivary_partner/core/network/api_endpoints.dart';
import 'package:delivary_partner/core/network/dio_provider.dart';
import 'package:delivary_partner/core/shared/driver_online_status_provider.dart';
import 'package:delivary_partner/dashobord/widget/bottom_nav.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// ── Providers ─────────────────────────────────────────────────────────────────

final onlineSessionProvider =
    AsyncNotifierProvider<OnlineSessionNotifier, OnlineSession>(
      OnlineSessionNotifier.new,
    );

// ── Model ─────────────────────────────────────────────────────────────────────
class OnlineSession {
  final bool isOnline;
  final int totalSecondsToday;
  final DateTime? sessionStart;

  const OnlineSession({
    required this.isOnline,
    required this.totalSecondsToday,
    this.sessionStart,
  });

  OnlineSession copyWith({
    bool? isOnline,
    int? totalSecondsToday,
    DateTime? sessionStart,
    bool clearSessionStart = false,
  }) {
    return OnlineSession(
      isOnline: isOnline ?? this.isOnline,
      totalSecondsToday: totalSecondsToday ?? this.totalSecondsToday,
      sessionStart: clearSessionStart
          ? null
          : sessionStart ?? this.sessionStart,
    );
  }

  int get liveSeconds {
    if (!isOnline || sessionStart == null) return totalSecondsToday;
    return totalSecondsToday +
        DateTime.now().difference(sessionStart!).inSeconds;
  }

  String get formattedTime {
    final total = liveSeconds;
    final h = total ~/ 3600;
    final m = (total % 3600) ~/ 60;
    final s = total % 60;
    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }
}

// ── API ───────────────────────────────────────────────────────────────────────
class OnlineApi {
  final DioClient _dio;
  OnlineApi(this._dio);

  /// POST /api/partner/toggle/status
  /// Token is injected automatically by DioClient's interceptor
  Future<bool> toggleStatus(bool isOnline) async {
    try {
      final response = await _dio.post(
        APIEndpoints.toggleStatus,
        data: {'IsOnline': isOnline},

        options: Options(validateStatus: (s) => s != null && s <= 500),
      );

      log(
        '[OnlineApi] toggleStatus: ${response.statusCode} | ${response.data}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.data as Map<String, dynamic>;
        // ✅ Drill into 'data' first — response is {success: true, data: {isOnline: true}}
        final data = body['data'] as Map<String, dynamic>;
        return (data['isOnline'] as bool?) ?? false;
      }

      return false;
    } on DioException catch (e) {
      log('[OnlineApi] DioException: ${e.type} | ${e.message}');
      log('[OnlineApi] Response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      log('[OnlineApi] Unknown error: $e');
      rethrow;
    }
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────
class OnlineSessionNotifier extends AsyncNotifier<OnlineSession> {
  @override
  Future<OnlineSession> build() async {
    return const OnlineSession(isOnline: false, totalSecondsToday: 0);
  }

  Future<void> toggle() async {
    final current = state.asData?.value;
    if (current == null) return;

    try {
      // ── Optimistically flip UI immediately ──────────────────────
      final optimistic = current.copyWith(
        isOnline: !current.isOnline,
        sessionStart: !current.isOnline ? DateTime.now() : null,
        clearSessionStart: current.isOnline,
        totalSecondsToday: current.isOnline
            ? current.totalSecondsToday +
                  DateTime.now().difference(current.sessionStart!).inSeconds
            : current.totalSecondsToday,
      );
      state = AsyncData(optimistic);

      // ── Call API ────────────────────────────────────────────────
      final serverIsOnline = await ref
          .read(onlineApiProvider)
          .toggleStatus(optimistic.isOnline);

      // ── Sync with server if response differs ────────────────────
      if (serverIsOnline != optimistic.isOnline) {
        state = AsyncData(optimistic.copyWith(isOnline: serverIsOnline));
      }
    } catch (e) {
      // ── Revert on failure ───────────────────────────────────────
      log('[OnlineSessionNotifier] toggle failed, reverting: $e');
      state = AsyncData(current);
    }
  }
}

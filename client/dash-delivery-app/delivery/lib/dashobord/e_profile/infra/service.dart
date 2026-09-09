import 'dart:io';

import 'package:delivary_partner/dashobord/e_profile/domain/models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileNotifier extends AsyncNotifier<ProfileModel> {
  @override
  Future<ProfileModel> build() => _fetch();

  Future<ProfileModel> _fetch() async {
    // ── Replace with your real API call ───────────────────────────────────
    // final res = await dio.get('/api/v1/driver/profile');
    // return ProfileModel.fromJson(res.data['data']);
    await Future.delayed(const Duration(milliseconds: 500));
    return ProfileModel.demo;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> uploadProfileImage(File image) async {
    // ── Replace with real upload ───────────────────────────────────────────
    // final form = FormData.fromMap({'file': await MultipartFile.fromFile(image.path)});
    // await dio.post('/api/v1/driver/profile/image', data: form);
    await Future.delayed(const Duration(milliseconds: 700));
    await refresh();
  }
}
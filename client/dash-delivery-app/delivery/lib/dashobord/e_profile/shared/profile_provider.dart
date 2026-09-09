
import 'package:delivary_partner/dashobord/e_profile/domain/models.dart';
import 'package:delivary_partner/dashobord/e_profile/infra/service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, ProfileModel>(ProfileNotifier.new);
import 'package:delivary_partner/dashobord/a_home/domain/service.dart';
import 'package:delivary_partner/dashobord/a_home/infra/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';



final homeProvider =
    AsyncNotifierProvider<HomeNotifier, HomeData>(HomeNotifier.new);
import 'package:delivary_partner/authentication/registration/domain/create_account.dart';
import 'package:delivary_partner/authentication/registration/infra/personal_details.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // ✅ no legacy.dart

final personalDetailsProvider =
    NotifierProvider<PersonalDetailsNotifier, PersonalDetailsState>(
  PersonalDetailsNotifier.new, // ✅ NotifierProvider
);
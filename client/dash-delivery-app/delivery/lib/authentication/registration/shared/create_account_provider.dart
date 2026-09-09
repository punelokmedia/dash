import 'package:delivary_partner/authentication/registration/domain/create_account.dart';
import 'package:delivary_partner/authentication/registration/infra/create_account_services.dart';
import 'package:hooks_riverpod/legacy.dart';

final createAccountProvider =
    StateNotifierProvider<CreateAccountNotifier, CreateAccountState>(
  (ref) => CreateAccountNotifier(ref),
);


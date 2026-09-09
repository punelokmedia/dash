
// ── Provider ─────────────────────────────────────────────────
import 'package:delivary_partner/authentication/registration/infra/bank_details.dart';
import 'package:hooks_riverpod/legacy.dart';

final bankDetailsProvider =
    StateNotifierProvider<BankDetailsNotifier, BankDetailsState>(
  (ref) => BankDetailsNotifier(ref: ref),
);

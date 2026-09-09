// lib/authentication/registration/infra/registration_progress_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import '../domain/registration_step.dart';

/// Thin wrapper around SharedPreferences.
/// Stores/retrieves the user's last completed registration step.
class RegistrationProgressService {
  static const _kStepKey   = 'reg_step';
  static const _kPhoneKey  = 'reg_phone';

  final SharedPreferences _prefs;
  const RegistrationProgressService(this._prefs);

  // ── Step ──────────────────────────────────────────────────────────
  RegistrationStep get currentStep {
    final raw = _prefs.getInt(_kStepKey) ?? 0;
    return RegistrationStepX.fromIndex(raw);
  }

  Future<void> saveStep(RegistrationStep step) =>
      _prefs.setInt(_kStepKey, step.index);

  // ── Phone (so we can re-surface who's logged in) ──────────────────
  String? get savedPhone => _prefs.getString(_kPhoneKey);

  Future<void> savePhone(String phone) => _prefs.setString(_kPhoneKey, phone);

  // ── Reset on logout ────────────────────────────────────────────────
  Future<void> clear() => _prefs.clear();
}
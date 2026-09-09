// lib/authentication/registration/shared/registration_progress_provider.dart

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/registration_step.dart';
import '../infra/registration_progress_service.dart';

// ─── SharedPreferences provider ───────────────────────────────────────────────
// Initialized once in main.dart via ProviderScope overrides.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (_) => throw UnimplementedError('Override in ProviderScope'),
);

// ─── Service provider ─────────────────────────────────────────────────────────
final registrationProgressServiceProvider =
    Provider<RegistrationProgressService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return RegistrationProgressService(prefs);
});

// ─── State ────────────────────────────────────────────────────────────────────
class RegistrationProgressState {
  final RegistrationStep step;
  final bool isLoading;

  const RegistrationProgressState({
    this.step = RegistrationStep.notStarted,
    this.isLoading = true, // true while reading prefs on boot
  });

  RegistrationProgressState copyWith({
    RegistrationStep? step,
    bool? isLoading,
  }) => RegistrationProgressState(
    step: step ?? this.step,
    isLoading: isLoading ?? this.isLoading,
  );
}

// ─── Notifier ─────────────────────────────────────────────────────────────────
class RegistrationProgressNotifier
    extends StateNotifier<RegistrationProgressState> {
  final RegistrationProgressService _service;

  RegistrationProgressNotifier(this._service)
      : super(const RegistrationProgressState()) {
    _load();
  }

  /// Called once on startup — reads persisted step from disk.
  void _load() {
    final step = _service.currentStep;
    state = state.copyWith(step: step, isLoading: false);
  }

  /// Call this after each registration step succeeds.
  Future<void> advance(RegistrationStep step) async {
    await _service.saveStep(step);
    state = state.copyWith(step: step);
  }

  /// Call after OTP verified, so phone is persisted for re-login checks.
  Future<void> savePhone(String phone) => _service.savePhone(phone);

  String? get savedPhone => _service.savedPhone;

  /// Full reset on logout / account deletion.
  Future<void> reset() async {
    await _service.clear();
    state = const RegistrationProgressState(
      step: RegistrationStep.notStarted,
      isLoading: false,
    );
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────
final registrationProgressProvider = StateNotifierProvider<
    RegistrationProgressNotifier, RegistrationProgressState>((ref) {
  final service = ref.watch(registrationProgressServiceProvider);
  return RegistrationProgressNotifier(service);
});
// lib/authentication/registration/domain/registration_step.dart

/// Every step in the onboarding funnel.
/// The order here matches the navigation order — do NOT reorder.
enum RegistrationStep {
  /// User has not started anything yet (fresh install / logged out)
  notStarted,

  /// OTP verified, but no KYC docs uploaded yet
  kyc,
  trainingTutorialPage,

  documentRequiredpage,
  createAccountPage,

  /// KYC docs accepted, personal details not submitted
  personalDetails,

  /// Personal details done, vehicle not registered
  vehicleDetails,

  /// Vehicle done, bank details not submittedl
  bankDetails,

  /// All steps complete — go straight to home
  completed,
}

extension RegistrationStepX on RegistrationStep {
  bool get isComplete => this == RegistrationStep.completed;

  /// Numeric index stored in SharedPreferences
  int get index => RegistrationStep.values.indexOf(this);

  static RegistrationStep fromIndex(int i) {
    if (i < 0 || i >= RegistrationStep.values.length) {
      return RegistrationStep.notStarted;
    }
    return RegistrationStep.values[i];
  }
}

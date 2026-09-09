import 'dart:io';

class CreateAccountState {
  final bool isLoading;
  final bool isSuccess;
  final bool isProfileImageUploaded;
  final bool isAadhaarUploaded;
  final bool isPanUploaded;
  final bool isLicenseUploaded;
  final String? error;
  final File? profileImageFile; // ✅ add this

  const CreateAccountState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isProfileImageUploaded = false,
    this.isAadhaarUploaded = false,
    this.isPanUploaded = false,
    this.isLicenseUploaded = false,
    this.error,
    this.profileImageFile, // ✅ add this
  });

  CreateAccountState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isProfileImageUploaded,
    bool? isAadhaarUploaded,
    bool? isPanUploaded,
    bool? isLicenseUploaded,
    String? error,
    File? profileImageFile,        // ✅ add this
    bool clearProfileImage = false, // ✅ sentinel to allow setting null
  }) {
    return CreateAccountState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isProfileImageUploaded: isProfileImageUploaded ?? this.isProfileImageUploaded,
      isAadhaarUploaded: isAadhaarUploaded ?? this.isAadhaarUploaded,
      isPanUploaded: isPanUploaded ?? this.isPanUploaded,
      isLicenseUploaded: isLicenseUploaded ?? this.isLicenseUploaded,
      error: error,
      profileImageFile: clearProfileImage // ✅ add this
          ? null
          : profileImageFile ?? this.profileImageFile,
    );
  }
}
//personal details
class PersonalDetailsState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;
  final List<String> cities;

  const PersonalDetailsState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
    this.cities = const ['Mumbai', 'Delhi', 'Bengaluru', 'Nashik',
                         'Pune', 'Hyderabad', 'Chennai', 'Kolkata'],
  });

  PersonalDetailsState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
    List<String>? cities,
  }) =>
      PersonalDetailsState(
        isLoading:  isLoading  ?? this.isLoading,
        error:      error,
        isSuccess:  isSuccess  ?? this.isSuccess,
        cities:     cities     ?? this.cities,
      );
}

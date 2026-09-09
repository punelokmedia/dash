import 'package:dash_logistics/features/dashboard/profile/domain/models/userProfile.dart';



class ProfileState {
  final bool isLoading;
  final UserProfileModel? profile;
  final String? errorMessage;

  const ProfileState({
    this.isLoading = false,
    this.profile,
    this.errorMessage,
  });

  ProfileState copyWith({
    bool? isLoading,
    UserProfileModel? profile,
    String? errorMessage,
  }) =>
      ProfileState(
        isLoading:    isLoading    ?? this.isLoading,
        profile:      profile      ?? this.profile,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  ProfileState clearError() => ProfileState(
        isLoading: isLoading,
        profile:   profile,
      );
}
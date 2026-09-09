class AuthState {
  final bool isLoading;
  final bool otpSent;
  final bool isLoggedIn;
  final bool profileCompleted;
  final String? error;
  final String? message;
  final String? phone;
  final String? token;

  const AuthState({
    this.isLoading = false,
    this.otpSent = false,
    this.isLoggedIn = false,
    this.profileCompleted = false,
    this.error,
    this.message,
    this.phone,
    this.token,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? otpSent,
    bool? isLoggedIn,
    bool? profileCompleted,
    String? error,
    String? message,
    String? phone,
    String? token,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      otpSent: otpSent ?? this.otpSent,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      error: error,
      message: message ?? this.message,
      phone: phone ?? this.phone,
      token: token ?? this.token,
    );
  }
}
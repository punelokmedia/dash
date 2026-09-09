class UserProfileModel {
  final String  fullName;
  final String  email;
  final String? profilePhoto;

  const UserProfileModel({
    required this.fullName,
    required this.email,
    this.profilePhoto,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      fullName:     json['full_name']     as String,   // ✅ matches API
      email:        json['email']         as String,
      profilePhoto: json['profile_photo'] as String?,  // ✅ nullable
    );
  }

  Map<String, dynamic> toJson() => {
    'full_name':     fullName,
    'email':         email,
    'profile_photo': profilePhoto,
  };
}
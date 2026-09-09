class APIEndpoints {
  static const baseUrl =
      'https://lafayette-traveler-mirror-accuracy.trycloudflare.com';
  static const sendotp = '/api/auth/partner/send-otp';
  static const verifyotp = '/api/auth/partner/verify-otp';
  //create and registration apis
  static const createaccount = '/api/partner/create-account';

  static const personaldetails = '/api/partner/personal-details';
  static const profile = '/api/partner/upload-photo';
  static const uploadadhar = '/api/partner/upload-aadhaar-image';
  static const uploadpan = '/api/partner/upload-pan-card';
  static const uploadlicense = '/api/partner/upload-licence-image';
  //vehicle details
  static const vehicle = '/api/partner/vehicle';
  static const String uploadvehiclephoto = '/api/partner/upload-vehicle-photo';
  static const String uploadvehicledocument =
      '/api/partner/upload-vehicle-document';

  //bank details
  static const String bankdetails = '/api/partner/bank';

  //driver status
  static const String toggleStatus = '/api/partner/toggle/status';
}

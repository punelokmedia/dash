// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'डैश';

  @override
  String get splash_tagline => 'कहीं भी, कुछ भी';

  @override
  String get login_title => 'नमस्ते!';

  @override
  String get login_subtitle => 'वापस स्वागत है';

  @override
  String get login_heading => 'लॉग इन करें';

  @override
  String get login_fullname_hint => 'पूरा नाम';

  @override
  String get login_phone_hint => '0000000000';

  @override
  String get login_change => 'बदलें';

  @override
  String get login_button => 'लॉग इन करें';

  @override
  String get login_forgot_password => 'पासवर्ड भूल गए';

  @override
  String get login_or => 'या';

  @override
  String get login_google => 'गूगल';

  @override
  String get login_apple => 'एप्पल';

  @override
  String get login_facebook => 'फेसबुक';

  @override
  String get login_terms => 'नियम और शर्तें लागू';

  @override
  String otp_title(String phone) {
    return '$phone पर SMS द्वारा भेजा गया\n4-अंकीय कोड दर्ज करें।';
  }

  @override
  String get otp_change_number => 'अपना मोबाइल नंबर बदला?';

  @override
  String get otp_resend => 'SMS द्वारा कोड पुनः भेजें (0:30)';

  @override
  String get otp_button => 'आगे';

  @override
  String get otp_terms => 'नियम और शर्तें लागू';

  @override
  String get register_title => 'अपना खाता बनाएं';

  @override
  String get register_fullname_hint => 'पूरा नाम';

  @override
  String get register_email_phone_hint => 'ईमेल/फ़ोन नंबर';

  @override
  String get register_using_dash_for => 'मैं डैश का उपयोग करूंगा';

  @override
  String get register_reference_code => 'रेफरेंस कोड है?';

  @override
  String get register_button => 'रजिस्टर करें';

  @override
  String get register_already_account => 'पहले से खाता है?';

  @override
  String get register_login => 'लॉग इन करें';

  @override
  String get register_terms => 'नियम और शर्तें लागू';

  @override
  String get error_enter_phone => 'कृपया अपना फ़ोन नंबर दर्ज करें';

  @override
  String get error_invalid_phone => '10 अंकों का सही फ़ोन नंबर दर्ज करें';

  @override
  String get error_enter_otp => 'कृपया OTP दर्ज करें';

  @override
  String get error_invalid_otp => '4 अंकों का सही OTP दर्ज करें';

  @override
  String get error_enter_name => 'कृपया अपना पूरा नाम दर्ज करें';

  @override
  String get error_enter_email => 'कृपया ईमेल दर्ज करें';

  @override
  String get error_invalid_email => 'सही ईमेल पता दर्ज करें';

  @override
  String get error_network => 'नेटवर्क त्रुटि। कृपया पुनः प्रयास करें।';

  @override
  String get error_something_went_wrong =>
      'कुछ गलत हो गया। कृपया पुनः प्रयास करें।';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get logout_confirm => 'क्या आप वाकई लॉग आउट करना चाहते हैं?';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get success => 'सफलता';

  @override
  String get nav_home => 'होम';

  @override
  String get nav_orders => 'ऑर्डर';

  @override
  String get nav_wallet => 'वॉलेट';

  @override
  String get nav_reward => 'रिवॉर्ड';

  @override
  String get service_choose => 'अपनी सेवा चुनें';

  @override
  String get service_within_city => 'शहर के अंदर';

  @override
  String get service_outstation => 'आउटस्टेशन';

  @override
  String get saveLanguage => 'भाषा सहेजें';

  @override
  String get changeLanguage => 'भाषा बदलें';

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get hindi => 'हिंदी';

  @override
  String get home => 'होम';

  @override
  String get settings => 'सेटिंग्स';
}

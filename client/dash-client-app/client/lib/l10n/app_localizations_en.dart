// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Dash';

  @override
  String get splash_tagline => 'Anything, Anywhere';

  @override
  String get login_title => 'Hello!';

  @override
  String get login_subtitle => 'Welcome Back';

  @override
  String get login_heading => 'Log in';

  @override
  String get login_fullname_hint => 'Full name';

  @override
  String get login_phone_hint => '0000000000';

  @override
  String get login_change => 'Change';

  @override
  String get login_button => 'Log in';

  @override
  String get login_forgot_password => 'Forgot password';

  @override
  String get login_or => 'OR';

  @override
  String get login_google => 'Google';

  @override
  String get login_apple => 'Apple';

  @override
  String get login_facebook => 'Facebook';

  @override
  String get login_terms => 'T & C Apply';

  @override
  String otp_title(String phone) {
    return 'Enter the 4-digit code sent via\nSMS at $phone.';
  }

  @override
  String get otp_change_number => 'Changed your mobile number?';

  @override
  String get otp_resend => 'Resend code by SMS (0:30)';

  @override
  String get otp_button => 'Next';

  @override
  String get otp_terms => 'T & C Apply';

  @override
  String get register_title => 'Create Your Account';

  @override
  String get register_fullname_hint => 'Full name';

  @override
  String get register_email_phone_hint => 'Email/Phone number';

  @override
  String get register_using_dash_for => 'I will be using dash for';

  @override
  String get register_reference_code => 'Have reference code?';

  @override
  String get register_button => 'Register';

  @override
  String get register_already_account => 'Already have an account?';

  @override
  String get register_login => 'Log In';

  @override
  String get register_terms => 'T & C Apply';

  @override
  String get error_enter_phone => 'Please enter your phone number';

  @override
  String get error_invalid_phone => 'Enter a valid 10-digit phone number';

  @override
  String get error_enter_otp => 'Please enter OTP';

  @override
  String get error_invalid_otp => 'Enter a valid 4-digit OTP';

  @override
  String get error_enter_name => 'Please enter your full name';

  @override
  String get error_enter_email => 'Please enter your email';

  @override
  String get error_invalid_email => 'Enter a valid email address';

  @override
  String get error_network => 'Network error. Please try again.';

  @override
  String get error_something_went_wrong =>
      'Something went wrong. Please try again.';

  @override
  String get logout => 'Log Out';

  @override
  String get logout_confirm => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get success => 'Success';

  @override
  String get nav_home => 'Home';

  @override
  String get nav_orders => 'Orders';

  @override
  String get nav_wallet => 'Wallet';

  @override
  String get nav_reward => 'Reward';

  @override
  String get service_choose => 'Choose your service';

  @override
  String get service_within_city => 'Within City';

  @override
  String get service_outstation => 'Outstation';

  @override
  String get saveLanguage => 'Save Language';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get english => 'English';

  @override
  String get hindi => 'Hindi';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Dash'**
  String get appName;

  /// No description provided for @splash_tagline.
  ///
  /// In en, this message translates to:
  /// **'Anything, Anywhere'**
  String get splash_tagline;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get login_title;

  /// No description provided for @login_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get login_subtitle;

  /// No description provided for @login_heading.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login_heading;

  /// No description provided for @login_fullname_hint.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get login_fullname_hint;

  /// No description provided for @login_phone_hint.
  ///
  /// In en, this message translates to:
  /// **'0000000000'**
  String get login_phone_hint;

  /// No description provided for @login_change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get login_change;

  /// No description provided for @login_button.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login_button;

  /// No description provided for @login_forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get login_forgot_password;

  /// No description provided for @login_or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get login_or;

  /// No description provided for @login_google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get login_google;

  /// No description provided for @login_apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get login_apple;

  /// No description provided for @login_facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get login_facebook;

  /// No description provided for @login_terms.
  ///
  /// In en, this message translates to:
  /// **'T & C Apply'**
  String get login_terms;

  /// No description provided for @otp_title.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-digit code sent via\nSMS at {phone}.'**
  String otp_title(String phone);

  /// No description provided for @otp_change_number.
  ///
  /// In en, this message translates to:
  /// **'Changed your mobile number?'**
  String get otp_change_number;

  /// No description provided for @otp_resend.
  ///
  /// In en, this message translates to:
  /// **'Resend code by SMS (0:30)'**
  String get otp_resend;

  /// No description provided for @otp_button.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get otp_button;

  /// No description provided for @otp_terms.
  ///
  /// In en, this message translates to:
  /// **'T & C Apply'**
  String get otp_terms;

  /// No description provided for @register_title.
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get register_title;

  /// No description provided for @register_fullname_hint.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get register_fullname_hint;

  /// No description provided for @register_email_phone_hint.
  ///
  /// In en, this message translates to:
  /// **'Email/Phone number'**
  String get register_email_phone_hint;

  /// No description provided for @register_using_dash_for.
  ///
  /// In en, this message translates to:
  /// **'I will be using dash for'**
  String get register_using_dash_for;

  /// No description provided for @register_reference_code.
  ///
  /// In en, this message translates to:
  /// **'Have reference code?'**
  String get register_reference_code;

  /// No description provided for @register_button.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register_button;

  /// No description provided for @register_already_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get register_already_account;

  /// No description provided for @register_login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get register_login;

  /// No description provided for @register_terms.
  ///
  /// In en, this message translates to:
  /// **'T & C Apply'**
  String get register_terms;

  /// No description provided for @error_enter_phone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get error_enter_phone;

  /// No description provided for @error_invalid_phone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit phone number'**
  String get error_invalid_phone;

  /// No description provided for @error_enter_otp.
  ///
  /// In en, this message translates to:
  /// **'Please enter OTP'**
  String get error_enter_otp;

  /// No description provided for @error_invalid_otp.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 4-digit OTP'**
  String get error_invalid_otp;

  /// No description provided for @error_enter_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get error_enter_name;

  /// No description provided for @error_enter_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get error_enter_email;

  /// No description provided for @error_invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get error_invalid_email;

  /// No description provided for @error_network.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please try again.'**
  String get error_network;

  /// No description provided for @error_something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get error_something_went_wrong;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @logout_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logout_confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// No description provided for @nav_orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get nav_orders;

  /// No description provided for @nav_wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get nav_wallet;

  /// No description provided for @nav_reward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get nav_reward;

  /// No description provided for @service_choose.
  ///
  /// In en, this message translates to:
  /// **'Choose your service'**
  String get service_choose;

  /// No description provided for @service_within_city.
  ///
  /// In en, this message translates to:
  /// **'Within City'**
  String get service_within_city;

  /// No description provided for @service_outstation.
  ///
  /// In en, this message translates to:
  /// **'Outstation'**
  String get service_outstation;

  /// No description provided for @saveLanguage.
  ///
  /// In en, this message translates to:
  /// **'Save Language'**
  String get saveLanguage;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

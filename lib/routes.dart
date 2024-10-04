

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:vigil_parents_app/features/appusage_page.dart';
import 'package:vigil_parents_app/features/callrecording_page.dart';
import 'package:vigil_parents_app/features/contact_page.dart';
import 'package:vigil_parents_app/features/gallery_page.dart';
import 'package:vigil_parents_app/features/keylogger_page.dart';
import 'package:vigil_parents_app/pages/aboutus_page.dart';
import 'package:vigil_parents_app/pages/addcard_page.dart';
import 'package:vigil_parents_app/pages/appslibrary_page.dart';
import 'package:vigil_parents_app/pages/dashboard_page.dart';
import 'package:vigil_parents_app/pages/devices_page.dart';
import 'package:vigil_parents_app/pages/editprofile_page.dart';
import 'package:vigil_parents_app/pages/faq_page.dart';
import 'package:vigil_parents_app/pages/home_page.dart';
import 'package:vigil_parents_app/pages/languages_page.dart';
import 'package:vigil_parents_app/pages/login_page.dart';
import 'package:vigil_parents_app/pages/notifications_page.dart';
import 'package:vigil_parents_app/pages/notificationstoggle_page.dart';
import 'package:vigil_parents_app/pages/otp_generated.dart';
import 'package:vigil_parents_app/pages/paymentmethod_page.dart';
import 'package:vigil_parents_app/pages/profile_page.dart';
import 'package:vigil_parents_app/pages/registration_page.dart';
import 'package:vigil_parents_app/pages/resetpassword_finalpage.dart';
import 'package:vigil_parents_app/pages/sendcode_passwordreset.dart';
import 'package:vigil_parents_app/pages/verifyotp_resetpage.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/home': (context) =>  HomePage(),
    '/login': (context) => LoginPage(),
    '/registration': (context) => RegistrationPage(),
    '/devicespage': (context) => ManageDevicesPage(),
    '/otpgenerated': (context) => LinkDevicePage(pairingCode: '',),
    '/send_code': (context) => SendCodePage(),
    '/verify_otp': (context) => VerifyOtpPage(),
    '/passwordreset_final': (context) => PasswordResetFinalPage(),
    '/dashboard_home': (context) => DashboardPage(),
    '/profile': (context) => ProfilePage(),
    '/editprofile': (context) => EditProfilePage(),
    '/subscriptionpage': (context) => SubscriptionPage(),
    '/addcardpage': (context) => AddPaymentMethodPage(),
    '/notificationstoggle' : (context) => NotificationToggle(),
    '/languages': (context) => LanguagePage(),
    '/faq': (context) => FAQPage(),
    '/aboutus': (context) => AboutPage(),
    '/appusage' : (context) => AppUsagePage(),
    '/appslibrary': (context) => AppLibraryPage(),
    '/gallery' : (context) => PhotosAndVideosPage(),
    '/contacts': (context) => ContactsPage(),
    '/callrecording': (context) => CallRecordingsPage(),
    '/keylogger': (context) => KeyloggerPage(),

  };
}

import 'package:courieronedelivery/BottomNavigation/Account/privacy_policy.dart';
import 'package:courieronedelivery/BottomNavigation/Account/tnc_page.dart';
import 'package:courieronedelivery/BottomNavigation/bottom_navigation.dart';
import 'package:courieronedelivery/language_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:courieronedelivery/BottomNavigation/MyDeliveries/my_deliveries.dart';

class PageRoutes {
  // static const String deliveryInfo = 'delivery_info';
  //static const String bottomNavigation = 'home';
  static const String deliveries = 'my_deliveries';
  static const String myProfilePage = 'my_profile_page';
  static const String tncPage = 'tnc_page';
  static const String privacyPolicyPage = 'privacy_policy';
  static const String contactUsPage = 'contact_us_page';
  static const String languagePage = 'language_page';

  Map<String, WidgetBuilder> routes() {
    return {
      // deliveryInfo: (context) => DeliveryInfo(),
      deliveries: (context) => MyDeliveriesPage(),
      //  bottomNavigation: (context) => BottomNavigationPage(),
      // myProfilePage: (context) => MyProfilePage(),
      tncPage: (context) => TncPage(),
      privacyPolicyPage: (context) => PrivacyPolicyPage(),
      // contactUsPage: (context) => ContactUsPage(),
      languagePage: (context) => LanguagePage(),
    };
  }
}

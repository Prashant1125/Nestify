import 'package:get/get.dart';
import 'package:home_for_rent/screens/account_creatioin.dart';
import 'package:home_for_rent/screens/bottom_nav_screen.dart';
import 'package:home_for_rent/screens/homepage.dart';
import 'package:home_for_rent/screens/login.dart';
import 'package:home_for_rent/screens/profile.dart';
import 'package:home_for_rent/screens/signup.dart';
import 'package:home_for_rent/screens/splash.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/Splash',
      page: () => Splash(),
    ),
    GetPage(
      name: '/Login',
      page: () => LoginPage(),
    ),
    GetPage(
      name: '/SignUp',
      page: () => SignUpPage(),
    ),
    GetPage(
      name: '/Home',
      page: () => Homepage(),
    ),
    GetPage(
      name: '/MyProfile',
      page: () => MyProfile(),
    ),
    GetPage(
      name: '/BottomNav',
      page: () => BottomNavScreen(),
    ),
    GetPage(
      name: '/Account_Creation',
      page: () => AccountCreation(),
    )
  ];

  static const String splash = '/Splash';
  static const String login = '/Login';
  static const String signUp = '/SignUp';
  static const String home = '/Home';
  static const String profile = '/MyProfile';
  static const String bottomNav = '/BottomNav';
  static const String accountCreation = '/Account_Creation';
}

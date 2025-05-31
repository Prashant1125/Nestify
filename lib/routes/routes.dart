import 'package:get/get.dart';
import 'package:home_for_rent/api/auth_repo.dart';
import 'package:home_for_rent/screens/account_creatioin.dart';
import 'package:home_for_rent/screens/admin_pannel_screen.dart';
import 'package:home_for_rent/screens/bottom_nav_screen.dart';
import 'package:home_for_rent/screens/homepage.dart';
import 'package:home_for_rent/screens/login.dart';
import 'package:home_for_rent/screens/profile.dart';
import 'package:home_for_rent/screens/signup.dart';
import 'package:home_for_rent/screens/splash.dart';
import 'package:home_for_rent/screens/update_profile.dart';
import 'package:home_for_rent/screens/upload_room.dart';

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
      page: () => HomePage(),
    ),
    GetPage(
      name: '/MyProfile',
      page: () => MyProfile(
        uid: AuthRepo.auth.currentUser!.uid,
      ),
    ),
    GetPage(
      name: '/BottomNav',
      page: () => BottomNavScreen(),
    ),
    GetPage(
      name: '/Account_Creation',
      page: () => AccountCreation(),
    ),
    GetPage(
      name: '/UpdateProfile',
      page: () => UpdateProfile(),
    ),
    GetPage(
      name: '/UploadRoomScreen',
      page: () => UploadRoomScreen(),
    ),
    GetPage(
      name: '/admin_pannel',
      page: () => AdminPanelScreen(),
    )
  ];

  static const String splash = '/Splash';
  static const String login = '/Login';
  static const String signUp = '/SignUp';
  static const String home = '/Home';
  static const String profile = '/MyProfile';
  static const String bottomNav = '/BottomNav';
  static const String accountCreation = '/Account_Creation';
  static const String updateProfile = '/UpdateProfile';
  static const String uploadRoomScren = '/UploadRoomScreen';
  static const String adminPannel = '/admin_pannel';
}

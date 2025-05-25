import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_for_rent/const/string.dart';
import 'package:home_for_rent/firebase_options.dart';
import 'package:home_for_rent/routes/routes.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
    );
  }
}

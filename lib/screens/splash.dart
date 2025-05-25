import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_for_rent/api/auth_repo.dart';
import 'package:home_for_rent/routes/routes.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => getIsLogin());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

Future<void> getIsLogin() async {
  if (AuthRepo.auth.currentUser != null) {
    // ✅ If checkUserAndNavigate returns a String route:
    await AuthRepo.checkUserAndNavigate();
  } else {
    Get.offAllNamed(AppRoutes.login);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_for_rent/api/auth_repo.dart';
import 'package:home_for_rent/components/primary_button.dart';
import 'package:home_for_rent/routes/routes.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(
              onPressed: () {
                AuthRepo.signOut();
                Get.offAllNamed(AppRoutes.login);
              },
              title: 'Logout',
              width: 150,
            ),
          ],
        ),
      ),
    );
  }
}

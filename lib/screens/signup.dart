// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_for_rent/api/auth_repo.dart';
import 'package:home_for_rent/components/primary_button.dart';
import 'package:home_for_rent/components/textfield.dart';
import 'package:home_for_rent/const/image.dart';
import 'package:home_for_rent/loader/loader.dart';
import 'package:home_for_rent/routes/routes.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool pwdVisual = true; // Default to hidden password
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image
            Container(
              height: size.height * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConst.bgImage),
                  fit: BoxFit.cover,
                  opacity: 0.75,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Container(
                  width: size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Create your account',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Full Name',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Email TextField
                        CustomField(
                          controller: nameController,
                          hintText: 'Enter Name',
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Email Address',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Email TextField
                        CustomField(
                          controller: emailController,
                          hintText: 'abc123@gmail.com',
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Password TextField
                        CustomField(
                          obscureText: pwdVisual,
                          controller: pwdController,
                          hintText: 'Password',
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.grey,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                pwdVisual = !pwdVisual;
                              });
                            },
                            icon: pwdVisual
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: Colors.grey,
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    color: Colors.grey,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Sign In Button
                        PrimaryButton(
                          onPressed: () {
                            if (emailController.text.isNotEmpty &&
                                nameController.text.isNotEmpty &&
                                pwdController.text.isNotEmpty) {
                              LoadingDialog.show(
                                  context); // 🔹 Show Loading Dialog
// for sign up
                              AuthRepo.signup(emailController.text,
                                      pwdController.text, nameController.text)
                                  .then((value) {
                                AuthRepo.auth.currentUser
                                    ?.updateDisplayName(nameController.text);
                                LoadingDialog.hide(
                                    context); // 🔹 Hide Loading Dialog
                                Get.snackbar(
                                  'Success',
                                  'Account Created successfully',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.teal,
                                  colorText: Colors.white,
                                  borderRadius: 12,
                                  margin: EdgeInsets.all(16),
                                  icon: Icon(Icons.check_circle_outline,
                                      color: Colors.white),
                                  duration: Duration(seconds: 3),
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  forwardAnimationCurve: Curves.easeOutBack,
                                );
                                Get.offAllNamed(AppRoutes.login);
                              }).onError((error, stackTrace) {
                                LoadingDialog.hide(
                                    context); // 🔹 Hide Loading Dialog
                                if (error is FirebaseAuthException) {
                                  Get.snackbar(
                                    'Error',
                                    error.message.toString(),
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.teal,
                                    colorText: Colors.white,
                                    borderRadius: 12,
                                    margin: EdgeInsets.all(16),
                                    icon: Icon(Icons.check_circle_outline,
                                        color: Colors.white),
                                    duration: Duration(seconds: 3),
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    forwardAnimationCurve: Curves.easeOutBack,
                                  );
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    error.toString(),
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.teal,
                                    colorText: Colors.white,
                                    borderRadius: 12,
                                    margin: EdgeInsets.all(16),
                                    icon: Icon(Icons.check_circle_outline,
                                        color: Colors.white),
                                    duration: Duration(seconds: 3),
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    forwardAnimationCurve: Curves.easeOutBack,
                                  );
                                }
                              });
                            } else {
                              Get.snackbar(
                                'Error',
                                'Please fill all the field',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.teal,
                                colorText: Colors.white,
                                borderRadius: 12,
                                margin: EdgeInsets.all(16),
                                icon: Icon(Icons.check_circle_outline,
                                    color: Colors.white),
                                duration: Duration(seconds: 3),
                                animationDuration: Duration(milliseconds: 300),
                                forwardAnimationCurve: Curves.easeOutBack,
                              );
                            }
                          },
                          title: 'Sign Up',
                        ),
                        const SizedBox(height: 20),
                        // Sign Up Link
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_for_rent/api/auth_repo.dart';
import 'package:home_for_rent/components/primary_button.dart';
import 'package:home_for_rent/components/secondary_button.dart';
import 'package:home_for_rent/components/textfield.dart';
import 'package:home_for_rent/const/image.dart';
import 'package:home_for_rent/controller/visuality.dart';
import 'package:home_for_rent/loader/loader.dart';
import 'package:home_for_rent/routes/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final PasswordVisuability passwordVisuability =
      Get.put(PasswordVisuability());
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

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
                          'Sign in to continue',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

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
                        Obx(() => CustomField(
                              obscureText:
                                  !passwordVisuability.isPasswordVisible.value,
                              controller: pwdController,
                              hintText: 'Password',
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.grey,
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  passwordVisuability
                                      .togglePasswordVisibility();
                                },
                                icon:
                                    passwordVisuability.isPasswordVisible.value
                                        ? const Icon(
                                            Icons.visibility_off,
                                            color: Colors.grey,
                                          )
                                        : const Icon(
                                            Icons.visibility,
                                            color: Colors.grey,
                                          ),
                              ),
                            )),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              forgotPassword(context, emailController);
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Sign In Button
                        PrimaryButton(
                          onPressed: () {
                            if (emailController.text.isNotEmpty &&
                                pwdController.text.isNotEmpty) {
                              LoadingDialog.show(
                                  context); // 🔹 Show Loading Dialog

                              AuthRepo.login(
                                      emailController.text, pwdController.text)
                                  .then((value) {
                                LoadingDialog.hide(
                                    context); // 🔹 Hide Loading Dialog

                                Get.snackbar(
                                  'Success',
                                  'Login Successfully',
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
                                if ((value.user != null)) {
                                  AuthRepo.checkUserAndNavigate();
                                } else {
                                  Get.snackbar(
                                    'Value',
                                    value.toString(),
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
                              }).onError((error, stackTrace) {
                                LoadingDialog.hide(
                                    context); // 🔹 Hide Loading Dialog on Error
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
                          title: 'Sign In',
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "------- Other Method -------",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GoogleButton(
                            image: ImageConst.google,
                            onTap: () {
                              AuthRepo.googleSignInButton(context);
                            }),
                        const SizedBox(height: 20),

                        // Sign Up Link
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.offAllNamed(AppRoutes.signUp);
                                },
                                child: const Text(
                                  'Sign Up',
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

void forgotPassword(
    BuildContext context, TextEditingController emailController) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Forgot Password',
        style: TextStyle(
          color: Colors.teal[800],
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Email Address',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(height: 10),
          CustomField(
            controller: emailController,
            hintText: 'abc123@gmail.com',
            style: TextStyle(color: Colors.grey[900]),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: Colors.teal,
              size: 20,
            ),
          ),
        ],
      ),
      actions: [
        Align(
          alignment: Alignment.center,
          child: PrimaryButton(
            width: Get.width * 0.5,
            title: 'Submit',
            onPressed: () {
              final email = emailController.text.trim();
              if (email.isEmpty) {
                Get.snackbar(
                  'Warning',
                  'Email field cannot be empty.',
                  backgroundColor: Colors.amber[100],
                  colorText: Colors.black87,
                  icon:
                      Icon(Icons.warning_amber_rounded, color: Colors.black54),
                );
                return;
              }

              AuthRepo.auth.sendPasswordResetEmail(email: email).then((value) {
                Get.snackbar(
                  'Success',
                  "Reset link sent successfully to your email: $email",
                  backgroundColor: Colors.teal,
                  colorText: Colors.white,
                  icon: Icon(Icons.check_circle_outline, color: Colors.white),
                );
                Get.back();
              }).onError((error, stackTrace) {
                Get.snackbar(
                  'Error',
                  '$error',
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  icon: Icon(Icons.error_outline, color: Colors.white),
                );
              });
            },
          ),
        ),
      ],
    ),
  );
}

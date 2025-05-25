import 'package:get/get.dart';

class PasswordVisuability extends GetxController {
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}

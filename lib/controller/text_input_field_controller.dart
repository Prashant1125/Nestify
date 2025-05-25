import 'package:get/get.dart';

class TextInputFieldController extends GetxController {
  final RxString _currentFocusedFieldId = ''.obs;
  var passwordVisible = true.obs;

  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  void requestFocus(String uniqueTextInputFieldId) {
    if (_currentFocusedFieldId.value != uniqueTextInputFieldId) {
      _currentFocusedFieldId.value = uniqueTextInputFieldId;
      //print(_currentFocusedFieldId.value);
    }
  }

  void removeFocus() {
    _currentFocusedFieldId.value = '';
  }

  bool isFieldFocused(String uniqueTextInputFieldId) {
    if (_currentFocusedFieldId.value == uniqueTextInputFieldId) {
      return true;
    } else {
      return false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateInputController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  final RxString _currentFocusedFieldId = ''.obs;
  RxBool isValidDOB = true.obs; // Tracks whether the DOB is valid

  /// Formats the input date string with `dd-MM-yyyy` pattern
  String formatDate(String value) {
    // Remove non-digit characters
    String digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    String formatted = '';
    final oldCursorPosition = textEditingController.selection.baseOffset;

    // Apply formatting
    if (digitsOnly.length >= 1) {
      formatted += digitsOnly.substring(0, digitsOnly.length.clamp(0, 2));
    }
    if (digitsOnly.length >= 3) {
      formatted += '-' + digitsOnly.substring(2, digitsOnly.length.clamp(2, 4));
    }
    if (digitsOnly.length >= 5) {
      formatted += '-' + digitsOnly.substring(4, digitsOnly.length.clamp(4, 8));
    }

    textEditingController.text = formatted;

    // Reposition the cursor properly
    int newCursorPosition = oldCursorPosition;
    if (formatted.length > oldCursorPosition &&
        formatted[oldCursorPosition - 1] == '-') {
      newCursorPosition++;
    }
    textEditingController.selection = TextSelection.collapsed(
      offset: newCursorPosition.clamp(0, formatted.length),
    );

    // Validate the full date only if it has 10 characters
    if (formatted.length == 10) {
      try {
        DateFormat('dd-MM-yyyy').parseStrict(formatted);
        isValidDOB.value = true;
      } catch (e) {
        isValidDOB.value = false;
      }
    } else {
      isValidDOB.value = false;
    }

    return formatted;
  }

  /// Opens a date picker dialog and sets the formatted date
  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF063434),
            cardColor: Colors.teal,
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
            ),
            dialogBackgroundColor: const Color(0xFFE0F7FA),
          ),
          child: child ?? Container(),
        );
      },
    );

    if (picked != null) {
      textEditingController.text =
          '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
    }
  }

  /// Validates the date of birth to check if the user is 18+ years old

  /// Requests focus for a specific field
  void requestFocus(String uniqueTextInputFieldId) {
    _currentFocusedFieldId.value = uniqueTextInputFieldId;
  }

  /// Removes focus from the current field
  void removeFocus() {
    _currentFocusedFieldId.value = '';
  }

  /// Checks if a specific field is focused
  bool isFieldFocused(String uniqueTextInputFieldId) {
    return _currentFocusedFieldId.value == uniqueTextInputFieldId;
  }
}

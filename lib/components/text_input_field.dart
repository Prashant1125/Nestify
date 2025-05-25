import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_for_rent/controller/text_input_field_controller.dart';

class TextInputField extends StatelessWidget {
  TextInputField(
      {super.key,
      required this.enabled,
      required this.textEditingController,
      required this.hintText,
      required this.uniqueTextInputFieldId,
      required this.title,
      this.width,
      this.suffixIcon,
      this.validator,
      this.obscureText,
      this.onChanged});

  final TextEditingController textEditingController;
  final String hintText;
  final String title;
  final String uniqueTextInputFieldId;
  final bool enabled;
  final double? width;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final bool? obscureText;
  final _textInputFieldController = Get.put(TextInputFieldController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            title.toString(),
            style: TextStyle(
              fontSize: 16,
              height: 1.0,
              color: Colors.grey[900],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Obx(() {
          bool focusedOrNot =
              _textInputFieldController.isFieldFocused(uniqueTextInputFieldId);

          return GestureDetector(
            onTap: () {
              if (enabled) {
                _textInputFieldController.requestFocus(uniqueTextInputFieldId);
              } else {
                // print('Field is disabled');
              }
            },
            child: enabled
                ? AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: width ?? screenWidth * (350 / 360),
                    height: screenHeight * (45 / 700),
                    decoration: BoxDecoration(
                      color:
                          focusedOrNot ? Colors.transparent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                      border: focusedOrNot
                          ? Border.all(color: Colors.teal, width: 1.5)
                          : Border.all(
                              color: Colors.transparent,
                              width: 0.01,
                            ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: screenWidth * (350 / 360),
                        height: screenHeight * (45 / 800),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextFormField(
                          obscureText: obscureText ?? false,
                          validator: validator,
                          cursorColor: Colors.white,
                          cursorHeight: 15,
                          controller: textEditingController,
                          decoration: InputDecoration(
                            suffixIcon: suffixIcon,
                            hintStyle: TextStyle(
                              color: Colors.grey[900],
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                            hintText: focusedOrNot ? '' : hintText,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                              bottom: focusedOrNot ? 15 : 15,
                              left: focusedOrNot ? 19 : 20,
                              top: 8,
                              right: 20,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          onTap: () {
                            _textInputFieldController
                                .requestFocus(uniqueTextInputFieldId);
                          },
                          onChanged: onChanged,
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * (20 / 800)),
                    child: Container(
                      height: screenHeight * (45 / 800),
                      width: screenWidth * (350 / 360),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Color(0xFF2F5B6C),
                      ),
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              bottom: 12, left: 20, top: 12, right: 20),
                          disabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0.3, color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                            gapPadding: 2,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                  ),
          );
        }),
      ],
    );
  }
}

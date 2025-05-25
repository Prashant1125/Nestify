import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_for_rent/controller/text_input_field_controller.dart';

class PinInputField extends StatefulWidget {
  const PinInputField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.uniqueTextInputFieldId,
    this.width,
    required this.enabled,
    this.validator,
  });

  final TextEditingController textEditingController;
  final String hintText;
  final String uniqueTextInputFieldId;
  final double? width;
  final bool enabled;
  final String? Function(String?)? validator;

  @override
  State<PinInputField> createState() => _PinInputFieldState();
}

class _PinInputFieldState extends State<PinInputField> {
  final _textInputFieldController = Get.put(TextInputFieldController());
  final RxBool _isEmpty = true.obs; // Tracks whether the field is empty.

  @override
  void initState() {
    super.initState();
    widget.textEditingController.addListener(() {
      _isEmpty.value = widget.textEditingController.text.isEmpty;
      final text = widget.textEditingController.text.replaceAll('-', '');
      if (text.length > 6) {
        widget.textEditingController.text = text.substring(0, 6);
      }
      if (text.length <= 6) {
        final formattedText = text.length > 5
            ? '${text.substring(0, 3)}-${text.substring(3)}'
            : text;
        widget.textEditingController.value = TextEditingValue(
          text: formattedText,
          selection: TextSelection.collapsed(offset: formattedText.length),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Pin',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.0,
              color: Colors.grey[900],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Obx(() {
          bool focusedOrNot = _textInputFieldController
              .isFieldFocused(widget.uniqueTextInputFieldId);

          return GestureDetector(
            onTap: () {
              if (widget.enabled) {
                _textInputFieldController
                    .requestFocus(widget.uniqueTextInputFieldId);
              } else {
                // print('it is false**********************************');
              }
            },
            child: widget.enabled
                ? AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: widget.width ?? Get.width * (350 / 360),
                    height: Get.height * (45 / 800),
                    decoration: BoxDecoration(
                      color: focusedOrNot
                          ? Colors.transparent
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isEmpty.value
                            ? Colors.teal // Red border when empty
                            : (focusedOrNot
                                ? const Color(
                                    0xFFB8FE22) // Green border when focused
                                : Colors.transparent), // Default border
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: focusedOrNot
                            ? (widget.width ?? 318)
                            : (widget.width ?? 326),
                        height: focusedOrNot ? 37 : 45,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextFormField(
                          validator: widget.validator,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.teal,
                          cursorHeight: 15,
                          controller: widget.textEditingController,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: Colors.grey[900],
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                            hintText: focusedOrNot ? '' : widget.hintText,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                bottom: focusedOrNot ? 13 : 14,
                                left: focusedOrNot ? 19 : 20,
                                top: 12,
                                right: 20),
                          ),
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          onTap: () {
                            _textInputFieldController
                                .requestFocus(widget.uniqueTextInputFieldId);
                          },
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(bottom: (20 / 800) * deviceHeight),
                    child: Container(
                      height: deviceHeight * (45 / 800),
                      width: widget.width ?? 326,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Color(0xFF2F5B6C),
                      ),
                      child: TextFormField(
                        validator: widget.validator,
                        enabled: false,
                        cursorColor: Colors.teal,
                        cursorHeight: 6,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              bottom: 12, left: 20, top: 12, right: 20),
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.3, color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                            gapPadding: 2,
                          ),
                          errorText: '',
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFDF0030),
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            gapPadding: 1,
                          ),
                          enabledBorder: OutlineInputBorder(
                            gapPadding: 2,
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              strokeAlign: 2,
                              width: 1.5,
                              style: BorderStyle.solid,
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1.5,
                                  strokeAlign: 2,
                                  color: Color(0xFFB8FE22),
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(8),
                              gapPadding: 2),
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        maxLength: 30,
                        buildCounter: (context,
                            {required currentLength,
                            required isFocused,
                            required maxLength}) {
                          return null;
                        },
                      ),
                    ),
                  ),
          );
        }),
      ],
    );
  }
}

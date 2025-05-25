import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_for_rent/controller/location_input_controller.dart';

class LocationInputField extends StatelessWidget {
  final LocationInputController controller = Get.put(LocationInputController());

  final String hintText;
  final TextStyle? hintStyle;
  final String? Function(String?)? validator;
  LocationInputField({
    super.key,
    required this.hintText,
    this.hintStyle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Address line 1',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.0,
              color: Colors.grey[900],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          validator: validator,
          controller: controller.textEditingController,
          keyboardType: TextInputType.text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.0,
            color: Colors.grey[900],
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: hintStyle ??
                TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[900],
                ),
            filled: true,
            fillColor: Colors.grey[100],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.teal),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.location_pin, color: Colors.grey[900]),
              onPressed: () async {
                String location = await controller.pickLocation(context);
                controller.textEditingController.text = location;
              },
            ),
          ),
        ),
      ],
    );
  }
}

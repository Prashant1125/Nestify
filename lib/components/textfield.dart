import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final double? height;
  final double? width;
  final InputDecoration? decoration;
  final String? hintText;
  final TextStyle? style;
  const CustomField({
    super.key,
    required this.controller,
    this.labelText,
    this.prefixIcon,
    this.decoration,
    this.obscureText = false,
    this.height,
    this.width,
    this.hintText,
    this.suffixIcon,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 50,
      width: width ?? 350,
      child: TextField(
        style: style,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
          alignLabelWithHint: true,
          labelText: labelText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

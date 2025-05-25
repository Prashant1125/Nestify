import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String? title;
  final double? width;
  final double? height;
  final Function() onPressed;
  const PrimaryButton(
      {super.key,
      this.title,
      required this.onPressed,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 350,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          title.toString(),
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CircularContainer extends StatelessWidget {
  final Function()? onTap;
  final String? image;
  final double? width;
  final double? hieght;
  final IconData? icon;
  final Color? iconColor;

  const CircularContainer({
    super.key,
    required this.onTap,
    this.image,
    this.hieght,
    this.width,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: hieght ?? 70,
      width: width ?? 70,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100), color: Colors.white),
      child: InkWell(
        onTap: onTap,
        child: image == null
            ? Icon(icon, color: iconColor)
            : Image.asset(
                image.toString(),
              ),
      ),
    );
  }
}

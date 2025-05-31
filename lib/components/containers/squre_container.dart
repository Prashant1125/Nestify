import 'package:flutter/material.dart';

class SqureContainer extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final Color textColor;
  final Color containerColor;
  final Color? iconColor;
  final double? hieght;
  final IconData? icon;
  final String? image;
  const SqureContainer(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.textColor,
      required this.containerColor,
      this.iconColor,
      this.hieght,
      this.icon,
      this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: hieght ?? 110,
        width: 110,
        child: Card(
          elevation: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: containerColor),
                  child: image == null
                      ? IconButton(
                          onPressed: onPressed,
                          icon: Icon(
                            icon,
                            color: iconColor,
                          ),
                        )
                      : Image.asset(image.toString())),
              const SizedBox(
                height: 5,
              ),
              Text(text,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

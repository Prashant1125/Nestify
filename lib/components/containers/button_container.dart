import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonContainer extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final IconData? icon;
  const ButtonContainer(
      {super.key, this.onTap, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          alignment: Alignment.center,
          height: Get.height * .055,
          width: 400,
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                width: 1.5,
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.grey[900],
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[900],
                ),
              ),
            ],
          )),
    );
  }
}

import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final String? image;
  final Function()? onTap;

  const GoogleButton({super.key, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: Image.asset(image.toString()),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Sign In with Google',
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}

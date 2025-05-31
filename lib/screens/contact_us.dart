import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_for_rent/components/containers/container.dart';
import 'package:home_for_rent/components/containers/squre_container.dart';
import 'package:home_for_rent/const/image.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ListView(
      children: [
        SizedBox(
          height: Get.height * .02,
        ),
        Align(
            alignment: Alignment.center,
            child: Image.asset(
              ImageConst.contactBg,
              height: 200,
            )),
        SizedBox(
          height: Get.height * .02,
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SqureContainer(
                      onPressed: () {
                        launchUrl(Uri.parse('tel:9977676213'));
                      },
                      icon: Icons.call,
                      text: 'Call Us',
                      textColor: Colors.orange,
                      containerColor: Colors.orange.shade100,
                      iconColor: Colors.orange),
                  SqureContainer(
                      onPressed: () {
                        launchUrl(
                            Uri.parse('mailto:prashantkushwaha0207@gmail.com'));
                      },
                      icon: Icons.email,
                      text: 'Email Us',
                      textColor: Colors.green,
                      containerColor: Colors.green.shade100,
                      iconColor: Colors.green),
                  SqureContainer(
                      onPressed: () {
                        launchUrl(Uri.parse(
                            "https://www.instagram.com/dear_comrade_pk_1125/"));
                      },
                      icon: Icons.photo_camera,
                      text: 'Instragram',
                      textColor: Colors.purple,
                      containerColor: Colors.purple.shade100,
                      iconColor: Colors.purple),
                ],
              ),
            ],
          ),
        ),
        SqureContainer(
          onPressed: () {
            launchUrl(Uri.parse(
                "https://whatsapp.com/channel/0029VaN1JrrEAKWE80EeY22y"));
          },
          hieght: 130,
          text: 'Join our whatshapp channel',
          textColor: Colors.green,
          containerColor: Colors.transparent,
          image: ImageConst.whatshapp,
        ),
        SizedBox(
          height: Get.height * .04,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularContainer(
                onTap: () {
                  launchUrl(Uri.parse(
                      "https://www.facebook.com/profile.php?id=100028765277487"));
                },
                image: ImageConst.facebookCircle),
            SizedBox(
              width: Get.height * .015,
            ),
            CircularContainer(
                onTap: () {
                  launchUrl(Uri.parse(
                      "https://www.linkedin.com/in/prashant-kushwaha-4a014b243/"));
                },
                image: ImageConst.linkdinCircular),
            SizedBox(
              width: Get.height * .015,
            ),
            CircularContainer(
                onTap: () {
                  launchUrl(Uri.parse("https://github.com/Prashant1125"));
                },
                image: ImageConst.github),
            SizedBox(
              width: Get.height * .015,
            ),
            CircularContainer(
              image: ImageConst.whatshapp,
              onTap: () {
                launchUrl(Uri.parse('sms:9977676213'));
              },
            )
          ],
        )
      ],
    )));
  }
}

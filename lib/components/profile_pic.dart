import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:home_for_rent/controller/image_picker_controller.dart';
import 'package:image_picker/image_picker.dart';

class UploadFileSmallSingle extends StatelessWidget {
  const UploadFileSmallSingle({super.key});

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.sizeOf(context);

    final ImagePickerController imagePickerController =
        Get.put(ImagePickerController());

    return SizedBox(
      height: mq.height * .33,
      child: DottedBorder(
        borderPadding: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(35),
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        dashPattern: const [10, 10],
        color: Colors.teal,
        strokeWidth: 2,
        child: Obx(() {
          return imagePickerController.pickedImage.value == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 220,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          imagePickerController.pickImage(ImageSource.camera);
                        },
                        icon: const Icon(Icons.photo_camera),
                        label: const Text(
                          "Open Camera",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Or",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Choose from ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.grey[900],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            imagePickerController
                                .pickImage(ImageSource.gallery);
                          },
                          child: Text(
                            'Gallery',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.teal,
                              decorationThickness: 2,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.teal[700],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9.0),
                      decoration: BoxDecoration(
                        border: GradientBoxBorder(
                          gradient: LinearGradient(
                            colors: [
                              Colors.teal.withAlpha((0.3 * 255).round()),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          border: GradientBoxBorder(
                            gradient: LinearGradient(
                              colors: [
                                Colors.teal.withAlpha((0.3 * 255).round()),
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(200)),
                          elevation: 5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(500),
                            child: Image.file(
                              File(imagePickerController
                                  .pickedImage.value!.path),
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        imagePickerController.cancelSelectedImage();
                      },
                      child: Text(
                        'Re-Upload',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.teal,
                          decorationThickness: 2,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                  ],
                );
        }),
      ),
    );
  }
}

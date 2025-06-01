import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_for_rent/Models/room_model.dart';
import 'package:home_for_rent/api/auth_repo.dart';
import 'package:home_for_rent/components/appbar.dart';
import 'package:home_for_rent/components/contact_input.dart';
import 'package:home_for_rent/components/location_input/location_input.dart';
import 'package:home_for_rent/components/pin_input.dart';
import 'package:home_for_rent/components/primary_button.dart';
import 'package:home_for_rent/components/text_input_field.dart';
import 'package:home_for_rent/controller/date_input_controller.dart';
import 'package:home_for_rent/controller/location_input_controller.dart';
import 'package:home_for_rent/controller/room_image_controller.dart';
import 'package:home_for_rent/loader/loader.dart';
import 'package:home_for_rent/routes/routes.dart';

class UploadRoomScreen extends StatelessWidget {
  final RoomModel? roomToEdit;

  UploadRoomScreen({super.key, this.roomToEdit}) {
    if (roomToEdit != null) {
      titleController.text = roomToEdit!.title;
      descriptionController.text = roomToEdit!.description;
      rentController.text = roomToEdit!.rent;
      cityController.text = roomToEdit!.city;
      stateController.text = roomToEdit!.state;
      pinController.text = roomToEdit!.pinCode;
      phoneController.text = roomToEdit!.phone;
      amenitiesController.text = roomToEdit!.amenities.join(", ");
      locationInputController.textEditingController.text = roomToEdit!.location;

      // Upload controller me List<String> assign karna hoga, na ki single string
      imagePickerController.uploadedImageUrls.value =
          List<String>.from(roomToEdit!.images);
    }
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController amenitiesController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final LocationInputController locationInputController =
      Get.put(LocationInputController());
  final DateInputController dateInputController =
      Get.put(DateInputController());

  final RoomImagePickerController imagePickerController =
      Get.put(RoomImagePickerController());

  Future<void> _uploadRoom(BuildContext context) async {
    final uid = AuthRepo.auth.currentUser?.uid;
    if (uid == null) {
      Get.snackbar("Error", "User not logged in!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // Validate required fields
    if (titleController.text.trim().isEmpty ||
        rentController.text.trim().isEmpty ||
        cityController.text.trim().isEmpty ||
        pinController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all required fields (Title, Rent, City, Pin Code, Phone)",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Use uploaded images (max 4), or fall back to existing ones (when editing)
    final List<String> uploadedImages =
        imagePickerController.uploadedImageUrls.toList();
    final List<String> existingImages = roomToEdit?.images ?? [];

    final List<String> finalImages =
        uploadedImages.isNotEmpty ? uploadedImages : existingImages;

    // Ensure at least one image is available
    if (finalImages.isEmpty) {
      Get.snackbar("Error", "Please upload at least one image",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    LoadingDialog.show(context);

    try {
      // Use old room ID if editing, else generate new one
      final roomId = roomToEdit?.roomId ??
          DateTime.now().millisecondsSinceEpoch.toString();
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // Detect room type from title
      String getRoomType(String title) {
        final lowerTitle = title.toLowerCase();
        if (lowerTitle.contains("1bhk")) return "1BHK";
        if (lowerTitle.contains("2bhk")) return "2BHK";
        if (lowerTitle.contains("3bhk")) return "3BHK";
        return "Other";
      }

      final room = RoomModel(
        roomId: roomId,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        rent: rentController.text.trim(),
        roomType: getRoomType(titleController.text.trim()),
        furnishingType: "Semi-Furnished", // Can make this dynamic later
        location: locationInputController.textEditingController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        pinCode: pinController.text.trim(),
        phone: phoneController.text.trim(),
        amenities: amenitiesController.text.trim().isEmpty
            ? []
            : amenitiesController.text
                .trim()
                .split(',')
                .map((e) => e.trim())
                .toList(),
        images: finalImages,
        uid: uid,
        timestamp: timestamp,
      );

      await AuthRepo.uploadRoom(room);

      LoadingDialog.hide(context);

      Get.snackbar("Success", "Room uploaded successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);

      Get.offAllNamed(AppRoutes.bottomNav);
    } catch (e) {
      LoadingDialog.hide(context);
      Get.snackbar("Error", "Failed to upload room: $e",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: 'Upload Room Detail',
        hieght: 100,
        isBottom: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextInputField(
                      title: 'Room Title',
                      textEditingController: titleController,
                      hintText: 'Ex: 1BHK for Rent',
                      uniqueTextInputFieldId: 'Room_Title',
                      enabled: true,
                    ),
                    const SizedBox(height: 12),
                    TextInputField(
                      title: 'Description',
                      textEditingController: descriptionController,
                      hintText: 'Describe your room...',
                      uniqueTextInputFieldId: 'Room_Description',
                      // maxLines: 3,
                      enabled: true,
                    ),
                    const SizedBox(height: 12),
                    LocationInputField(
                      validator: (value) => null,
                      hintText: "Enter or select your location",
                    ),
                    const SizedBox(height: 12),
                    TextInputField(
                      title: 'Rent (₹/month) ',
                      textEditingController: rentController,
                      hintText: 'Monthly rent',
                      uniqueTextInputFieldId: 'Rent',
                      keyboardType: TextInputType.number,
                      enabled: true,
                    ),

                    const SizedBox(height: 12),
                    TextInputField(
                      title: 'Amenities (comma separated)',
                      textEditingController: amenitiesController,
                      hintText: 'WiFi, AC, Parking...',
                      uniqueTextInputFieldId: 'Amenities',
                      enabled: true,
                    ),
                    const SizedBox(height: 12),
                    ContactInputField(
                      textEditingController: phoneController,
                      hintText: 'XXXXX-XXXXX',
                      uniqueTextInputFieldId: "Manager_Contact",
                      isEmpty: false,
                      width: Get.width * 0.975,
                      enabled: true,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextInputField(
                            title: 'City',
                            textEditingController: cityController,
                            hintText: 'Enter city',
                            uniqueTextInputFieldId: 'City',
                            enabled: true,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextInputField(
                            title: 'State',
                            textEditingController: stateController,
                            hintText: 'Enter state',
                            uniqueTextInputFieldId: 'State',
                            enabled: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    PinInputField(
                      validator: (value) => null,
                      textEditingController: pinController,
                      hintText: "Enter Pincode",
                      uniqueTextInputFieldId: 'PinCode',
                      enabled: true,
                    ),
                    const SizedBox(height: 20),

                    // Image Picker
                    Obx(() {
                      final controller = imagePickerController;
                      final pickedImages = controller.pickedImages;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Preview picked images
                          if (pickedImages.isNotEmpty)
                            SizedBox(
                              height: 120,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: pickedImages.length,
                                separatorBuilder: (_, __) => SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  final image = pickedImages[index];
                                  return Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(image.path),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // Remove image at index
                                          controller.pickedImages
                                              .removeAt(index);
                                          controller.imageNames.removeAt(index);
                                          controller.imageSizes.removeAt(index);
                                          if (index <
                                              controller
                                                  .uploadedImageUrls.length) {
                                            controller.uploadedImageUrls
                                                .removeAt(index);
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close,
                                              size: 20, color: Colors.white),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            )
                          else
                            const Text("No images selected yet."),

                          const SizedBox(height: 16),

                          // Pick images button
                          ElevatedButton.icon(
                            onPressed: pickedImages.length >= 4
                                ? null
                                : () => controller.pickMultipleImages(context),
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Pick Images (Max 4)'),
                          ),

                          const SizedBox(height: 10),

                          // Uploading progress
                          if (controller.uploading.value)
                            const LinearProgressIndicator(),

                          const SizedBox(height: 20),
                        ],
                      );
                    }),

                    const SizedBox(height: 30),
                    PrimaryButton(
                      width: Get.width * 0.9,
                      height: 50,
                      title: roomToEdit != null ? 'Update Room' : 'Upload Room',
                      onPressed: () => _uploadRoom(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

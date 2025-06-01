import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_for_rent/loader/loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RoomImagePickerController extends GetxController {
  var pickedImage = Rx<XFile?>(null);
  var imageName = ''.obs;
  var imageSize = ''.obs;
  var uploading = false.obs;
  var uploadProgress = 0.0.obs;
  var uploadedImageUrl = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<void> pickImage(ImageSource source, BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(source: source);

      if (image == null) {
        Get.snackbar(
          'Cancelled',
          'Image picking cancelled',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.teal,
          colorText: Colors.white,
          borderRadius: 12,
          margin: EdgeInsets.all(16),
          icon: Icon(Icons.check_circle_outline, color: Colors.white),
          duration: Duration(seconds: 3),
          animationDuration: Duration(milliseconds: 300),
          forwardAnimationCurve: Curves.easeOutBack,
        );
        return;
      }

      final File file = File(image.path);
      pickedImage.value = image;
      imageName.value = file.path.split('/').last;
      imageSize.value = _getFileSize(file);

      uploading.value = true;
      LoadingDialog.show(context);

      final String? uploadedUrl = await uploadToImgbb(file);

      LoadingDialog.hide(context);
      uploading.value = false;

      if (uploadedUrl != null) {
        uploadedImageUrl.value = uploadedUrl;
        await saveUrlToFirebase(uploadedUrl);
        Get.snackbar(
          '✅ Success',
          'Room image uploaded successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.teal,
          colorText: Colors.white,
          borderRadius: 12,
          margin: EdgeInsets.all(16),
          icon: Icon(Icons.check_circle_outline, color: Colors.white),
          duration: Duration(seconds: 3),
          animationDuration: Duration(milliseconds: 300),
          forwardAnimationCurve: Curves.easeOutBack,
        );
      } else {
        Get.snackbar(
          '❌ Error',
          'Failed to upload room image',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.teal,
          colorText: Colors.white,
          borderRadius: 12,
          margin: EdgeInsets.all(16),
          icon: Icon(Icons.error_outline, color: Colors.white),
          duration: Duration(seconds: 3),
          animationDuration: Duration(milliseconds: 300),
          forwardAnimationCurve: Curves.easeOutBack,
        );
      }
    } catch (e) {
      LoadingDialog.hide(context);
      uploading.value = false;
      Get.snackbar(
        '❌ Exception',
        'Something went wrong: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.teal,
        colorText: Colors.white,
        borderRadius: 12,
        margin: EdgeInsets.all(16),
        icon: Icon(Icons.error_outline, color: Colors.white),
        duration: Duration(seconds: 3),
        animationDuration: Duration(milliseconds: 300),
        forwardAnimationCurve: Curves.easeOutBack,
      );
    }
  }

  Future<String?> uploadToImgbb(File file) async {
    const apiKey = '23870d7cf1502d25a700ae7c7581036c';
    final url = 'https://api.imgbb.com/1/upload?key=$apiKey';

    try {
      final base64Image = base64Encode(await file.readAsBytes());
      final response =
          await http.post(Uri.parse(url), body: {'image': base64Image});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['url'];
      } else {
        print('Upload failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  Future<void> saveUrlToFirebase(String imageUrl) async {
    final user = _auth.currentUser;
    if (user != null) {
      // Save room image url in a different node, e.g. userRoomsImages
      await _database.ref("userRoomsImages").child(user.uid).push().set({
        'imageUrl': imageUrl,
        'uploadedAt': DateTime.now().toIso8601String(),
      });
    } else {
      print('No user is signed in');
    }
  }

  String _getFileSize(File file) {
    final bytes = file.lengthSync();
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1048576) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / 1048576).toStringAsFixed(2)} MB';
    }
  }

  void cancelSelectedImage() {
    pickedImage.value = null;
    imageName.value = '';
    imageSize.value = '';
    uploadedImageUrl.value = '';
    uploadProgress.value = 0.0;
  }
}

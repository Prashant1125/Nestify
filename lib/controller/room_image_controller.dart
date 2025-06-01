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
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  var pickedImages = <XFile>[].obs;
  var imageNames = <String>[].obs;
  var imageSizes = <String>[].obs;
  var uploadedImageUrls = <String>[].obs;
  var uploading = false.obs;

  Future<void> pickMultipleImages(BuildContext context) async {
    try {
      final List<XFile> selected = await _picker.pickMultiImage();

      if (selected.isEmpty) {
        Get.snackbar('Cancelled', 'No image selected.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.teal,
            colorText: Colors.white);
        return;
      }

      if (selected.length + pickedImages.length > 4) {
        Get.snackbar('Limit Exceeded', 'You can upload max 4 images only.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.teal,
            colorText: Colors.white);
        return;
      }

      pickedImages.addAll(selected);
      for (var file in selected) {
        final f = File(file.path);
        imageNames.add(f.path.split('/').last);
        imageSizes.add(_getFileSize(f));
      }

      uploading.value = true;
      LoadingDialog.show(context);

      for (var image in selected) {
        final url = await uploadToImgbb(File(image.path));
        if (url != null) {
          uploadedImageUrls.add(url);
          await saveUrlToFirebase(url);
        }
      }

      uploading.value = false;
      LoadingDialog.hide(context);

      Get.snackbar('Success', 'Images uploaded successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.teal,
          colorText: Colors.white);
    } catch (e) {
      uploading.value = false;
      LoadingDialog.hide(context);
      Get.snackbar('Error', 'Something went wrong: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.teal,
          colorText: Colors.white);
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

  void cancelSelectedImages() {
    pickedImages.clear();
    imageNames.clear();
    imageSizes.clear();
    uploadedImageUrls.clear();
  }
}

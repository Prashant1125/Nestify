import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ImagePickerController extends GetxController {
  var pickedImage = Rx<XFile?>(null);
  var imageName = ''.obs;
  var imageSize = ''.obs;
  var uploading = false.obs;
  var uploadProgress = 0.0.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      File file = File(image.path);
      pickedImage.value = image;
      imageName.value = file.path.split('/').last;
      imageSize.value = _getFileSize(file);

      uploading.value = true;
      String? uploadedUrl = await uploadToImgbb(file);

      if (uploadedUrl != null) {
        await saveUrlToFirebase(uploadedUrl);
        Get.snackbar('✅ Success', 'Profile picture updated!');
      } else {
        Get.snackbar('❌ Error', 'Failed to upload image');
      }

      uploading.value = false;
    }
  }

  Future<String?> uploadToImgbb(File file) async {
    final apiKey = '23870d7cf1502d25a700ae7c7581036c';
    final url = 'https://api.imgbb.com/1/upload?key=$apiKey';

    try {
      final base64 = base64Encode(await file.readAsBytes());
      final response = await http.post(Uri.parse(url), body: {'image': base64});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['url'];
      } else {
        print('Upload failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> saveUrlToFirebase(String imageUrl) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _database.ref("userInfo").child(user.uid).update({
        'profilePicture': imageUrl,
      });
    } else {
      print('No user signed in');
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
    uploading.value = false;
    uploadProgress.value = 0.0;
  }
}

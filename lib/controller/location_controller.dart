import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationController extends GetxController {
  var currentPosition = Rx<Position?>(null);
  var currentAddress = "".obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    isLoading.value = true;
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // ✅ Check if Location Services are Enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          "Location services are disabled.",
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

      // ✅ Check & Request Location Permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          isLoading.value = false;
          Get.snackbar(
            "Error",
            "Location permissions are denied.",
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
      }

      if (permission == LocationPermission.deniedForever) {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          "Location permissions are permanently denied.",
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

      // ✅ Get Current Position
      Position position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high);
      currentPosition.value = position;
      // print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");

      // ✅ Convert Lat/Lng to Address
      await getAddressFromLatLng(position);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to get location: $e",
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
    } finally {
      isLoading.value = false;
    }
  }

  // 🔹 Function to Convert Latitude/Longitude to Address
  Future<void> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];
      currentAddress.value =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      // print("Current Address: ${currentAddress.value}");
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to get address: $e",
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
    }
  }
}

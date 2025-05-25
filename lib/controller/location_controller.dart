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
        Get.snackbar("Error", "Location services are disabled.");
        return;
      }

      // ✅ Check & Request Location Permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          isLoading.value = false;
          Get.snackbar("Error", "Location permissions are denied.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        isLoading.value = false;
        Get.snackbar("Error", "Location permissions are permanently denied.");
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
      Get.snackbar("Error", "Failed to get location: $e");
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
      Get.snackbar("Error", "Failed to get address: $e");
    }
  }
}

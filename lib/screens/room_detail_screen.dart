import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:home_for_rent/Models/room_model.dart';
import 'package:home_for_rent/api/auth_repo.dart';
import 'package:home_for_rent/components/appbar.dart';
import 'package:home_for_rent/controller/fetch_room_controller.dart';
import 'package:home_for_rent/screens/intersted_user_screen.dart';
import 'package:home_for_rent/screens/upload_room.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widget_zoom/widget_zoom.dart';

class RoomDetailScreen extends StatelessWidget {
  final RoomModel room;

  const RoomDetailScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = AuthRepo.user?.uid;
    bool isOwner = room.uid == currentUserId;

    return Scaffold(
      appBar: CustomAppBar(
        isBottom: false,
        title: 'Room Detail',
        hieght: 90,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isOwner
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton.extended(
                      backgroundColor: Colors.white, // Light background
                      foregroundColor: Colors.teal, // Icon & text color teal
                      elevation: 6, // Slight shadow for depth
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16), // Rounded corners
                        side: BorderSide(
                            color: Colors.teal.shade200,
                            width: 1), // subtle border
                      ),
                      icon: const Icon(Icons.delete),
                      label: const Text(
                        "Delete",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () async {
                        await Get.find<RoomController>().deleteRoom(room);
                        Get.back(); // screen close karna agar modal hai to
                      },
                    ),
                    FloatingActionButton.extended(
                      backgroundColor: Colors.white, // Light background
                      foregroundColor: Colors.teal, // Icon & text color teal
                      elevation: 6, // Slight shadow for depth
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16), // Rounded corners
                        side: BorderSide(
                            color: Colors.teal.shade200,
                            width: 1), // subtle border
                      ),
                      icon: const Icon(Icons.edit),
                      label: const Text(
                        "Edit Detail",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        Get.to(() => UploadRoomScreen(roomToEdit: room));
                      },
                    ),
                  ],
                ),
                FloatingActionButton.extended(
                  backgroundColor: Colors.white, // Light background
                  foregroundColor: Colors.teal, // Icon & text color teal
                  elevation: 6, // Slight shadow for depth
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Rounded corners
                    side: BorderSide(
                        color: Colors.teal.shade200, width: 1), // subtle border
                  ),
                  icon: const Icon(Icons.interests_outlined),
                  label: const Text(
                    "Interested Users",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => InterestedUsersScreen(
                          roomId: room.roomId,
                          ownerUid: room.uid,
                        ));
                  },
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton.extended(
                      backgroundColor: Colors.white, // Light background
                      foregroundColor: Colors.teal, // Icon & text color teal
                      elevation: 6, // Slight shadow for depth
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16), // Rounded corners
                        side: BorderSide(
                            color: Colors.teal.shade200,
                            width: 1), // subtle border
                      ),
                      icon: const Icon(Icons.call),
                      label: const Text(
                        "Call ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () async {
                        if (room.phone.isNotEmpty) {
                          await launchUrl(Uri.parse('tel:${room.phone}'));
                        } else {
                          Get.snackbar('Error', 'Number not avilable');
                        }
                      },
                    ),
                    FloatingActionButton.extended(
                      backgroundColor: Colors.white, // Light background
                      foregroundColor: Colors.teal, // Icon & text color teal
                      elevation: 6, // Slight shadow for depth
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16), // Rounded corners
                        side: BorderSide(
                            color: Colors.teal.shade200,
                            width: 1), // subtle border
                      ),
                      icon: const Icon(Icons.message),
                      label: const Text(
                        "Messege",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () async {
                        if (room.phone.isNotEmpty) {
                          await launchUrl(Uri.parse('sms:${room.phone}'));
                        } else {
                          Get.snackbar('Error', 'Number not avilable');
                        }
                      },
                    ),
                  ],
                ),
                FloatingActionButton.extended(
                  backgroundColor: Colors.white, // Light background
                  foregroundColor: Colors.teal, // Icon & text color teal
                  elevation: 6, // Slight shadow for depth
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Rounded corners
                    side: BorderSide(
                        color: Colors.teal.shade200, width: 1), // subtle border
                  ),
                  icon: const Icon(Icons.call),
                  label: const Text(
                    "I'm Interested",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () async {
                    final uid = AuthRepo.auth.currentUser?.uid;
                    if (uid == null) {
                      Get.snackbar("Error", "User not logged in!",
                          backgroundColor: Colors.red, colorText: Colors.white);
                      return;
                    }

                    final roomRef = FirebaseDatabase.instance
                        .ref("rooms")
                        .child(room.uid) // uploader's UID
                        .child(room.roomId)
                        .child("interestedUsers");

                    await roomRef.update({uid: true});

                    Get.snackbar("Success", "Your interest has been shared!",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP);
                  },
                ),
              ],
            ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: CarouselSlider.builder(
                itemCount: room.images.length,
                itemBuilder: (context, index, realIndex) {
                  return WidgetZoom(
                    heroAnimationTag: 'zoom_${room.images.indexed}_',
                    zoomWidget: CachedNetworkImage(
                      imageUrl: room.images[index],
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 250,
                  viewportFraction: 1, // Full width slides
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  autoPlay: true,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₹ ${room.rent} / month",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "Location: ${room.location}, ${room.city}, ${room.state} - ${room.pinCode}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Description:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    room.description,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Room Type: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(room.roomType),
                  const SizedBox(height: 6),
                  const Text(
                    "Furnishing: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(room.furnishingType),
                  const SizedBox(height: 12),
                  const Text(
                    "Amenities:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: room.amenities
                        .map((item) => Chip(label: Text(item)))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.teal),
                      const SizedBox(width: 8),
                      Text(
                        room.phone.isNotEmpty
                            ? room.phone
                            : "Phone not available",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: 50), // extra padding for FAB visibility
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

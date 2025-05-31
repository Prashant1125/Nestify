import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_for_rent/Models/room_model.dart';
import 'package:home_for_rent/controller/my_room_controller.dart';
import 'package:home_for_rent/screens/room_detail_screen.dart';

class MyRoomsScreen extends StatelessWidget {
  const MyRoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyRoomController());
    return Scaffold(
      body: Obx(() {
        if (controller.myRooms.isEmpty) {
          return const Center(
              child: Text(
                  "Room Not Uploaded By You,\ncontact To admin by Contact us Page "));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.myRooms.length,
          itemBuilder: (context, index) {
            final RoomModel room = controller.myRooms[index];
            print("Room phone from UI: ${room.phone}"); // << yaha bhi lagao

            return GestureDetector(
              onTap: () {
                Get.to(() => RoomDetailScreen(room: room));
              },
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(15)),
                      child: CachedNetworkImage(
                        imageUrl: room.images.isNotEmpty
                            ? room.images.first
                            : 'https://via.placeholder.com/150',
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Location: ${room.location}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(
                            "₹ ${room.rent} / month",
                            style: const TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

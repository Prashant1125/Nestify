import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:home_for_rent/controller/fetch_room_controller.dart';
import 'package:home_for_rent/screens/room_detail_screen.dart';

class HomePage extends StatelessWidget {
  final RoomController roomController = Get.put(RoomController());
  final TextEditingController searchController = TextEditingController();
  final RxString searchText = ''.obs;

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final query = searchText.value.trim().toLowerCase();

        // Try to parse input as number only if it's a pure number string
        final rentQuery = double.tryParse(query);

        final filteredList = roomController.roomList.where((room) {
          final title = room.title.trim().toLowerCase();
          final location = room.city.trim().toLowerCase();

          String rentString = room.rent.replaceAll(',', '').trim();
          final rent = double.tryParse(rentString) ?? double.infinity;

          if (rentQuery != null) {
            return rent <= rentQuery;
          }

          if (query.isNotEmpty) {
            return title.contains(query) || location.contains(query);
          }

          return true;
        }).toList();

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by city, title or max price',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Obx(() => searchText.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          searchText.value = '';
                        },
                      )
                    : const SizedBox()),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                searchText.value = value;
              },
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            if (filteredList.isEmpty)
              const Center(
                child: Text("No matching rooms found"),
              )
            else
              ...filteredList.map((room) {
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
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15)),
                          child: CachedNetworkImage(
                            imageUrl: room.images.isNotEmpty
                                ? room.images.first
                                : 'https://via.placeholder.com/150',
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
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
              }),
          ],
        );
      }),
    );
  }
}

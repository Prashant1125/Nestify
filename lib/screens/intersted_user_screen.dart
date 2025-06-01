import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_for_rent/components/appbar.dart';
import 'package:home_for_rent/controller/intrested_user_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user_data_model.dart';

class InterestedUsersScreen extends StatelessWidget {
  final String ownerUid;
  final String roomId;

  InterestedUsersScreen(
      {super.key, required this.ownerUid, required this.roomId});

  final InterestedUsersController controller =
      Get.put(InterestedUsersController());

  @override
  Widget build(BuildContext context) {
    controller.fetchInterestedUsers(ownerUid, roomId);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Interested Users",
        hieght: 100,
        isBottom: false,
      ),
      body: Obx(() {
        if (controller.interestedUsers.isEmpty) {
          return const Center(
            child: Text(
              "No interested users yet.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.interestedUsers.length,
          itemBuilder: (context, index) {
            final UserDataModel user = controller.interestedUsers[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: user.profilePicture != null &&
                              user.profilePicture!.isNotEmpty
                          ? NetworkImage(user.profilePicture!)
                          : null,
                      child: user.profilePicture == null ||
                              user.profilePicture!.isEmpty
                          ? const Icon(Icons.person, size: 30)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    // User Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name ?? "No Name",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(user.email ?? "No Email"),
                          Text("Phone: ${user.phoneNumber ?? "N/A"}"),
                          Text(
                              "Location: ${user.city ?? ""}, ${user.state ?? ""}"),
                          Text("DOB: ${user.dob ?? "-"}"),
                          Text("Gender: ${user.gender ?? "-"}"),
                          Text("Type: ${user.types ?? "-"}"),
                          if (user.location != null &&
                              user.location!.isNotEmpty)
                            Text("Nearby: ${user.location}"),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  if (user.phoneNumber != null &&
                                      user.phoneNumber!.isNotEmpty) {
                                    launchUrl(
                                        Uri.parse("tel:${user.phoneNumber}"));
                                  }
                                },
                                icon: const Icon(
                                  Icons.call,
                                  color: Colors.white70,
                                ),
                                label: const Text("Call"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: () {
                                  if (user.phoneNumber != null &&
                                      user.phoneNumber!.isNotEmpty) {
                                    launchUrl(
                                        Uri.parse("sms:${user.phoneNumber}"));
                                  }
                                },
                                icon: const Icon(Icons.message),
                                label: const Text("Message"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
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

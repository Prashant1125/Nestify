import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/user_data_model.dart';

class InterestedUsersController extends GetxController {
  final RxList<UserDataModel> interestedUsers = <UserDataModel>[].obs;
  final FirebaseDatabase db = FirebaseDatabase.instance;

  Future<void> fetchInterestedUsers(String ownerUid, String roomId) async {
    interestedUsers.clear();
    final interestedRef = db.ref('rooms/$ownerUid/$roomId/interestedUsers');

    final snapshot = await interestedRef.get();

    if (snapshot.exists) {
      final Map<dynamic, dynamic> interestedMap = snapshot.value as Map;

      for (String uid in interestedMap.keys) {
        final userSnapshot = await db.ref('userInfo/$uid').get();
        if (userSnapshot.exists && userSnapshot.value != null) {
          final userData = UserDataModel.fromMap(
            Map<String, dynamic>.from(userSnapshot.value as Map),
          );
          interestedUsers.add(userData);
        }
      }
    }
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class RoomInterestController extends GetxController {
  RxBool hasApplied = false.obs;

  Future<void> checkIfUserAlreadyApplied(
      String ownerUid, String roomId, String userUid) async {
    final ref = FirebaseDatabase.instance
        .ref("rooms/$ownerUid/$roomId/interestedUsers/$userUid");

    final snapshot = await ref.get();
    hasApplied.value = snapshot.exists;
  }

  Future<void> markUserAsInterested(
      String ownerUid, String roomId, String userUid) async {
    final ref = FirebaseDatabase.instance
        .ref("rooms/$ownerUid/$roomId/interestedUsers/$userUid");

    await ref.set(true);
    hasApplied.value = true;
  }
}

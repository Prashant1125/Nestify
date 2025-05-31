import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Models/room_model.dart';

class MyRoomController extends GetxController {
  var myRooms = <RoomModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyRooms();
  }

  Future<void> fetchMyRooms() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref = FirebaseDatabase.instance.ref('rooms').child(uid);
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final tempList = data.values
          .map((e) => RoomModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      myRooms.value = tempList;
    } else {
      myRooms.clear();
    }
  }

  Future<void> deleteRoom(RoomModel room) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref =
        FirebaseDatabase.instance.ref('rooms').child(uid).child(room.roomId);
    await ref.remove();
    myRooms.removeWhere((r) => r.roomId == room.roomId);
  }
}

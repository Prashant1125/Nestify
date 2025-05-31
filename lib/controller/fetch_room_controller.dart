import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:home_for_rent/Models/room_model.dart';
import 'package:home_for_rent/api/auth_repo.dart';

class RoomController extends GetxController {
  RxList<RoomModel> roomList = <RoomModel>[].obs;
  final _dbRef = FirebaseDatabase.instance.ref('rooms');

  @override
  void onInit() {
    super.onInit();
    fetchRooms();
  }

  void fetchRooms() async {
    final dataSnapshot = await _dbRef.get();
    final data = dataSnapshot.value as Map?;
    if (data != null) {
      final List<RoomModel> loadedRooms = [];

      for (var userEntry in data.entries) {
        final Map userRooms = userEntry.value as Map;

        for (var roomEntry in userRooms.entries) {
          final roomData = Map<String, dynamic>.from(roomEntry.value);
          // ✅ Make sure phone is already inside roomData
          loadedRooms.add(RoomModel.fromMap(roomData));
        }
      }

      roomList.value = loadedRooms;
    } else {
      roomList.value = [];
    }
  }

  Future<void> deleteRoom(RoomModel room) async {
    await AuthRepo.deleteRoom(room);
    roomList.removeWhere((r) => r.roomId == room.roomId);
  }
}

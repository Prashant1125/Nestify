class RoomModel {
  String roomId;
  String title;
  String description;
  String rent;
  String roomType;
  String furnishingType;
  String location;
  String city;
  String state;
  String pinCode;
  List<String> amenities;
  List<String> images;
  String uid;
  int timestamp;
  String phone;

  RoomModel({
    required this.roomId,
    required this.title,
    required this.description,
    required this.rent,
    required this.roomType,
    required this.furnishingType,
    required this.location,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.amenities,
    required this.images,
    required this.uid,
    required this.timestamp,
    required this.phone,
  });

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      roomId: map['roomId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      rent: map['rent'] ?? '',
      roomType: map['roomType'] ?? '',
      furnishingType: map['furnishingType'] ?? '',
      location: map['location'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pinCode: map['pinCode'] ?? '',
      amenities: (map['amenities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      images: (map['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      uid: map['uid'] ?? '',
      timestamp: map['timestamp'] ?? 0,
      phone: map['phone'] ?? '',
    );
  }

  // Add this method:
  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'title': title,
      'description': description,
      'rent': rent,
      'roomType': roomType,
      'furnishingType': furnishingType,
      'location': location,
      'city': city,
      'state': state,
      'pinCode': pinCode,
      'amenities': amenities,
      'images': images,
      'uid': uid,
      'timestamp': timestamp,
      'phone': phone,
    };
  }
}

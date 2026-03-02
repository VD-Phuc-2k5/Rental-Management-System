enum RoomStatus { rented, vacant }

class UtilityMeterReading {
  final int oldReading;
  final int newReading;

  const UtilityMeterReading({
    required this.oldReading,
    required this.newReading,
  });

  int get consumption => newReading - oldReading;

  UtilityMeterReading copyWith({int? oldReading, int? newReading}) {
    return UtilityMeterReading(
      oldReading: oldReading ?? this.oldReading,
      newReading: newReading ?? this.newReading,
    );
  }
}

class RoomMeterData {
  final String id;
  final String roomNumber;
  final String hostelName;
  final RoomStatus status;
  final UtilityMeterReading electricity;
  final UtilityMeterReading water;

  const RoomMeterData({
    required this.id,
    required this.roomNumber,
    required this.hostelName,
    required this.status,
    required this.electricity,
    required this.water,
  });

  RoomMeterData copyWith({
    String? id,
    String? roomNumber,
    String? hostelName,
    RoomStatus? status,
    UtilityMeterReading? electricity,
    UtilityMeterReading? water,
  }) {
    return RoomMeterData(
      id: id ?? this.id,
      roomNumber: roomNumber ?? this.roomNumber,
      hostelName: hostelName ?? this.hostelName,
      status: status ?? this.status,
      electricity: electricity ?? this.electricity,
      water: water ?? this.water,
    );
  }
}

class UtilityMeterUpdateData {
  final String month;
  final List<RoomMeterData> rooms;

  const UtilityMeterUpdateData({required this.month, required this.rooms});

  List<String> get hostelNames {
    final names = rooms.map((r) => r.hostelName).toSet().toList();
    names.sort();
    return names;
  }

  List<RoomMeterData> getRoomsByHostel(String? hostelName) {
    if (hostelName == null) return rooms;
    return rooms.where((r) => r.hostelName == hostelName).toList();
  }
}

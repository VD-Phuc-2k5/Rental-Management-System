class ElectricWaterEntry {
  final String hostelName;
  final String roomNumber;
  final int oldElectric;
  final int newElectric;
  final int oldWater;
  final int newWater;

  const ElectricWaterEntry({
    required this.hostelName,
    required this.roomNumber,
    required this.oldElectric,
    required this.newElectric,
    required this.oldWater,
    required this.newWater,
  });

  /// Điện mới < điện cũ là lỗi
  bool get hasElectricError => newElectric < oldElectric;

  /// Nước mới < nước cũ là lỗi
  bool get hasWaterError => newWater < oldWater;

  bool get hasError => hasElectricError || hasWaterError;

  List<String> get errorMessages {
    final messages = <String>[];
    if (hasElectricError) {
      messages.add(
        'Lỗi: [$hostelName] - [Phòng $roomNumber]: Chỉ số điện mới nhỏ hơn chỉ số cũ.',
      );
    }
    if (hasWaterError) {
      messages.add(
        'Lỗi: [$hostelName] - [Phòng $roomNumber]: Chỉ số nước mới nhỏ hơn chỉ số cũ.',
      );
    }
    return messages;
  }

  /// Factory để parse từ JSON API
  factory ElectricWaterEntry.fromJson(Map<String, dynamic> json) {
    return ElectricWaterEntry(
      hostelName: json['hostelName'] as String,
      roomNumber: json['roomNumber'] as String,
      oldElectric: json['oldElectric'] as int,
      newElectric: json['newElectric'] as int,
      oldWater: json['oldWater'] as int,
      newWater: json['newWater'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'hostelName': hostelName,
    'roomNumber': roomNumber,
    'oldElectric': oldElectric,
    'newElectric': newElectric,
    'oldWater': oldWater,
    'newWater': newWater,
  };
}

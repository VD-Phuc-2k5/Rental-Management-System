import 'package:domain/room.dart';

class RoomImageModel extends RoomImageEntity {
  const RoomImageModel({
    required super.id,
    required super.url,
    required super.sortOrder,
  });

  factory RoomImageModel.fromJson(Map<String, dynamic> json) => RoomImageModel(
        id: json['id'] as String,
        url: json['url'] as String,
        sortOrder: json['sortOrder'] as int? ?? 0,
      );
}

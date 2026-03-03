import 'package:app/screens/booking-room-screen/components/my-booking-room/has-room/my_room_card.dart';
import 'package:flutter/material.dart';

class HasRoomBody extends StatelessWidget {
  const HasRoomBody({super.key});

  List<MyRoom> get _rooms => [
    MyRoom(
      imageUrl:
          'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=400',
      roomName: 'Phòng 101 - Khu A',
      address: '123 Đường ABC, Phường Bến Nghé, Quận 1',
      bookingTime: 'Thứ 3, 25/02/2026 - 10:00',
      status: BookingStatus.confirmed,
    ),
    MyRoom(
      imageUrl:
          'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=400',
      roomName: 'Phòng 101 - Khu A',
      address: '123 Đường ABC, Phường Bến Nghé, Quận 1',
      bookingTime: 'Thứ 3, 25/02/2026 - 10:00',
      status: BookingStatus.confirmed,
    ),
    MyRoom(
      imageUrl:
          'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=400',
      roomName: 'Phòng 101 - Khu A',
      address: '123 Đường ABC, Phường Bến Nghé, Quận 1',
      bookingTime: 'Thứ 3, 25/02/2026 - 10:00',
      status: BookingStatus.confirmed,
    ),
    MyRoom(
      imageUrl:
          'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=400',
      roomName: 'Phòng 101 - Khu A',
      address: '123 Đường ABC, Phường Bến Nghé, Quận 1',
      bookingTime: 'Thứ 3, 25/02/2026 - 10:00',
      status: BookingStatus.confirmed,
    ),
    MyRoom(
      imageUrl:
          'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=400',
      roomName: 'Phòng 101 - Khu A',
      address: '123 Đường ABC, Phường Bến Nghé, Quận 1',
      bookingTime: 'Thứ 3, 25/02/2026 - 10:00',
      status: BookingStatus.confirmed,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            MyRoomCard(rooms: _rooms),
          ],
        ),
      )
    );
  }
}
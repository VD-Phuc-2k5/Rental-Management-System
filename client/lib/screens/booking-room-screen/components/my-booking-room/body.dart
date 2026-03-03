import 'package:app/core/widgets/primary_button.dart';
import 'package:app/screens/booking-room-screen/components/my-booking-room/empty-room/empty_logo.dart';
import 'package:app/screens/home-screen/home_screen.dart';
import 'package:app/screens/booking-room-screen/components/my-booking-room/empty-room/empty_title.dart';
import 'package:app/screens/booking-room-screen/components/my-booking-room/has-room/my_room_card.dart';
import 'package:flutter/material.dart';

class RoomBody extends StatelessWidget {
  const RoomBody({super.key});

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
    return _rooms.isEmpty
        ? SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const EmptyLogo(),
                const SizedBox(height: 64),
                const EmptyTitle(),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: PrimaryButton(
                    label: "Tìm phòng ngay",
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: MyRoomCard(rooms: _rooms),
          );
  }
}

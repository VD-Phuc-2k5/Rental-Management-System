import '../booking-room-screen/booking_room_screen.dart';
import 'components/body.dart';
import 'components/confirm_book_room.dart';
import 'components/login_required_modal.dart';
import 'package:flutter/material.dart';

class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const SafeArea(
        child: SingleChildScrollView(
          child: RoomDetailBody(),
        ),
      ),
      bottomNavigationBar: ConfirmBookRoom(
        price: 2800000,
        onPressed: () {
          LoginRequiredModal.show(
            context,
            onLoginPressed: () {},
            onRegisterPressed: () {
              // Giả sử đã login
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookingRoomScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

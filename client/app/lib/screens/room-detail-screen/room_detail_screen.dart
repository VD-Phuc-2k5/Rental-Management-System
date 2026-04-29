import 'package:app/screens/booking-room-screen/booking_room_screen.dart';
import 'package:app/screens/login-screen/login_screen.dart';
import 'package:app/screens/room-detail-screen/components/body.dart';
import 'package:app/screens/room-detail-screen/components/confirm_book_room.dart';
import 'package:app/screens/room-detail-screen/components/login_required_modal.dart';
import 'package:flutter/material.dart';

class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: RoomDetailBody(),
        ),
      ),
      bottomNavigationBar: ConfirmBookRoom(
        price: 2800000,
        onPressed: () {
          LoginRequiredModal.show(
            context,
            onLoginPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
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
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
              // TODO: Navigate to login screen
              print('Navigate to login');
            },
            onRegisterPressed: () {
              // TODO: Navigate to register screen
              print('Navigate to register');
            },
          );
        },
      ),
    );
  }
}
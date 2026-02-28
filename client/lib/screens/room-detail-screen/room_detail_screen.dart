import 'package:app/screens/room-detail-screen/components/body.dart';
import 'package:app/screens/room-detail-screen/components/comfirm_book_room.dart';
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
      bottomNavigationBar: ComfirmBookRoom(
        price: 2800000,
        onPressed: () {
          // TODO: Navigate to booking screen
        },
      ),
    );
  }
}
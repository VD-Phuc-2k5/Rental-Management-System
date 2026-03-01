import 'package:app/core/constants.dart';
import 'package:app/screens/empty-hostel-screen//components/host_bottom_nav.dart';
import 'package:app/screens/empty-hostel-screen/components/empty_hostel_body.dart';
import 'package:flutter/material.dart';

class EmptyHostelScreen extends StatelessWidget {
  const EmptyHostelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray25,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        titleSpacing: 16.0,
        title: const Text(
          "Nhà trọ của tôi",
          style: TextStyle(
            color: AppColors.slate900,
            fontFamily: "Public Sans",
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.slate200, height: 1.0),
        ),
      ),

      body: const EmptyHostelBody(),
      bottomNavigationBar: const HostBottomNav(),
    );
  }
}

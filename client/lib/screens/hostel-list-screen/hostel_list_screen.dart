import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import 'package:app/screens/add-hostel-screen/add_hostel_screen.dart';
import 'package:app/screens/hostel-list-screen/components/hostel_list_body.dart';
import 'package:app/screens/empty-hostel-screen/components/host_bottom_nav.dart';

class HostelListScreen extends StatelessWidget {
  const HostelListScreen({super.key});

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
            fontFamily: "Nunito",
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 11.0, bottom: 11.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddHostelScreen()),
                );
              },
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.blue700),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "+ Thêm nhà trọ",
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.blue700,
                  ),
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.slate200, height: 1.0),
        ),
      ),
      body: const HostelListBody(),
      bottomNavigationBar: const HostBottomNav(),
    );
  }
}
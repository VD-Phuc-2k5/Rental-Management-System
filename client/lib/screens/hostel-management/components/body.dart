import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import '../add_hostel_screen.dart';
import 'dart:ui';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 131.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(
              width: 256,
              height: 256,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 32.0, sigmaY: 32.0),
                    child: Container(
                      width: 256,
                      height: 256,
                      decoration: BoxDecoration(
                        color: AppColors.blue700.withAlpha(13),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  Container(
                    width: 162.35,
                    height: 153.5,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(color: AppColors.slate100),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blue700.withAlpha(26),
                          blurRadius: 25,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.apartment, size: 96.0, color: AppColors.blue700),
                    ),
                  ),

                  Positioned(
                    bottom: 45,
                    right: 40,
                    child: Container(
                      width: 51,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 4.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withAlpha(26),
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.add_home, size: 20, color: AppColors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12.0),

            const Text(
              "Bạn chưa có nhà trọ nào",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Public Sans",
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: AppColors.slate900,
                height: 1.33,
              ),
            ),

            const SizedBox(height: 8.0),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.91),
              child: Text(
                "Bắt đầu quản lý kinh doanh bằng cách thêm nhà trọ đầu tiên của bạn.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Public Sans",
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 1.62,
                  color: AppColors.slate500,
                ),
              ),
            ),

            const SizedBox(height: 40.0),

            Container(
              width: 342,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blue700.withAlpha(64),
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddHostelScreen(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add, color: AppColors.white, size: 20),
                    SizedBox(width: 8.0),
                    Text(
                      "Thêm nhà trọ mới",
                      style: TextStyle(
                        fontFamily: "Public Sans",
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        height: 1.5,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
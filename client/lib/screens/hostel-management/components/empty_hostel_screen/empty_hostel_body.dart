import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import 'hostel_logo.dart';
import 'add_hostel_button.dart';

class EmptyHostelBody extends StatelessWidget {
  const EmptyHostelBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 131.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            HostelLogo(),
            SizedBox(height: 12.0),
            Text(
              "Bạn chưa có nhà trọ nào",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Public Sans",
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: AppColors.slate900,
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
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
            SizedBox(height: 40.0),
            AddHostelButton(),
          ],
        ),
      ),
    );
  }
}
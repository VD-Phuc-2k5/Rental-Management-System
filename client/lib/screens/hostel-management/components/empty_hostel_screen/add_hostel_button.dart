import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import 'package:app/screens/hostel-management/add_hostel_screen.dart';

class AddHostelButton extends StatelessWidget {
  const AddHostelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            MaterialPageRoute(builder: (context) => const AddHostelScreen()),
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
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
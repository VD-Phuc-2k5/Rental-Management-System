import 'package:app/core/constants.dart';
import 'package:app/screens/update-hostel-screen/components/update_hostel_body.dart';
import 'package:flutter/material.dart';

class UpdateHostelScreen extends StatelessWidget {
  const UpdateHostelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray25,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.slate900),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          "Cập nhật thông tin khu trọ",
          style: TextStyle(
            color: AppColors.slate900,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.slate200, height: 1.0),
        ),
      ),
      body: const UpdateHostelBody(),
    );
  }
}

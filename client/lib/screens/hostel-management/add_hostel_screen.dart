import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';
import 'components/add_hostel_screen/add_hostel_body.dart';

class AddHostelScreen extends StatelessWidget {
  const AddHostelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray25,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.slate700),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(right: 40.0),
          child: Text(
            "Thêm nhà trọ mới",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.slate900,
              fontFamily: "Public Sans",
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: -0.45,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.slate200, height: 1.0),
        ),
      ),
      body: const AddHostelBody(),
    );
  }
}
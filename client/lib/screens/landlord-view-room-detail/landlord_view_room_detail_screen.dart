import 'package:app/core/constants.dart';
import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/screens/landlord-view-room-detail/components/body.dart';
import 'package:app/screens/landlord-view-room-detail/components/response_submit_button.dart';
import 'package:flutter/material.dart';

class LandlordViewRoomDetailScreen extends StatelessWidget {
  const LandlordViewRoomDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: CommonAppBar(title: "Chi tiết yêu cầu"),
      body: SingleChildScrollView(
        child: LandlordViewRoomDetailBody(),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: AppColors.white,
        child: ResponseSubmitButton(
          onReject: () {},
          onConfirm: () {},
        ),
      ),
    );
  }
}
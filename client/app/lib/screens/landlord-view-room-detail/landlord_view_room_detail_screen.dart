import '../../core/constants.dart';
import '../../core/widgets/common_appbar.dart';
import 'components/body.dart';
import 'components/response_submit_button.dart';
import 'package:flutter/material.dart';

class LandlordViewRoomDetailScreen extends StatelessWidget {
  const LandlordViewRoomDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayBackground,
      appBar: const CommonAppBar(title: "Chi tiết yêu cầu"),
      body: const SingleChildScrollView(
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
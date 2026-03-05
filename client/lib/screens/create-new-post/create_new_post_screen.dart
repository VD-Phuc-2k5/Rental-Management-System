import 'package:app/core/constants.dart';
import 'package:app/core/widgets/common_appbar.dart';
import 'package:app/core/widgets/post_form/amenities_section.dart';
import 'package:app/core/widgets/post_form/basic_info_section.dart';
import 'package:app/core/widgets/post_form/description_section.dart';
import 'package:app/core/widgets/post_form/image_upload_section.dart';
import 'package:app/core/widgets/post_form/location_section.dart';
import 'package:app/core/widgets/post_form/post_form_bottom_bar.dart';
import 'package:flutter/material.dart';

class CreateNewPostScreen extends StatelessWidget {
  const CreateNewPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray25,
      appBar: const CommonAppBar(title: "Đăng tin mới"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ImageUploadSection(),
            SizedBox(height: 24),
            BasicInfoSection(),
            SizedBox(height: 24),
            LocationSection(),
            SizedBox(height: 24),
            AmenitiesSection(),
            SizedBox(height: 24),
            DescriptionSection(),
            SizedBox(height: 32),
            PostFormBottomBar(submitLabel: "Đăng tin mới"),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import 'step_progress.dart';
import 'section_title.dart';
import 'labeled_text_field.dart';
import 'upload_box.dart';
import 'dashed_button.dart';
import 'member_tile.dart';

class TenantInfoScreen extends StatefulWidget {
  const TenantInfoScreen({super.key});

  @override
  State<TenantInfoScreen> createState() => _TenantInfoScreenState();
}

class _TenantInfoScreenState extends State<TenantInfoScreen> {
  final nameCtl = TextEditingController();
  final dobCtl = TextEditingController();
  final cccdCtl = TextEditingController();
  final addressCtl = TextEditingController();
  final phoneCtl = TextEditingController();
  final emailCtl = TextEditingController();

  @override
  void dispose() {
    nameCtl.dispose();
    dobCtl.dispose();
    cccdCtl.dispose();
    addressCtl.dispose();
    phoneCtl.dispose();
    emailCtl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year + 1),
      initialDate: DateTime(2000, 1, 1),
    );
    if (picked != null) {
      dobCtl.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Thông tin khách thuê',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StepProgress(currentStep: 1, totalSteps: 3),
            const SizedBox(height: 14),

            const SectionTitle(text: 'THÔNG TIN KHÁCH THUÊ'),
            const SizedBox(height: 12),

            LabeledTextField(
              label: 'Họ và tên',
              requiredMark: true,
              controller: nameCtl,
              hintText: 'Nhập họ và tên',
            ),
            const SizedBox(height: 12),

            LabeledTextField(
              label: 'Ngày sinh',
              controller: dobCtl,
              hintText: 'dd/mm/yyyy',
              readOnly: true,
              suffixIcon: Icons.calendar_month_outlined,
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),

            LabeledTextField(
              label: 'Số CCCD',
              requiredMark: true,
              controller: cccdCtl,
              hintText: 'Nhập số CCCD',
            ),
            const SizedBox(height: 12),

            const Text(
              'Ảnh CCCD *',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Expanded(child: UploadBox(title: 'Mặt trước')),
                SizedBox(width: 12),
                Expanded(child: UploadBox(title: 'Mặt sau')),
              ],
            ),
            const SizedBox(height: 12),

            LabeledTextField(
              label: 'Địa chỉ thường trú',
              controller: addressCtl,
              hintText: 'Nhập địa chỉ',
              maxLines: 2,
            ),
            const SizedBox(height: 12),

            LabeledTextField(
              label: 'Số điện thoại',
              requiredMark: true,
              controller: phoneCtl,
              hintText: 'Nhập số điện thoại',
              keyboardType: TextInputType.phone,
              suffixIcon: Icons.call_outlined,
            ),
            const SizedBox(height: 12),

            LabeledTextField(
              label: 'Email',
              controller: emailCtl,
              hintText: 'Nhập địa chỉ email',
              keyboardType: TextInputType.emailAddress,
              suffixIcon: Icons.mail_outline,
            ),
            const SizedBox(height: 16),

            DashedButton(
              text: '+ Thêm thành viên',
              onPressed: () {},
            ),
            const SizedBox(height: 18),

            const SectionTitle(text: 'THÀNH VIÊN'),
            const SizedBox(height: 10),

            MemberTile(
              name: 'Trần Thị B',
              subtitle: 'Thành viên',
              actionText: 'Chọn làm trưởng phòng',
              onDelete: () {},
              selected: false,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(Color(0xFF1463FF)),
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
              shape: const WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
              ),
            ),
            child: const Text(
              'Tiếp theo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
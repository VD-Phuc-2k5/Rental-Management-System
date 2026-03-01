import 'package:flutter/material.dart';

import 'components/header.dart';
import 'components/info_form.dart';
import 'components/members.dart';
import 'components/bottom_bar.dart';
import '../form-info-parking-screen/parking_info__rent_screen.dart';

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
  void _goNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ParkingInfoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
            const TenantInfoHeader(step: 1, total: 3),
            const SizedBox(height: 14),

            TenantInfoForm(
              nameCtl: nameCtl,
              dobCtl: dobCtl,
              cccdCtl: cccdCtl,
              addressCtl: addressCtl,
              phoneCtl: phoneCtl,
              emailCtl: emailCtl,
              onPickDate: _pickDate,
            ),

            const SizedBox(height: 16),

            TenantMembersSection(
              members: const [
                TenantMember(name: 'Trần Thị B', role: 'Thành viên'),
              ],
              onAddMember: () {},
              onDeleteMember: (index) {},
              onSetLeader: (index) {},
            ),
          ],
        ),
      ),
      bottomNavigationBar: TenantBottomBar(
        onNext: () => _goNext(context),
      ),
    );
  }
}
import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/update-rental-contract-screen/components/contract_info_card.dart';
import 'package:app/screens/update-rental-contract-screen/components/member_list_section.dart';
import 'package:app/screens/update-rental-contract-screen/components/vehicle_list_section.dart';
import 'package:app/screens/update-rental-contract-screen/components/update_reason_section.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TextEditingController _reasonController = TextEditingController();

  // Sample data - Replace with actual data from your state management
  final List<Member> _members = [
    const Member(name: "Nguyễn Văn A", role: "Trưởng phòng", isLeader: true),
    const Member(name: "Trần Thị B", role: "Thành viên", isLeader: false),
  ];

  final List<Vehicle> _vehicles = [
    const Vehicle(name: "Xe máy Honda Vision", licensePlate: "59-A1 123.45"),
    const Vehicle(name: "Xe máy điện VinFast", licensePlate: "59-MD1 999.99"),
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _handleAddMember() {
    // TO DO: Implement add member logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Thêm thành viên')));
  }

  void _handleDeleteMember(int index) {
    setState(() {
      _members.removeAt(index);
    });
  }

  void _handleAddVehicle() {
    // TO DO: Implement add vehicle logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Thêm xe')));
  }

  void _handleDeleteVehicle(int index) {
    setState(() {
      _vehicles.removeAt(index);
    });
  }

  void _handleSubmit() {
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập lý do cập nhật')),
      );
      return;
    }

    // TO DO: Implement submit logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gửi yêu cầu cập nhật thành công')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const ContractInfoCard(
              roomName: "Phòng 101",
              roomImageUrl:
                  "assets/images/room-details-empty-screen/room_img1.png",
              startDate: "01/01/2026",
              endDate: "31/12/2026",
            ),
            const SizedBox(height: 24),
            MemberListSection(
              members: _members,
              onAddMember: _handleAddMember,
              onDeleteMember: _handleDeleteMember,
            ),
            const SizedBox(height: 24),
            VehicleListSection(
              vehicles: _vehicles,
              onAddVehicle: _handleAddVehicle,
              onDeleteVehicle: _handleDeleteVehicle,
            ),
            const SizedBox(height: 24),
            UpdateReasonSection(controller: _reasonController),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue700,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Gửi yêu cầu cập nhật',
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

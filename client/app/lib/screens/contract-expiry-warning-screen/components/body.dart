import 'package:app/core/constants.dart';
import 'package:app/screens/contract-extension-request-screen/contract_extension_request_screen.dart';
import 'package:app/screens/home-screen/home_screen.dart';
import 'package:app/screens/contract-expiry-warning-screen/components/contract_action_button.dart';
import 'package:app/screens/contract-expiry-warning-screen/components/contract_expiry_header.dart';
import 'package:app/screens/contract-expiry-warning-screen/components/countdown_widget.dart';
import 'package:app/screens/update-rental-contract-screen/update_rental_contract_screen.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  // Calculate days remaining until contract expiry
  int _calculateDaysRemaining(DateTime expiryDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiryDateOnly = DateTime(
      expiryDate.year,
      expiryDate.month,
      expiryDate.day,
    );
    final dayDifference = expiryDateOnly.difference(today).inDays;
    if (dayDifference < 0) return 0;
    return dayDifference;
  }

  void _handleExtendContract(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ContractExtensionRequestScreen()),
    );
  }

  void _handleUpdateContract(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const UpdateRentalContractScreen()),
    );
  }

  void _handleEndContract(BuildContext context) {
    // TO DO: Navigate to contract termination screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Chức năng kết thúc hợp đồng đang được phát triển"),
        backgroundColor: AppColors.red600,
      ),
    );
  }

  Future<void> _handleRemindLater(BuildContext context) async {
    // TO DO: Set reminder for 3 days later and close screen
    final messenger = ScaffoldMessenger.of(context);

    final controller = messenger.showSnackBar(
      const SnackBar(
        content: Text("Sẽ nhắc lại sau 3 ngày"),
        backgroundColor: AppColors.green600,
      ),
    );

    await controller.closed;

    if (!context.mounted) return;

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      spacing: 12.0,
      children: [
        ContractActionButton(
          icon: Icons.description_outlined,
          title: "Gia hạn hợp đồng",
          subtitle: "Tiếp tục thuê phòng này",
          backgroundColor: AppColors.white,
          textColor: AppColors.blue700,
          iconColor: AppColors.blue700,
          onPressed: () => _handleExtendContract(context),
        ),
        ContractActionButton(
          icon: Icons.edit_note,
          title: "Cập nhật hợp đồng",
          subtitle: "Sửa đổi thông tin hợp đồng",
          backgroundColor: AppColors.white,
          textColor: AppColors.blue700,
          iconColor: AppColors.blue700,
          onPressed: () => _handleUpdateContract(context),
        ),
        ContractActionButton(
          icon: Icons.home_outlined,
          title: "Kết thúc hợp đồng",
          subtitle: "Trả phòng và thanh lý",
          backgroundColor: AppColors.red50,
          textColor: AppColors.red600,
          iconColor: AppColors.red600,
          onPressed: () => _handleEndContract(context),
        ),
      ],
    );
  }

  Widget _buildRemindLaterButton(BuildContext context) {
    return TextButton(
      onPressed: () => _handleRemindLater(context),
      child: const Text(
        "Nhắc lại sau 3 ngày",
        style: TextStyle(
          fontFamily: "Inter",
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.slate500,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.slate500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TO DO: Replace with actual data from contract model
    const String roomNumber = "101";
    final DateTime expiryDate = DateTime(2026, 3, 31);
    final int daysRemaining = _calculateDaysRemaining(expiryDate);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          spacing: 24.0,
          children: [
            ContractExpiryHeader(
              roomNumber: roomNumber,
              expiryDate: expiryDate,
            ),
            CountdownWidget(daysRemaining: daysRemaining),
            _buildActionButtons(context),
            const SizedBox(height: 8),
            _buildRemindLaterButton(context),
          ],
        ),
      ),
    );
  }
}

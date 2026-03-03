import 'package:app/core/constants.dart';
import 'package:app/screens/contract-extension-request-screen/components/extension_period_dropdown.dart';
import 'package:app/screens/contract-extension-request-screen/components/info_message.dart';
import 'package:app/screens/contract-extension-request-screen/components/new_start_date_picker.dart';
import 'package:app/screens/contract-extension-request-screen/components/note_input_field.dart';
import 'package:app/screens/contract-extension-request-screen/components/room_info_card.dart';
import 'package:app/screens/contract-extension-request-screen/components/submit_button.dart';
import 'package:app/screens/home-screen/home_screen.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // State variables
  int _selectedMonths = 12;
  late DateTime _selectedStartDate;
  late DateTime _contractExpiryDate;
  final TextEditingController _noteController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize dates
    _contractExpiryDate = DateTime(2026, 3, 31);
    // Default start date is one day after contract expiry
    _selectedStartDate = _contractExpiryDate.add(Duration(days: 1));
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _handleExtensionPeriodChanged(int? months) {
    if (months != null) {
      setState(() {
        _selectedMonths = months;
      });
    }
  }

  void _handleStartDateChanged(DateTime date) {
    setState(() {
      _selectedStartDate = date;
    });
  }

  void _handleSubmit() {
    // Validate form
    if (_selectedStartDate.isBefore(_contractExpiryDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ngày bắt đầu phải sau ngày hết hạn hợp đồng cũ'),
          backgroundColor: AppColors.red500,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã gửi yêu cầu gia hạn thành công!'),
            backgroundColor: AppColors.green500,
          ),
        );

        // Navigate back after success
        Future.delayed(Duration(seconds: 1), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 20.0,
          children: [
            // Room information card
            RoomInfoCard(
              roomName: "Phòng 301",
              hostelName: "Khu trọ Hạnh Phúc",
              contractExpiryDate: "31/03/2026",
            ),

            // Extension period dropdown
            ExtensionPeriodDropdown(
              selectedMonths: _selectedMonths,
              onChanged: _handleExtensionPeriodChanged,
            ),

            // New start date picker
            NewStartDatePicker(
              selectedDate: _selectedStartDate,
              onDateChanged: _handleStartDateChanged,
              contractExpiryDate: _contractExpiryDate,
            ),

            // Note input field
            NoteInputField(
              controller: _noteController,
              label: "Ghi chú cho chủ trọ",
              hintText:
                  "Nhận lời nhắn của bạn... Ví dụ: Tôi muốn lập thêm điều hòa mới nếu gia hạn thêm 1 năm.",
            ),

            // Info message
            InfoMessage(
              message:
                  "Chủ trọ sẽ xem xét yêu cầu và gửi lại hợp đồng qua ứng dụng để bạn ký xác nhận online.",
            ),

            // Submit button
            SubmitButton(
              label: "Gửi yêu cầu gia hạn",
              onPressed: _handleSubmit,
              isLoading: _isLoading,
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

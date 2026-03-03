import 'package:app/core/constants.dart';
import 'package:app/core/models/maintenance_request.dart';
import 'package:app/screens/landlord-maintenance-schedule-screen/components/notification_info_box.dart';
import 'package:app/screens/landlord-maintenance-schedule-screen/components/request_detail_section.dart';
import 'package:app/screens/landlord-maintenance-schedule-screen/components/schedule_section.dart';
import 'package:app/screens/landlord-maintenance-schedule-screen/components/technician_info_section.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final MaintenanceRequest request;
  const Body({super.key, required this.request});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _technicianNameController = TextEditingController();
  final _technicianPhoneController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _technicianNameController.dispose();
    _technicianPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.blue700,
              onPrimary: AppColors.white,
              onSurface: AppColors.slate900,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.blue700,
              onPrimary: AppColors.white,
              onSurface: AppColors.slate900,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  bool _validateForm() {
    if (_technicianNameController.text.trim().isEmpty) {
      _showMessage("Vui lòng nhập tên thợ sửa chữa");
      return false;
    }

    if (_technicianPhoneController.text.trim().isEmpty) {
      _showMessage("Vui lòng nhập số điện thoại thợ");
      return false;
    }

    final phonePattern = RegExp(r'^0\d{9}$');
    if (!phonePattern.hasMatch(_technicianPhoneController.text.trim())) {
      _showMessage("Số điện thoại không hợp lệ");
      return false;
    }

    if (_selectedDate == null) {
      _showMessage("Vui lòng chọn ngày hẹn sửa");
      return false;
    }

    if (_selectedTime == null) {
      _showMessage("Vui lòng chọn giờ hẹn");
      return false;
    }

    return true;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _submitSchedule() async {
    if (!_validateForm()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // TODO: Implement API call to save maintenance schedule
      // Include:
      // - request.id
      // - _technicianNameController.text
      // - _technicianPhoneController.text
      // - _notesController.text
      // - _selectedDate
      // - _selectedTime

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      _showMessage("Lưu lịch sửa chữa thành công");

      // Navigate back after successful submission
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        _showMessage("Lỗi khi lưu lịch: $e");
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 16.0,
                children: [
                  RequestDetailSection(request: widget.request),
                  TechnicianInfoSection(
                    nameController: _technicianNameController,
                    phoneController: _technicianPhoneController,
                    notesController: _notesController,
                  ),
                  ScheduleSection(
                    selectedDate: _selectedDate,
                    selectedTime: _selectedTime,
                    onSelectDate: _selectDate,
                    onSelectTime: _selectTime,
                  ),
                  NotificationInfoBox(roomNumber: widget.request.location),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withAlpha(26),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSubmitting
                      ? AppColors.slate400
                      : AppColors.blue700,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: _isSubmitting ? null : _submitSchedule,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 8.0,
                        children: const [
                          Icon(Icons.send_outlined, color: AppColors.white),
                          Text(
                            "Lưu & Gửi thông báo",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

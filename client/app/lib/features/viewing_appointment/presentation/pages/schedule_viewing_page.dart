import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants.dart';
import '../../../../core/di/di.dart';
import '../blocs/schedule_viewing/schedule_viewing_bloc.dart';

class ScheduleViewingPage extends StatelessWidget {
  const ScheduleViewingPage({super.key, required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ScheduleViewingBloc>(),
      child: _ScheduleViewingView(roomId: roomId),
    );
  }
}

class _ScheduleViewingView extends StatefulWidget {
  const _ScheduleViewingView({required this.roomId});

  final String roomId;

  @override
  State<_ScheduleViewingView> createState() => _ScheduleViewingViewState();
}

class _ScheduleViewingViewState extends State<_ScheduleViewingView> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.blue700),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.blue700),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _submit() {
    if (_selectedDate == null || _selectedTime == null) return;

    final dt = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final now = DateTime.now();
    if (dt.isBefore(now.add(const Duration(minutes: 30)))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn thời gian cách hiện tại ít nhất 30 phút!'),
          backgroundColor: AppColors.red500,
        ),
      );
      return;
    }

    context.read<ScheduleViewingBloc>().add(
      ScheduleViewingSubmitted(
        roomId: widget.roomId,
        scheduledAt: dt.toUtc().toIso8601String(),
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScheduleViewingBloc, ScheduleViewingState>(
      listener: (context, state) {
        if (state is ScheduleViewingLoadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đặt lịch xem phòng thành công!'),
              backgroundColor: AppColors.green700,
            ),
          );
          context.pop();
        } else if (state is ScheduleViewingLoadFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.toString()),
              backgroundColor: AppColors.red500,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.blue700),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Đặt lịch xem phòng',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chọn ngày',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                _PickerTile(
                  icon: Icons.calendar_today_outlined,
                  label: _selectedDate == null
                      ? 'Chọn ngày xem phòng'
                      : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                  hasValue: _selectedDate != null,
                  onTap: _pickDate,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Chọn giờ',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                _PickerTile(
                  icon: Icons.access_time_outlined,
                  label: _selectedTime == null
                      ? 'Chọn giờ xem phòng'
                      : _selectedTime!.format(context),
                  hasValue: _selectedTime != null,
                  onTap: _pickTime,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Ghi chú (tuỳ chọn)',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Nhập ghi chú cho chủ trọ...',
                    hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: AppColors.slate400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.slate200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.slate200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: AppColors.blue700, width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
                const Spacer(),
                BlocBuilder<ScheduleViewingBloc, ScheduleViewingState>(
                  builder: (context, state) {
                    final isLoading = state is ScheduleViewingLoadInProgress;
                    final canSubmit =
                        _selectedDate != null && _selectedTime != null;
                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: (canSubmit && !isLoading) ? _submit : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue700,
                          disabledBackgroundColor: AppColors.slate200,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Xác nhận đặt lịch',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.icon,
    required this.label,
    required this.hasValue,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool hasValue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: hasValue ? AppColors.blue700 : AppColors.slate200,
          ),
          borderRadius: BorderRadius.circular(12),
          color: hasValue ? AppColors.blue50 : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: hasValue ? AppColors.blue700 : AppColors.slate400,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: hasValue ? AppColors.blue700 : AppColors.slate400,
                fontWeight:
                    hasValue ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

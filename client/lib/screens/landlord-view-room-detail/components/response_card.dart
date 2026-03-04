import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';

class ResponseCard extends StatefulWidget {
  final String scheduledDate;
  final ValueChanged<DateTime>? onDateTimeChanged;
  final ValueChanged<String>? onNoteChanged;

  const ResponseCard({
    super.key,
    required this.scheduledDate,
    this.onDateTimeChanged,
    this.onNoteChanged,
  });

  @override
  State<ResponseCard> createState() => _ResponseCardState();
}

class _ResponseCardState extends State<ResponseCard> {
  late DateTime _selectedDateTime;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDateTime = _parse(widget.scheduledDate);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  DateTime _parse(String raw) {
    try {
      final withoutDay = raw.contains(',') ? raw.split(', ').last : raw;
      final parts = withoutDay.trim().split(' ');
      final dateParts = parts[0].split('/');
      final timeParts = parts.length > 1 ? parts[1].split(':') : ['0', '0'];
      return DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    } catch (_) {
      return DateTime.now();
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('vi'),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
      widget.onDateTimeChanged?.call(_selectedDateTime);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _selectedDateTime.hour,
        minute: _selectedDateTime.minute,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
      widget.onDateTimeChanged?.call(_selectedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(18),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: AppColors.slate200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phản hồi của bạn',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ngày xác nhận',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.slate600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.slate200),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: AppColors.slate400,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formatDate(_selectedDateTime),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.slate700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Giờ',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.slate600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: _pickTime,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.slate200),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time_outlined,
                              size: 16,
                              color: AppColors.slate400,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formatTime(_selectedDateTime),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.slate700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Ghi chú phản hồi (tùy chọn)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.slate600,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _noteController,
            minLines: 3,
            maxLines: 5,
            onChanged: widget.onNoteChanged,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.slate700,
            ),
            decoration: InputDecoration(
              hintText: 'Nhập ghi chú cho người thuê...',
              hintStyle: const TextStyle(
                fontSize: 14,
                color: AppColors.slate400,
              ),
              contentPadding: const EdgeInsets.all(12),
              filled: true,
              fillColor: AppColors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.slate200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.blue500, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

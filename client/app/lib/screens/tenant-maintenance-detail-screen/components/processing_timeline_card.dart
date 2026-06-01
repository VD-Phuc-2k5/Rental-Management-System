import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import 'package:intl/intl.dart';
import '../../../core/models/maintenance_request.dart';
class ProcessingTimelineCard extends StatelessWidget {
  const ProcessingTimelineCard({
    super.key,
     required this.request,});

  final MaintenanceRequest request;

  @override
  Widget build(BuildContext context) {
    final createdAtText = DateFormat('HH:mm, dd/MM/yyyy').format(request.createdAt);

    final scheduledAtText = request.scheduledAt == null
        ? ''
        : DateFormat('HH:mm, dd/MM/yyyy').format(request.scheduledAt!);

    final hasSchedule = request.scheduledAt != null ||
        request.status == RequestStatus.processing ||
        request.status == RequestStatus.completed;

    final isCompleted = request.status == RequestStatus.completed;
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child:  Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TIẾN ĐỘ XỬ LÝ',
              style: TextStyle(
                color: AppColors.slate500,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 12),

            _TimelineItem(
              state: _TimelineState.done,
              title: 'Tiếp nhận yêu cầu',
              subtitle: createdAtText,
              isLast: false,
            ),
            _TimelineItem(
              state: hasSchedule ? _TimelineState.done : _TimelineState.todo,
              title: 'Đã lên lịch',
              subtitle: scheduledAtText,
              isLast: false,
            ),
            _TimelineItem(
              state: request.status == RequestStatus.processing
                  ? _TimelineState.current
                  : isCompleted
                      ? _TimelineState.done
                      : _TimelineState.todo,
              title: 'Đang xử lý',
              subtitle: request.status == RequestStatus.processing
                  ? 'Sự cố đang được xử lý'
                  : '',
              isLast: false,
            ),
            _TimelineItem(
              state: isCompleted ? _TimelineState.done : _TimelineState.todo,
              title: 'Hoàn thành',
              subtitle: isCompleted ? 'Sự cố đã được hoàn thành' : '',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}

enum _TimelineState { done, current, todo }

class _TimelineItem extends StatelessWidget {

  const _TimelineItem({
    required this.state,
    required this.title,
    required this.subtitle,
    required this.isLast,
  });
  final _TimelineState state;
  final String title;
  final String subtitle;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final isDone = state == _TimelineState.done;
    final isCurrent = state == _TimelineState.current;

    final dotBg = isDone
        ? AppColors.green100
        : isCurrent
            ? AppColors.green400
            : AppColors.gray100;

    final dotIcon = isDone
        ? Icons.check
        : isCurrent
            ? Icons.play_arrow_rounded
            : Icons.flag_outlined;

    final dotIconColor = isDone
        ? AppColors.green600
        : isCurrent
            ? AppColors.white
            : AppColors.gray500;

    final titleColor = isCurrent
        ? AppColors.green400
        : isDone
            ? AppColors.blue950
            : AppColors.gray400;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 30,
          child: Column(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(color: dotBg, shape: BoxShape.circle),
                child: Icon(dotIcon, size: 16, color: dotIconColor),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 34,
                  color: AppColors.green200,
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.slate500,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      height: 1.2,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
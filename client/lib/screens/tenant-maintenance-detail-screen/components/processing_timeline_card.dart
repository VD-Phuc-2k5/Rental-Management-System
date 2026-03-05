import 'package:flutter/material.dart';
import 'package:app/core/constants.dart';

class ProcessingTimelineCard extends StatelessWidget {
  const ProcessingTimelineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'TIẾN ĐỘ XỬ LÝ',
              style: TextStyle(
                color: AppColors.slate500,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(height: 12),

            _TimelineItem(
              state: _TimelineState.done,
              title: 'Tiếp nhận yêu cầu',
              subtitle: '09:30, 19/10/2023',
              isLast: false,
            ),
            _TimelineItem(
              state: _TimelineState.done,
              title: 'Đã lên lịch',
              subtitle: '10:15, 19/10/2023',
              isLast: false,
            ),
            _TimelineItem(
              state: _TimelineState.current,
              title: 'Chờ xác nhận',
              subtitle: 'Vui lòng kiểm tra kết quả bên dưới',
              isLast: false,
            ),
            _TimelineItem(
              state: _TimelineState.todo,
              title: 'Hoàn thành',
              subtitle: '',
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
  final _TimelineState state;
  final String title;
  final String subtitle;
  final bool isLast;

  const _TimelineItem({
    required this.state,
    required this.title,
    required this.subtitle,
    required this.isLast,
  });

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

    final subColor = isCurrent ? AppColors.slate500 : AppColors.slate500;

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
                    style: TextStyle(
                      color: isCurrent ? AppColors.slate500 : subColor,
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
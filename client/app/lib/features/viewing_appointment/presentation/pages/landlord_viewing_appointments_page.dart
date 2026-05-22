import 'package:domain/viewing_appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants.dart';
import '../../../../core/di/di.dart';
import '../../../../core/utils/sealed_class_state.dart';
import '../../../../core/widgets/landlord_navigation_bottom.dart';
import '../blocs/landlord_viewing_appointment_list/landlord_viewing_appointment_list_bloc.dart';

class LandlordViewingAppointmentsPage extends StatelessWidget {
  const LandlordViewingAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LandlordViewingAppointmentListBloc>()
        ..add(LandlordViewingAppointmentListFetched()),
      child: const _LandlordViewingAppointmentsView(),
    );
  }
}

class _LandlordViewingAppointmentsView extends StatelessWidget {
  const _LandlordViewingAppointmentsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Lịch xem phòng',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.blue700),
            onPressed: () => context
                .read<LandlordViewingAppointmentListBloc>()
                .add(LandlordViewingAppointmentListFetched()),
          ),
        ],
      ),
      bottomNavigationBar: const LandlordNavigationBottom(currentIndex: 2),
      body: BlocBuilder<LandlordViewingAppointmentListBloc,
          LandlordViewingAppointmentListState>(
        builder: (context, state) {
          final list = state.currentOrPreviousData;
          final isLoading =
              state is LandlordViewingAppointmentListLoadInProgress;

          if (state is LandlordViewingAppointmentListInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LandlordViewingAppointmentListLoadFailure &&
              list == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.failure.toString(),
                    style: const TextStyle(color: AppColors.red500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context
                        .read<LandlordViewingAppointmentListBloc>()
                        .add(LandlordViewingAppointmentListFetched()),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }
          if (list != null && list.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có lịch xem phòng nào.',
                style: TextStyle(color: AppColors.slate500),
              ),
            );
          }
          return RefreshIndicator(
            color: AppColors.blue700,
            onRefresh: () async => context
                .read<LandlordViewingAppointmentListBloc>()
                .add(LandlordViewingAppointmentListFetched()),
            child: Stack(
              children: [
                ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list?.length ?? 0,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      _ViewingAppointmentCard(appointment: list![index]),
                ),
                if (isLoading)
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(color: AppColors.blue700),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ViewingAppointmentCard extends StatelessWidget {
  const _ViewingAppointmentCard({required this.appointment});

  final ViewingAppointmentEntity appointment;

  @override
  Widget build(BuildContext context) {
    final scheduledDt = DateTime.tryParse(appointment.scheduledAt)?.toLocal();
    final dateStr = scheduledDt != null
        ? DateFormat('dd/MM/yyyy – HH:mm').format(scheduledDt)
        : appointment.scheduledAt;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.slate200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month,
                    size: 18, color: AppColors.blue700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    dateStr,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ),
                _StatusChip(status: appointment.status),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Mã phòng: ${appointment.roomId}',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppColors.slate500,
              ),
            ),
            if (appointment.note != null && appointment.note!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Ghi chú: ${appointment.note}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.slate500,
                ),
              ),
            ],
            if (appointment.status == ViewingAppointmentStatus.pending) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context
                          .read<LandlordViewingAppointmentListBloc>()
                          .add(LandlordViewingAppointmentRejected(
                              id: appointment.id)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.red500,
                        side: const BorderSide(color: AppColors.red500),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Từ chối'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context
                          .read<LandlordViewingAppointmentListBloc>()
                          .add(LandlordViewingAppointmentApproved(
                              id: appointment.id)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Chấp nhận'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final ViewingAppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      ViewingAppointmentStatus.pending => (
          'Chờ duyệt',
          AppColors.amber100,
          AppColors.amber500,
        ),
      ViewingAppointmentStatus.approved => (
          'Đã duyệt',
          AppColors.green100,
          AppColors.green700,
        ),
      ViewingAppointmentStatus.rejected => (
          'Từ chối',
          AppColors.red100,
          AppColors.red500,
        ),
      ViewingAppointmentStatus.cancelled => (
          'Đã huỷ',
          AppColors.slate100,
          AppColors.slate500,
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

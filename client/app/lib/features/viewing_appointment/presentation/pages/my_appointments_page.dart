import 'package:domain/viewing_appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/router/route_constants.dart';
import '../../../../core/constants.dart';
import '../../../../core/di/di.dart';
import '../../../../core/utils/sealed_class_state.dart';
import '../../../../core/widgets/tenant_navigation_bottom.dart';
import '../blocs/my_viewing_appointment_list/my_viewing_appointment_list_bloc.dart';

class MyAppointmentsPage extends StatelessWidget {
  const MyAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<MyViewingAppointmentListBloc>()
            ..add(MyViewingAppointmentListFetched()),
      child: const _MyAppointmentsView(),
    );
  }
}

class _MyAppointmentsView extends StatelessWidget {
  const _MyAppointmentsView();

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
          BlocBuilder<
            MyViewingAppointmentListBloc,
            MyViewingAppointmentListState
          >(
            builder: (context, state) => IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.blue700),
              onPressed: () => context.read<MyViewingAppointmentListBloc>().add(
                MyViewingAppointmentListFetched(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const TenantNavigationBottom(currentIndex: 1),
      body:
          BlocBuilder<
            MyViewingAppointmentListBloc,
            MyViewingAppointmentListState
          >(
            builder: (context, state) {
              final list = state.currentOrPreviousData;
              final isLoading = state is MyViewingAppointmentListLoadInProgress;

              if (state is MyViewingAppointmentListInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is MyViewingAppointmentListLoadFailure &&
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
                            .read<MyViewingAppointmentListBloc>()
                            .add(MyViewingAppointmentListFetched()),
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                );
              }
              if (list != null && list.isEmpty) {
                return const Center(
                  child: Text(
                    'Bạn chưa có lịch xem phòng nào.',
                    style: TextStyle(color: AppColors.slate500),
                  ),
                );
              }
              return RefreshIndicator(
                color: AppColors.blue700,
                onRefresh: () async => context
                    .read<MyViewingAppointmentListBloc>()
                    .add(MyViewingAppointmentListFetched()),
                child: Stack(
                  children: [
                    ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: list?.length ?? 0,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _AppointmentCard(appointment: list![index]),
                    ),
                    if (isLoading)
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(
                          color: AppColors.blue700,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.appointment});

  final ViewingAppointmentEntity appointment;

  String _formatRent(String rent) {
    final value = double.tryParse(rent);
    if (value == null) return rent;
    final formatted = value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return '$formatted đ/tháng';
  }

  @override
  Widget build(BuildContext context) {
    final scheduledDt = DateTime.tryParse(appointment.scheduledAt)?.toLocal();
    final dateStr = scheduledDt != null
        ? DateFormat('dd/MM/yyyy – HH:mm').format(scheduledDt)
        : appointment.scheduledAt;

    return Card(
      color: Colors.white,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (appointment.roomTitle != null) ...[
                        Text(
                          appointment.roomTitle!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      if (appointment.roomMonthlyRent != null) ...[
                        Text(
                          _formatRent(appointment.roomMonthlyRent!),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blue700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                _StatusChip(status: appointment.status),
              ],
            ),
            if (appointment.roomAddress != null) ...[
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: AppColors.slate400,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      appointment.roomAddress!,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.slate500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  size: 14,
                  color: AppColors.slate400,
                ),
                const SizedBox(width: 4),
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: AppColors.slate600,
                  ),
                ),
              ],
            ),
            if (appointment.note != null && appointment.note!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.notes_outlined,
                    size: 14,
                    color: AppColors.slate400,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      appointment.note!,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.slate500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (appointment.status == ViewingAppointmentStatus.approved) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: appointment.hasRentalRequest
                    ? ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.slate200,
                          foregroundColor: AppColors.slate500,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Đã duyệt',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          await context.pushNamed(
                            RouteNames.rentalRequestWizard,
                            extra: {'roomId': appointment.roomId},
                          );
                          if (context.mounted) {
                            context
                                .read<MyViewingAppointmentListBloc>()
                                .add(MyViewingAppointmentListFetched());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Thuê trọ',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
            ],
            if (appointment.status == ViewingAppointmentStatus.pending) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context
                      .read<MyViewingAppointmentListBloc>()
                      .add(MyViewingAppointmentCancelled(id: appointment.id)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.red500,
                    side: const BorderSide(color: AppColors.red500),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Huỷ lịch'),
                ),
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

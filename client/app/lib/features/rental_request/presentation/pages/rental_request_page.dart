import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants.dart';
import '../../../../core/di/di.dart';
import '../blocs/create_rental_request/create_rental_request_bloc.dart';

class RentalRequestPage extends StatelessWidget {
  const RentalRequestPage({super.key, required this.roomId});

  final String roomId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreateRentalRequestBloc>(),
      child: _RentalRequestView(roomId: roomId),
    );
  }
}

class _RentalRequestView extends StatefulWidget {
  const _RentalRequestView({required this.roomId});

  final String roomId;

  @override
  State<_RentalRequestView> createState() => _RentalRequestViewState();
}

class _RentalRequestViewState extends State<_RentalRequestView> {
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateRentalRequestBloc, CreateRentalRequestState>(
      listener: (context, state) {
        if (state is CreateRentalRequestLoadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gửi yêu cầu thuê thành công!')),
          );
          context.pop();
        } else if (state is CreateRentalRequestLoadFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.failure.toString())),
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
            'Gửi yêu cầu thuê',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ghi chú (tuỳ chọn)',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Nhập ghi chú cho chủ trọ...',
                  hintStyle: const TextStyle(color: AppColors.slate400),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.slate300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.blue700),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            BlocBuilder<CreateRentalRequestBloc, CreateRentalRequestState>(
          builder: (context, state) {
            final isLoading = state is CreateRentalRequestLoadInProgress;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            final note = _noteController.text.trim();
                            context.read<CreateRentalRequestBloc>().add(
                                  CreateRentalRequestSubmitted(
                                    roomId: widget.roomId,
                                    note: note.isEmpty ? null : note,
                                  ),
                                );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Gửi yêu cầu',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

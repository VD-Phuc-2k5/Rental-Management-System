import 'package:core/constants.dart';
import 'package:domain/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/router/route_constants.dart';
import '../../../../core/di/di.dart';
import '../../../../core/widgets/landlord_navigation_bottom.dart';
import '../../../../core/widgets/tenant_navigation_bottom.dart';
import '../../../auth/presentation/blocs/authentication/authentication_bloc.dart';
import '../blocs/get_profile/get_profile_bloc.dart';
import '../widgets/profile_action_card_widget.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/profile_info_card_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GetProfileBloc>()..add(const GetProfileFetched()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray25,
      bottomNavigationBar: BlocBuilder<GetProfileBloc, GetProfileState>(
        builder: (context, state) {
          if (state is GetProfileLoadSuccess &&
              state.data.role == 'landlord') {
            return const LandlordNavigationBottom(currentIndex: 4);
          }
          return const TenantNavigationBottom(currentIndex: 4);
        },
      ),
      body: BlocBuilder<GetProfileBloc, GetProfileState>(
        builder: (context, state) => switch (state) {
          GetProfileLoadInProgress() => const _ProfileLoading(),
          GetProfileLoadSuccess(:final data) => _ProfileContent(profile: data),
          GetProfileLoadFailure(:final failure) =>
            _ProfileError(message: failure.message),
          GetProfileInitial() => const SizedBox.shrink(),
        },
      ),
    );
  }
}

class _ProfileLoading extends StatelessWidget {
  const _ProfileLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.red500, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                color: AppColors.slate700,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  context.read<GetProfileBloc>().add(const GetProfileFetched()),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.profile});

  final UserProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: topPadding + 240,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.blue700, Color(0xFF2E86DE)],
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: topPadding + 10),
              Stack(
                children: [
                  ProfileHeaderWidget(profile: profile),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.white,
                      ),
                      tooltip: 'Chỉnh sửa hồ sơ',
                      onPressed: () async {
                        final updated =
                            await context.push<UserProfileEntity>(
                          RoutePaths.editProfile,
                          extra: profile,
                        );
                        if (updated != null && context.mounted) {
                          context
                              .read<GetProfileBloc>()
                              .add(const GetProfileFetched());
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    ProfileInfoCardWidget(profile: profile),
                    const SizedBox(height: 20),
                    ProfileActionCardWidget(
                      onChangePassword: () => context.push(
                        RoutePaths.forgotPassword,
                        extra: {'step': '1'},
                      ),
                      onSupport: () {},
                      onLogout: () => context
                          .read<AuthenticationBloc>()
                          .add(AuthenticationLogoutRequested()),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

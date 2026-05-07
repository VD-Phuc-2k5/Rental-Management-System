import 'package:core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/blocs/authentication/authentication_bloc.dart';
import '../config/router/route_constants.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    final loggedIn = context.watch<AuthenticationBloc>().state.user != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Trang Không Tồn Tại')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                error?.toString() ?? 'Trang bạn đang tìm kiếm không tồn tại.',
                style: const TextStyle(fontSize: 18, color: AppColors.red500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final path = loggedIn ? RoutePaths.home : RoutePaths.login;
                  context.go(path);
                },
                child: Text(
                  loggedIn ? 'Quay lại trang chủ' : 'Đăng nhập ngay!',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/router/route_constants.dart';
import '../../../../core/di/di.dart';
import '../../../../core/widgets/common_appbar.dart';
import '../blocs/register_landlord/register_landlord_bloc.dart';
import '../widgets/register_landlord_form.dart';
import '../widgets/register_logo.dart';

class RegisterLandlordPage extends StatelessWidget {
  const RegisterLandlordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RegisterLandlordBloc>(),
      child: const RegisterLandlordView(),
    );
  }
}

class RegisterLandlordView extends StatelessWidget {
  const RegisterLandlordView({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: const Scaffold(
        appBar: CommonAppBar(
          title: "Đăng ký chủ trọ",
          prevRouteName: RouteNames.login,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RegisterLogo(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: RegisterLandlordForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

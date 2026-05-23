import 'package:core/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/blocs/new_requests/new_requests_cubit.dart';
import 'core/di/di.dart';
import 'features/auth/presentation/blocs/authentication/authentication_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  await initializeDateFormatting('vi', null);
  configureDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<AuthenticationBloc>()),
        BlocProvider.value(value: getIt<NewRequestsCubit>()),
      ],
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) => {},
        child: MaterialApp.router(
          title: 'Rental Management System',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(scaffoldBackgroundColor: AppColors.white),
          routerConfig: getIt<GoRouter>(),
        ),
      ),
    );
  }
}

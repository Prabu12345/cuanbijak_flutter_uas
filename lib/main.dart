import 'package:cuanbijak_flutter_uas/core/theme/theme.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/presentation/pages/login_page.dart';
import 'package:cuanbijak_flutter_uas/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocator<AuthBloc>(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CuanBijak',
      theme: AppTheme.lightThemeMode,
      home: const LoginPage(),
    );
  }
}

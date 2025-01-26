import 'package:cuanbijak_flutter_uas/core/secrets/app_secrets.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/repository/auth_repository.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/usecases/user_login.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/usecases/user_register.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserRegister(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLogin(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userRegister: serviceLocator(),
      userLogin: serviceLocator(),
    ),
  );
}

import 'package:cuanbijak_flutter_uas/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:cuanbijak_flutter_uas/core/secrets/app_secrets.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/repository/auth_repository.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/usecases/change_password_user.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/usecases/current_user.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/usecases/logout_user.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/usecases/update_user.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/usecases/user_login.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/usecases/user_register.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/data/datasources/remote/transaction_remote_datasource.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/repositories/transaction_repository.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/usecases/delete_transaction.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/usecases/get_all_filtered_transaction.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/usecases/get_all_transaction.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/usecases/update_transaction.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/domain/usecases/upload_transaction_usecase.dart';
import 'package:cuanbijak_flutter_uas/feature/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBloc();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);

  // Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  // Datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UserRegister(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => ChangePasswordUser(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => LogoutUser(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateUser(
        serviceLocator(),
      ),
    )
    // bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userRegister: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
        changePasswordUser: serviceLocator(),
        logoutUser: serviceLocator(),
        updateUser: serviceLocator(),
      ),
    );
}

void _initBloc() {
  // Datasource
  serviceLocator
    ..registerFactory<TransactionRemoteDatasource>(
      () => TransactionRemoteDatasourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<TransactionRepository>(
      () => TransactionRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Usecase
    ..registerFactory(
      () => UploadTransactionUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllTransaction(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllFilteredTransaction(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateTransactionUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteTransaction(
        serviceLocator(),
      ),
    )
    // bloc
    ..registerLazySingleton(
      () => TransactionBloc(
        uploadTransactionUsecase: serviceLocator(),
        getAllTransaction: serviceLocator(),
        getAllFilteredTransaction: serviceLocator(),
        updateTransactionUsecase: serviceLocator(),
        deleteTransactionUsecase: serviceLocator(),
      ),
    );
}

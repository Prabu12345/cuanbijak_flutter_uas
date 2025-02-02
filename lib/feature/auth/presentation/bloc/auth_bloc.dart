import 'dart:io';

import 'package:cuanbijak_flutter_uas/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:cuanbijak_flutter_uas/core/usecase/usecase.dart';
import 'package:cuanbijak_flutter_uas/core/common/entities/user_entity.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/usecases/change_password_user.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/usecases/current_user.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/usecases/logout_user.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/usecases/update_user.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/usecases/user_login.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/usecases/user_register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRegister _userRegister;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  final ChangePasswordUser _changePasswordUser;
  final LogoutUser _logoutUser;
  final UpdateUser _updateUser;
  AuthBloc({
    required UserRegister userRegister,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
    required ChangePasswordUser changePasswordUser,
    required LogoutUser logoutUser,
    required UpdateUser updateUser,
  })  : _userRegister = userRegister,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        _changePasswordUser = changePasswordUser,
        _logoutUser = logoutUser,
        _updateUser = updateUser,
        super(AuthInitial()) {
    on<AuthEvent>(
      (_, emit) => emit(
        AuthLoading(),
      ),
    );
    on<AuthRegister>(_onAuthRegister);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<ChangePasswordUsers>(_onChangePasswordUser);
    on<LogoutUsers>(_onLogoutUser);
    on<UpdateUserData>(_onUpdateUser);
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _currentUser(NoParams());

    response.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitOnSuccess(r, emit),
    );
  }

  void _onAuthRegister(
    AuthRegister event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _userRegister(
      UserRegisterParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    response.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitOnSuccess(r, emit),
    );
  }

  void _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    response.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitOnSuccess(r, emit),
    );
  }

  void _onChangePasswordUser(
    ChangePasswordUsers event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _changePasswordUser(
      ChangePasswordUserParams(
        password: event.password,
      ),
    );

    response.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(ChangeUserSuccess(r)),
    );
  }

  void _onLogoutUser(
    LogoutUsers event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _logoutUser(NoParams());

    response.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(LogoutUserSuccess(r)),
    );
  }

  void _onUpdateUser(
    UpdateUserData event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _updateUser(
      UpdateUserParams(
          name: event.name,
          id: event.id,
          phoneNumber: event.phoneNumber,
          image: event.image),
    );

    response.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) {
        _appUserCubit.updateUser(r);
        emit(UpdateSuccess(r));
      },
    );
  }

  void _emitOnSuccess(
    UserEntity user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}

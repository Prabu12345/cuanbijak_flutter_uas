import 'package:cuanbijak_flutter_uas/feature/auth/domain/entities/user_entity.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/usecases/user_login.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/domain/usecases/user_register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRegister _userRegister;
  final UserLogin _userLogin;
  AuthBloc({
    required UserRegister userRegister,
    required UserLogin userLogin,
  })  : _userRegister = userRegister,
        _userLogin = userLogin,
        super(AuthInitial()) {
    on<AuthRegister>(_onAuthRegister);
    on<AuthLogin>(_onAuthLogin);
  }

  void _onAuthRegister(AuthRegister event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _userRegister(
      UserRegisterParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    response.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(AuthSuccess(r)),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    response.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(AuthSuccess(r)),
    );
  }
}

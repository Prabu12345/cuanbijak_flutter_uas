part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final UserEntity user;
  const AuthSuccess(this.user);
}

final class UpdateSuccess extends AuthState {
  final UserEntity user;
  const UpdateSuccess(this.user);
}

final class LogoutUserSuccess extends AuthState {
  final bool status;
  const LogoutUserSuccess(this.status);
}

final class ChangeUserSuccess extends AuthState {
  final bool status;
  const ChangeUserSuccess(this.status);
}

final class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}

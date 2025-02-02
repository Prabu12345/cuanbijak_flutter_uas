part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthRegister extends AuthEvent {
  final String email;
  final String password;
  final String name;

  AuthRegister({
    required this.email,
    required this.password,
    required this.name,
  });
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({
    required this.email,
    required this.password,
  });
}

final class AuthIsUserLoggedIn extends AuthEvent {}

final class ChangePasswordUsers extends AuthEvent {
  final String password;

  ChangePasswordUsers({
    required this.password,
  });
}

final class LogoutUsers extends AuthEvent {}

final class UpdateUserData extends AuthEvent {
  final String id;
  final String name;
  final String phoneNumber;
  final File? image;

  UpdateUserData({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.image,
  });
}

import 'package:cuanbijak_flutter_uas/core/error/exceptions.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> registerWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loignWIthEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserModel> loignWIthEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final respone = await supabaseClient.auth
          .signInWithPassword(password: password, email: email);

      if (respone.user == null) {
        throw const ServerExpection('User is unavailable!');
      }

      return UserModel.fromJson(
        respone.user!.toJson(),
      );
    } catch (e) {
      throw ServerExpection(e.toString());
    }
  }

  @override
  Future<UserModel> registerWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final respone = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
        },
      );

      if (respone.user == null) {
        throw const ServerExpection('User is null');
      }

      return UserModel.fromJson(
        respone.user!.toJson(),
      );
    } catch (e) {
      throw ServerExpection(e.toString());
    }
  }
}

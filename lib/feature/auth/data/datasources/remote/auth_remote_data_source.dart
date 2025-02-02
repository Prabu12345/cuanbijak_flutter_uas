import 'dart:io';

import 'package:cuanbijak_flutter_uas/core/error/exceptions.dart';
import 'package:cuanbijak_flutter_uas/feature/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> registerWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loignWIthEmailPassword({
    required String email,
    required String password,
  });
  Future<UserModel?> getCurrentUserData();
  Future<UserModel> updateUserData({required UserModel user});
  Future<bool> logoutUser();
  Future<String> uploadAvatar({
    required UserModel user,
    required File image,
  });
  Future<bool> changePassword({required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

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

      final getUser = await getCurrentUserData();

      return UserModel.fromJson(
        respone.user!.toJson(),
      ).copyWith(
        name: getUser?.name,
        avatarUrl: getUser?.avatarUrl,
        phoneNumber: getUser?.phoneNumber,
        email: currentUserSession!.user.email,
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
          'phone_number': '',
          'avatar_url': '',
          'updated_at': '',
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

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient.from('profiles').select().eq(
              'id',
              currentUserSession!.user.id,
            );
        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
        );
      }
      return null;
    } catch (e) {
      throw ServerExpection(e.toString());
    }
  }

  @override
  Future<bool> logoutUser() async {
    try {
      await supabaseClient.auth.signOut(scope: SignOutScope.global);
      return true;
    } catch (e) {
      throw ServerExpection(e.toString());
    }
  }

  @override
  Future<UserModel> updateUserData({required UserModel user}) async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .update(user.toJson())
          .eq('id', user.id)
          .select()
          .single();

      return UserModel.fromJson(response).copyWith(
        email: currentUserSession!.user.email,
      );
    } catch (e) {
      throw ServerExpection(e.toString());
    }
  }

  @override
  Future<String> uploadAvatar(
      {required UserModel user, required File image}) async {
    try {
      await supabaseClient.storage.from('avatars').upload(
            user.id,
            image,
            fileOptions: const FileOptions(upsert: true),
          );

      return supabaseClient.storage.from('avatars').getPublicUrl(user.id);
    } catch (e) {
      throw ServerExpection(e.toString());
    }
  }

  @override
  Future<bool> changePassword({required String password}) async {
    try {
      await supabaseClient.auth.updateUser(UserAttributes(password: password));
      return true;
    } catch (e) {
      throw ServerExpection(e.toString());
    }
  }
}

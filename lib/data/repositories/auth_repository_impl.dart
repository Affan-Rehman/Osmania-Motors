// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:motors_app/core/dio_singleton.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/data/datasources/auth_datasource.dart';
import 'package:motors_app/data/models/auth/auth.dart';
import 'package:motors_app/data/models/user/user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class AuthRepository {
  Future<Auth> signIn(login, password);
  Future<User> signInWithGoogle();

  Future<User> signInWithApple();
  Future<Auth> signUp(
    login,
    name,
    surname,
    phone,
    email,
    password,
    File? avatar,
  );

  Future<UserInfo> getUserInfo(id);

  Future updateProfile(
    login,
    name,
    surname,
    phone,
    email,
    password,
    File? avatar,
    userId,
    userToken,
  );

  Future logout();
}

class AuthRepositoryImpl extends AuthRepository {
  AuthDataSource authDataSource = AuthRemoteDataSource();

  @override
  Future<Auth> signIn(login, password) async {
    Auth authResponse = await authDataSource.signIn(login, password);
    if (authResponse.code == 200) {
      print('login success ${authResponse.user.token}');
      await preferences.setString('password', password);
      await preferences.setString('token', authResponse.user.token);
      await preferences.setString('userId', authResponse.user.ID);
      await preferences.setString(
        'userName',
        authResponse.user.firstName ?? authResponse.user.displayName,
      );
      print('login success ${preferences.getString('token')}');
    } else {
      await preferences.remove('token');
    }
    return authResponse;
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final User user = User(
          ID: googleUser.id,
          userEmail: googleUser.email,
          displayName: googleUser.displayName,
          token: googleUser.id,
        );
        try {
          await DioSingleton().instance().post(
            'https://osmaniamotors.com/wp-content/plugins/osmania_api/index.php',
            data: {
              'google_login': googleUser.email,
              'name': googleUser.displayName,
              'token': googleUser.id,
              'serverAuthCode': googleUser.serverAuthCode,
            },
          );
        } catch (e) {
          log(e.toString());
        }
        await _updatePreferences(user);
        return user;
      } else {
        return User(userEmail: '');
      }
    } catch (error) {
      throw Exception('Error occurred during Google sign-in: $error');
    }
  }

  @override
  Future<User> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      if (credential != null) {
        final User user = User(
          ID: credential.identityToken,
          userEmail: credential.email,
          displayName: credential.givenName,
          token: credential.identityToken,
        );
        try {
          await DioSingleton().instance().post(
            'https://osmaniamotors.com/wp-content/plugins/osmania_api/index.php',
            data: {
              'google_login': credential.email,
              'name': credential.givenName,
              'token': credential.identityToken,
            },
          );
        } catch (e) {
          log(e.toString());
        }
        await _updatePreferences(user);
        return user;
      } else {
        return User(userEmail: '');
      }
    } catch (error) {
      throw Exception('Error occurred during Apple sign-in: $error');
    }
  }

  Future<void> _updatePreferences(User user) async {
    try {
      await preferences.setString('token', user.token ?? '');
      await preferences.setString('userId', user.ID ?? '');
      await preferences.setString(
        'userName',
        user.firstName ?? user.displayName ?? '',
      );
    } catch (error) {
      throw Exception('Error updating preferences: $error');
    }
  }

  @override
  Future<Auth> signUp(
    login,
    name,
    surname,
    phone,
    email,
    password,
    File? avatar,
  ) async {
    Auth authResponse = await authDataSource.signUp(
      login,
      name,
      surname,
      phone,
      email,
      password,
      avatar,
    );

    if (authResponse.code == 200) {
      await preferences.setString('password', password);
      await preferences.setString('token', authResponse.user.token);
      await preferences.setString('userId', authResponse.user.ID);
      await preferences.setString(
        'userName',
        authResponse.user.firstName ?? authResponse.user.displayName,
      );
    } else {
      await preferences.remove('token');
      await preferences.remove('userId');
      await preferences.remove('password');
    }

    return authResponse;
  }

  @override
  Future logout() async {
    await preferences.remove('token');
    await preferences.remove('userId');
    await preferences.remove('password');
    await preferences.remove('userName');
  }

  @override
  Future<UserInfo> getUserInfo(id) async {
    UserInfo userResponse = await authDataSource.getUserInfo(id);

    return userResponse;
  }

  @override
  Future updateProfile(
    login,
    name,
    surname,
    phone,
    email,
    password,
    File? avatar,
    userId,
    userToken,
  ) async {
    var response = await authDataSource.updateProfile(
      login,
      name,
      surname,
      phone,
      email,
      password,
      avatar,
      userId,
      userToken,
    );
    return response;
  }
}

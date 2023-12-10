import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:motors_app/core/dio_singleton.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/auth/auth.dart';
import 'package:motors_app/data/models/user/user.dart';

abstract class AuthDataSource {
  Future<Auth> signIn(login, password);

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
}

class AuthRemoteDataSource implements AuthDataSource {
  @override
  Future<Auth> signIn(login, password) async {
    DioSingleton().instance().options.headers['content-Type'] =
        'application/x-www-form-urlencoded';

    try {
      final response = await DioSingleton().instance().post(
        '$apiEndPoint/login',
        data: {
          'stm_login': login.toString(),
          'stm_pass': password.toString(),
        },
      );
      log(response.data.toString() + 'response');
      if (response.data.toString() !=
          '{code: 401, message: Wrong Username or Password}')
        return Auth.fromJson(response.data as Map<String, dynamic>);
      else
        return Auth(401, 'Wrong Username or Password', User(), [], false);
    } on DioError catch (e) {
      log(e.message.toString() + 'error' + e.response.toString());
      throw Exception(e.message);
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
    DioSingleton().instance().options.headers['content-Type'] =
        'application/x-www-form-urlencoded';

    Uint8List? bytesImg;

    if (avatar != null) {
      bytesImg = avatar.readAsBytesSync();
    } else {
      bytesImg = null;
    }

    var record = {
      'stm_nickname': login,
      'stm_user_first_name': name ?? '',
      'stm_user_last_name': surname ?? '',
      'stm_user_phone': phone,
      'stm_user_mail': email,
      'stm_user_password': password,
      'avatar': bytesImg == null ? '' : base64.encode(bytesImg),
    };

    try {
      final response = await DioSingleton()
          .instance()
          .post('$apiEndPoint/registration', data: record);

      if (response.data['user'] != null) {
        preferences.setString('userId', response.data['user']['ID']);
      }

      return Auth.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<UserInfo> getUserInfo(id) async {
    try {
      final response =
          await DioSingleton().instance().get('$apiEndPoint/private-user/$id');

      return UserInfo.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception(e.response);
    }
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
    Uint8List? bytesImg;

    if (avatar != null) {
      bytesImg = avatar.readAsBytesSync();
    } else {
      bytesImg = null;
    }

    var record = {
      'stm_nickname': login,
      'stm_user_first_name': name ?? '',
      'stm_user_last_name': surname ?? '',
      'stm_user_phone': phone,
      'stm_user_mail': email,
      'stm_user_password': password,
      'userId': userId,
      'userToken': userToken,
      'avatar': bytesImg == null ? '' : base64.encode(bytesImg),
    };

    try {
      final response = await DioSingleton().instance().post(
            '$apiEndPoint/update-profile',
            data: record,
          );

      return response;
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }
}

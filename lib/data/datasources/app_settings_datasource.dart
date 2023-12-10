import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:motors_app/core/dio_singleton.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/models.dart';

abstract class AppSettingsDataSource {
  Future<AppSettings> getAppSettings();
}

class AppSettingsRemoteDataSource implements AppSettingsDataSource {
  @override
  Future<AppSettings> getAppSettings() async {
    try {
      final response =
          await DioSingleton().instance().get('$apiEndPoint/settings');

      log('${response.data}');
      return AppSettings.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }
}

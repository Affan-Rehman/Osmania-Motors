import 'package:dio/dio.dart';
import 'package:motors_app/data/datasources/app_settings_datasource.dart';
import 'package:motors_app/data/models/app_settings/app_settings.dart';

abstract class AppSettingsRepository {
  Future<AppSettings> getAppSettings();
}

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  @override
  Future<AppSettings> getAppSettings() async {
    late AppSettingsDataSource appSettingsDataSource;

    appSettingsDataSource = AppSettingsRemoteDataSource();

    try {
      AppSettings appSettingsEntity = await appSettingsDataSource.getAppSettings();

      return appSettingsEntity;
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }
}

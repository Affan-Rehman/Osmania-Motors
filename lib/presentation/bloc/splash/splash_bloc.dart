import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/app_settings/app_settings.dart';
import 'package:motors_app/data/repositories/app_settings_repository_impl.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(InitialSplashState(logo: logo)) {
    bool isSigned = false;

    on<CheckAuthSplashEvent>((event, emit) async {
      print('getting app data');
      AppSettings appSettings = await appSettingsRepository.getAppSettings();
      print('got app data');

      ///Set Environments
      appType = appSettings.appType;
      inventoryType = appSettings.inventoryView;
      mainColor = HexColor.fromHex(appSettings.mainColor);
      secondaryColor = HexColor.fromHex(appSettings.secondaryColor);
      currency = appSettings.currency;
      currencyName = appSettings.currencyName;
      translations = jsonDecode(appSettings.translations);
      googleApiToken = appSettings.apiKeyAndroid;

      final token = preferences.getString('token') ?? '';
      // userId = preferences.getString('userId') ?? '';
      if (token != '') {
        isSigned = true;
      }
      emit(CloseSplashState(appSettings, isSigned));
    });
  }

  final AppSettingsRepository appSettingsRepository =
      AppSettingsRepositoryImpl();
}

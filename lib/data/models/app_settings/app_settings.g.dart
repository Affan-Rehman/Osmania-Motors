// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
      acv: json['acv'] as String,
      appType: json['app_type'] as String,
      mainColor: json['main_color'] as String,
      secondaryColor: json['secondary_color'] as String,
      numOfListings: json['num_of_listings'] as int,
      gridViewStyle: json['grid_view_style'] as String,
      inventoryView: json['inventory_view'] as String,
      apiKeyAndroid: json['api_key_android'] as String,
      apiKeyIos: json['api_key_ios'] as String,
      currency: json['currency'] as String,
      currencyName: json['currency_name'] as String,
      translations: json['translations'],
      logo: json['logo'] as String?,
      splashScreenLogo: json['splash_screen_logo'] as String?,
      backgroundSplashScreenImage:
          json['background_splash_screen_image'] as String?,
      placeholder: json['placeholder'] as String?,
    );

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'acv': instance.acv,
      'app_type': instance.appType,
      'main_color': instance.mainColor,
      'secondary_color': instance.secondaryColor,
      'num_of_listings': instance.numOfListings,
      'grid_view_style': instance.gridViewStyle,
      'inventory_view': instance.inventoryView,
      'api_key_android': instance.apiKeyAndroid,
      'api_key_ios': instance.apiKeyIos,
      'currency': instance.currency,
      'currency_name': instance.currencyName,
      'translations': instance.translations,
      'logo': instance.logo,
      'splash_screen_logo': instance.splashScreenLogo,
      'background_splash_screen_image': instance.backgroundSplashScreenImage,
      'placeholder': instance.placeholder,
    };

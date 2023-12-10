import 'package:json_annotation/json_annotation.dart';

part 'app_settings.g.dart';

@JsonSerializable()
class AppSettings {
  AppSettings({
    required this.acv,
    required this.appType,
    required this.mainColor,
    required this.secondaryColor,
    required this.numOfListings,
    required this.gridViewStyle,
    required this.inventoryView,
    required this.apiKeyAndroid,
    required this.apiKeyIos,
    required this.currency,
    required this.currencyName,
    required this.translations,
    this.logo,
    this.splashScreenLogo,
    this.backgroundSplashScreenImage,
    this.placeholder,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

  String acv;
  @JsonKey(name: 'app_type')
  String appType;
  @JsonKey(name: 'main_color')
  String mainColor;
  @JsonKey(name: 'secondary_color')
  String secondaryColor;
  @JsonKey(name: 'num_of_listings')
  int numOfListings;
  @JsonKey(name: 'grid_view_style')
  String gridViewStyle;
  @JsonKey(name: 'inventory_view')
  String inventoryView;
  @JsonKey(name: 'api_key_android')
  String apiKeyAndroid;
  @JsonKey(name: 'api_key_ios')
  String apiKeyIos;
  String currency;
  @JsonKey(name: 'currency_name')
  String currencyName;
  dynamic translations;
  String? logo;
  @JsonKey(name: 'splash_screen_logo')
  String? splashScreenLogo;
  @JsonKey(name: 'background_splash_screen_image')
  String? backgroundSplashScreenImage;
  String? placeholder;

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}

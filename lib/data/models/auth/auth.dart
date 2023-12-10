import 'package:json_annotation/json_annotation.dart';

part 'auth.g.dart';

@JsonSerializable()
class Auth {
  Auth(
    this.code,
    this.message,
    this.user,
    this.errors,
    this.restricted,
  );

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);

  int? code;
  String message;
  User user;
  dynamic errors;
  dynamic restricted;

  Map<String, dynamic> toJson() => _$AuthToJson(this);
}

@JsonSerializable()
class User {
  User({
    this.ID,
    this.userLogin,
    this.userNickname,
    this.userEmail,
    this.userUrl,
    this.userRegistered,
    this.userActivationKey,
    this.userStatus,
    this.displayName,
    this.spam,
    this.deleted,
    this.role,
    this.token,
    this.phone,
    this.firstName,
    this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  dynamic ID;
  @JsonKey(name: 'user_login')
  dynamic userLogin;
  @JsonKey(name: 'user_nicename')
  dynamic userNickname;
  @JsonKey(name: 'user_email')
  dynamic userEmail;
  @JsonKey(name: 'user_url')
  dynamic userUrl;
  @JsonKey(name: 'user_registered')
  dynamic userRegistered;
  @JsonKey(name: 'user_activation_key')
  dynamic userActivationKey;
  @JsonKey(name: 'user_status')
  dynamic userStatus;
  @JsonKey(name: 'display_name')
  dynamic displayName;
  dynamic spam;
  dynamic deleted;
  dynamic role;
  dynamic token;
  dynamic phone;
  @JsonKey(name: 'f_name')
  dynamic firstName;
  @JsonKey(name: 'l_name')
  dynamic lastName;

  Map<String, dynamic> toJson() => _$UserToJson(this);

}

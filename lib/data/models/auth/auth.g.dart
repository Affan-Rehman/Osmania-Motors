// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auth _$AuthFromJson(Map<String, dynamic> json) => Auth(
      json['code'] as int?,
      json['message'] as String,
      User.fromJson(json['user'] as Map<String, dynamic>),
      json['errors'],
      json['restricted'],
    );

Map<String, dynamic> _$AuthToJson(Auth instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'user': instance.user,
      'errors': instance.errors,
      'restricted': instance.restricted,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      ID: json['ID'],
      userLogin: json['user_login'],
      userNickname: json['user_nicename'],
      userEmail: json['user_email'],
      userUrl: json['user_url'],
      userRegistered: json['user_registered'],
      userActivationKey: json['user_activation_key'],
      userStatus: json['user_status'],
      displayName: json['display_name'],
      spam: json['spam'],
      deleted: json['deleted'],
      role: json['role'],
      token: json['token'],
      phone: json['phone'],
      firstName: json['f_name'],
      lastName: json['l_name'],
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'ID': instance.ID,
      'user_login': instance.userLogin,
      'user_nicename': instance.userNickname,
      'user_email': instance.userEmail,
      'user_url': instance.userUrl,
      'user_registered': instance.userRegistered,
      'user_activation_key': instance.userActivationKey,
      'user_status': instance.userStatus,
      'display_name': instance.displayName,
      'spam': instance.spam,
      'deleted': instance.deleted,
      'role': instance.role,
      'token': instance.token,
      'phone': instance.phone,
      'f_name': instance.firstName,
      'l_name': instance.lastName,
    };

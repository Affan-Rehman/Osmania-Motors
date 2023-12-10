// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_messages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMessage _$UserMessageFromJson(Map<String, dynamic> json) => UserMessage(
      id: json['id'],
      userId: json['userId'],
      message: json['message'],
      userName: json['userName'],
      timestamp: json['timestamp'],
    );

Map<String, dynamic> _$UserMessageToJson(UserMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'message': instance.message,
      'userName': instance.userName,
      'timestamp': instance.timestamp,
    };

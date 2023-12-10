// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_car.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddCarResponse _$AddCarResponseFromJson(Map<String, dynamic> json) =>
    AddCarResponse(
      stepOne: json['step_one'],
      stepTwo: json['step_two'],
      stepThree: json['step_three'],
    );

Map<String, dynamic> _$AddCarResponseToJson(AddCarResponse instance) =>
    <String, dynamic>{
      'step_one': instance.stepOne,
      'step_two': instance.stepTwo,
      'step_three': instance.stepThree,
    };

AddedCarResponse _$AddedCarResponseFromJson(Map<String, dynamic> json) =>
    AddedCarResponse(
      message: json['message'],
      required_fields: json['required_fields'],
      notSendRequiredFields: json['not_send_required_fields'],
      postId: json['post_id'],
      code: json['code'],
    );

Map<String, dynamic> _$AddedCarResponseToJson(AddedCarResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'required_fields': instance.required_fields,
      'not_send_required_fields': instance.notSendRequiredFields,
      'post_id': instance.postId,
      'code': instance.code,
    };

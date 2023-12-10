import 'package:json_annotation/json_annotation.dart';

part 'add_car.g.dart';

@JsonSerializable()
class AddCarResponse {
  AddCarResponse({this.stepOne, this.stepTwo, this.stepThree});

  factory AddCarResponse.fromJson(Map<String, dynamic> json) => _$AddCarResponseFromJson(json);

  @JsonKey(name: 'step_one')
  final dynamic stepOne;
  @JsonKey(name: 'step_two')
  final dynamic stepTwo;
  @JsonKey(name: 'step_three')
  final dynamic stepThree;

  Map<String, dynamic> toJson() => _$AddCarResponseToJson(this);
}

@JsonSerializable()
class AddedCarResponse {
  AddedCarResponse({
    this.message,
    this.required_fields,
    this.notSendRequiredFields,
    this.postId,
    this.code,
  });

  factory AddedCarResponse.fromJson(Map<String, dynamic> json) => _$AddedCarResponseFromJson(json);

  final dynamic message;
  @JsonKey(name: 'required_fields')
  final dynamic required_fields;
  @JsonKey(name: 'not_send_required_fields')
  final dynamic notSendRequiredFields;
  @JsonKey(name: 'post_id')
  final dynamic postId;
  final dynamic code;

  Map<String, dynamic> toJson() => _$AddedCarResponseToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'user_messages.g.dart';

@JsonSerializable()
class UserMessage {
  UserMessage({
    this.id,
    this.userId,
    this.message,
    this.userName,
    this.timestamp,
  });
  factory UserMessage.fromJson(Map<String, dynamic> json) =>
      _$UserMessageFromJson(json);

  dynamic id;
  dynamic userId;
  dynamic message;
  dynamic userName;
  dynamic timestamp = DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() => _$UserMessageToJson(this);
}

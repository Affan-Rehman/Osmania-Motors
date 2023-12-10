import 'package:json_annotation/json_annotation.dart';

part 'buy_request.g.dart';

@JsonSerializable()
class BuyRequest {
  BuyRequest({
    this.ID,
    this.title,
    this.price,
    this.description,
    this.location,
    this.vehicleType,
    this.date,
    this.buyRequestID,
  });

  factory BuyRequest.fromJson(Map<String, dynamic> json) =>
      _$BuyRequestFromJson(json);

  dynamic ID;
  dynamic buyRequestID;
  dynamic title;
  dynamic price;
  dynamic description;
  dynamic location;
  dynamic vehicleType;
  dynamic date;

  Map<String, dynamic> toJson() => _$BuyRequestToJson(this);
}

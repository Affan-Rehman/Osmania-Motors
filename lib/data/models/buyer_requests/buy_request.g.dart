// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buy_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuyRequest _$BuyRequestFromJson(Map<String, dynamic> json) => BuyRequest(
      ID: json['ID'],
      title: json['title'],
      price: json['price'],
      description: json['description'],
      location: json['location'],
      vehicleType: json['vehicleType'],
      date: json['date'],
      buyRequestID: json['buyRequestID'],
    );

Map<String, dynamic> _$BuyRequestToJson(BuyRequest instance) =>
    <String, dynamic>{
      'ID': instance.ID,
      'buyRequestID': instance.buyRequestID,
      'title': instance.title,
      'price': instance.price,
      'description': instance.description,
      'location': instance.location,
      'vehicleType': instance.vehicleType,
      'date': instance.date,
    };

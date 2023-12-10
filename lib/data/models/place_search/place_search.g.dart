// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceSearchResponse _$PlaceSearchResponseFromJson(Map<String, dynamic> json) =>
    PlaceSearchResponse(
      predictions: json['predictions'],
      status: json['status'] as String,
    );

Map<String, dynamic> _$PlaceSearchResponseToJson(
        PlaceSearchResponse instance) =>
    <String, dynamic>{
      'predictions': instance.predictions,
      'status': instance.status,
    };

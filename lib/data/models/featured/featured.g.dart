// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeaturedResponse _$FeaturedResponseFromJson(Map<String, dynamic> json) =>
    FeaturedResponse(
      (json['featured'] as List<dynamic>)
          .map((e) =>
              e == null ? null : Featured.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FeaturedResponseToJson(FeaturedResponse instance) =>
    <String, dynamic>{
      'featured': instance.featured,
    };

Featured _$FeaturedFromJson(Map<String, dynamic> json) => Featured(
      json['ID'],
      json['title'],
      json['price'],
      json['img'],
    );

Map<String, dynamic> _$FeaturedToJson(Featured instance) => <String, dynamic>{
      'ID': instance.ID,
      'title': instance.title,
      'price': instance.price,
      'img': instance.img,
    };

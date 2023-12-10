// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainPage _$MainPageFromJson(Map<String, dynamic> json) => MainPage(
      featured: (json['featured'] as List<dynamic>)
          .map((e) => Similar.fromJson(e as Map<String, dynamic>))
          .toList(),
      recent: (json['recent'] as List<dynamic>)
          .map((e) =>
              e == null ? null : Recent.fromJson(e as Map<String, dynamic>))
          .toList(),
      viewType: json['viewType'],
      offset: json['offset'],
      limit: json['limit'],
      featuredMaxNumPages: json['featured_max_num_pages'],
      lastMaxNumPages: json['last_max_num_pages'],
    );

Map<String, dynamic> _$MainPageToJson(MainPage instance) => <String, dynamic>{
      'featured': instance.featured,
      'recent': instance.recent,
      'viewType': instance.viewType,
      'offset': instance.offset,
      'limit': instance.limit,
      'featured_max_num_pages': instance.featuredMaxNumPages,
      'last_max_num_pages': instance.lastMaxNumPages,
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

Recent _$RecentFromJson(Map<String, dynamic> json) => Recent(
      json['ID'],
      json['imgUrl'],
      (json['gallery'] as List<dynamic>)
          .map((e) =>
              e == null ? null : Gallery.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['imgCount'],
      json['price'],
      json['grid'],
      json['list'],
    );

Map<String, dynamic> _$RecentToJson(Recent instance) => <String, dynamic>{
      'ID': instance.ID,
      'imgUrl': instance.imgUrl,
      'gallery': instance.gallery,
      'imgCount': instance.imgCount,
      'price': instance.price,
      'grid': instance.grid,
      'list': instance.list,
    };

Gallery _$GalleryFromJson(Map<String, dynamic> json) => Gallery(
      json['url'],
    );

Map<String, dynamic> _$GalleryToJson(Gallery instance) => <String, dynamic>{
      'url': instance.url,
    };

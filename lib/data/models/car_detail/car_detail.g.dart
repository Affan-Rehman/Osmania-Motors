// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarDetail _$CarDetailFromJson(Map<String, dynamic> json) => CarDetail(
      ID: json['ID'],
      imgUrl: json['imgUrl'],
      gallery: (json['gallery'] as List<dynamic>)
          .map((e) =>
              e == null ? null : Gallery.fromJson(e as Map<String, dynamic>))
          .toList(),
      imgCount: json['imgCount'],
      price: json['price'],
      title: json['title'],
      subTitle: json['subTitle'],
      content: json['content'],
      carLocation: json['car_location'],
      carLat: json['car_lat'],
      carLng: json['car_lng'],
      info: (json['info'] as List<dynamic>)
          .map((e) =>
              e == null ? null : Info.fromJson(e as Map<String, dynamic>))
          .toList(),
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      author: json['author'] == null
          ? null
          : Author.fromJson(json['author'] as Map<String, dynamic>),
      listingSellerNote: json['listing_seller_note'],
      inFavorites: json['inFavorites'],
      similar: (json['similar'] as List<dynamic>)
          .map((e) => Similar.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CarDetailToJson(CarDetail instance) => <String, dynamic>{
      'ID': instance.ID,
      'imgUrl': instance.imgUrl,
      'gallery': instance.gallery,
      'imgCount': instance.imgCount,
      'price': instance.price,
      'title': instance.title,
      'subTitle': instance.subTitle,
      'content': instance.content,
      'car_location': instance.carLocation,
      'car_lat': instance.carLat,
      'car_lng': instance.carLng,
      'info': instance.info,
      'features': instance.features,
      'author': instance.author,
      'listing_seller_note': instance.listingSellerNote,
      'inFavorites': instance.inFavorites,
      'similar': instance.similar,
    };

Gallery _$GalleryFromJson(Map<String, dynamic> json) => Gallery(
      json['url'],
    );

Map<String, dynamic> _$GalleryToJson(Gallery instance) => <String, dynamic>{
      'url': instance.url,
    };

Info _$InfoFromJson(Map<String, dynamic> json) => Info(
      json['info_1'],
      json['info_2'],
      json['info_3'],
    );

Map<String, dynamic> _$InfoToJson(Info instance) => <String, dynamic>{
      'info_1': instance.infoOne,
      'info_2': instance.infoTwo,
      'info_3': instance.infoThree,
    };

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
      json['user_id'],
      json['phone'],
      json['stm_whatsapp_number'],
      json['image'],
      json['name'],
      json['last_name'],
      json['socials'],
      json['email'],
      json['show_mail'],
      json['logo'],
      json['dealer_image'],
      json['license'],
      json['website'],
      json['location'],
      json['location_lat'],
      json['location_lng'],
      json['stm_company_name'],
      json['stm_company_license'],
      json['stm_message_to_user'],
      json['stm_sales_hours'],
      json['stm_seller_notes'],
      json['stm_payment_status'],
      json['user_role'],
      json['reg_date'],
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'user_id': instance.userId,
      'phone': instance.phone,
      'stm_whatsapp_number': instance.stmWhatsappNumber,
      'image': instance.image,
      'name': instance.name,
      'last_name': instance.lastName,
      'socials': instance.socials,
      'email': instance.email,
      'show_mail': instance.showMail,
      'logo': instance.logo,
      'dealer_image': instance.dealerImage,
      'license': instance.license,
      'website': instance.website,
      'location': instance.location,
      'location_lat': instance.locationLat,
      'location_lng': instance.locationLng,
      'stm_company_name': instance.stmCompanyName,
      'stm_company_license': instance.stmCompanyLicense,
      'stm_message_to_user': instance.stmMessageToUser,
      'stm_sales_hours': instance.stmSalesHours,
      'stm_seller_notes': instance.stmSellerNotes,
      'stm_payment_status': instance.stmPaymentStatus,
      'user_role': instance.userRole,
      'reg_date': instance.regDate,
    };

Similar _$SimilarFromJson(Map<String, dynamic> json) => Similar(
      json['ID'],
      json['title'],
      json['price'],
      json['img'],
    );

Map<String, dynamic> _$SimilarToJson(Similar instance) => <String, dynamic>{
      'ID': instance.ID,
      'title': instance.title,
      'price': instance.price,
      'img': instance.img,
    };

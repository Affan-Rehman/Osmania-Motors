// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dealer_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DealerResponse _$DealerResponseFromJson(Map<String, dynamic> json) =>
    DealerResponse(
      author: json['author'] == null
          ? null
          : Author.fromJson(json['author'] as Map<String, dynamic>),
      listings: (json['listings'] as List<dynamic>)
          .map((e) =>
              e == null ? null : Listings.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DealerResponseToJson(DealerResponse instance) =>
    <String, dynamic>{
      'author': instance.author,
      'listings': instance.listings,
    };

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
      user_id: json['user_id'],
      phone: json['phone'],
      stmWhatsappNumber: json['stm_whatsapp_number'],
      image: json['image'],
      name: json['name'],
      lastName: json['last_name'],
      socials: json['socials'],
      email: json['email'],
      showMail: json['show_mail'],
      logo: json['logo'],
      dealerImage: json['dealer_image'],
      license: json['license'],
      website: json['website'],
      location: json['location'],
      locationLat: json['location_lat'],
      locationLng: json['location_lng'],
      stmCompanyName: json['stm_company_name'],
      stmCompanyLicense: json['stm_company_license'],
      stmMessageToUser: json['stm_message_to_user'],
      stmSalesHours: json['stm_sales_hours'],
      stmSellerNotes: json['stm_seller_notes'],
      stmPaymentStatus: json['stm_payment_status'],
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'user_id': instance.user_id,
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
    };

Listings _$ListingsFromJson(Map<String, dynamic> json) => Listings(
      key: json['key'],
      ID: json['ID'],
      imgUrl: json['imgUrl'],
      gallery: (json['gallery'] as List<dynamic>)
          .map((e) => e == null
              ? null
              : GalleryAuto.fromJson(e as Map<String, dynamic>))
          .toList(),
      imgCount: json['imgCount'],
      price: json['price'],
      grid: json['grid'] == null
          ? null
          : Grid.fromJson(json['grid'] as Map<String, dynamic>),
      list: ListFav.fromJson(json['list'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ListingsToJson(Listings instance) => <String, dynamic>{
      'key': instance.key,
      'ID': instance.ID,
      'imgUrl': instance.imgUrl,
      'gallery': instance.gallery,
      'imgCount': instance.imgCount,
      'price': instance.price,
      'grid': instance.grid,
      'list': instance.list,
    };

GalleryAuto _$GalleryAutoFromJson(Map<String, dynamic> json) => GalleryAuto(
      url: json['url'],
    );

Map<String, dynamic> _$GalleryAutoToJson(GalleryAuto instance) =>
    <String, dynamic>{
      'url': instance.url,
    };

Grid _$GridFromJson(Map<String, dynamic> json) => Grid(
      title: json['title'],
      subTitle: json['subTitle'],
      infoIcon: json['infoIcon'],
      infoTitle: json['infoTitle'],
      infoDesc: json['infoDesc'],
    );

Map<String, dynamic> _$GridToJson(Grid instance) => <String, dynamic>{
      'title': instance.title,
      'subTitle': instance.subTitle,
      'infoIcon': instance.infoIcon,
      'infoTitle': instance.infoTitle,
      'infoDesc': instance.infoDesc,
    };

ListFav _$ListFavFromJson(Map<String, dynamic> json) => ListFav(
      title: json['title'],
      infoOneIcon: json['infoOneIcon'],
      infoOneTitle: json['infoOneTitle'],
      infoOneDesc: json['infoOneDesc'],
      infoTwoIcon: json['infoTwoIcon'],
      infoTwoTitle: json['infoTwoTitle'],
      infoTwoDesc: json['infoTwoDesc'],
      infoThreeIcon: json['infoThreeIcon'],
      infoThreeTitle: json['infoThreeTitle'],
      infoThreeDesc: json['infoThreeDesc'],
      infoFourIcon: json['infoFourIcon'],
      infoFourTitle: json['infoFourTitle'],
      infoFourDesc: json['infoFourDesc'],
    );

Map<String, dynamic> _$ListFavToJson(ListFav instance) => <String, dynamic>{
      'title': instance.title,
      'infoOneIcon': instance.infoOneIcon,
      'infoOneTitle': instance.infoOneTitle,
      'infoOneDesc': instance.infoOneDesc,
      'infoTwoIcon': instance.infoTwoIcon,
      'infoTwoTitle': instance.infoTwoTitle,
      'infoTwoDesc': instance.infoTwoDesc,
      'infoThreeIcon': instance.infoThreeIcon,
      'infoThreeTitle': instance.infoThreeTitle,
      'infoThreeDesc': instance.infoThreeDesc,
      'infoFourIcon': instance.infoFourIcon,
      'infoFourTitle': instance.infoFourTitle,
      'infoFourDesc': instance.infoFourDesc,
    };

Socials _$SocialsFromJson(Map<String, dynamic> json) => Socials(
      facebook: json['facebook'],
      twitter: json['twitter'],
      linkedin: json['linkedin'],
      youtube: json['youtube'],
    );

Map<String, dynamic> _$SocialsToJson(Socials instance) => <String, dynamic>{
      'facebook': instance.facebook,
      'twitter': instance.twitter,
      'linkedin': instance.linkedin,
      'youtube': instance.youtube,
    };

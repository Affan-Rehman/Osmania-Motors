import 'package:json_annotation/json_annotation.dart';

part 'car_detail.g.dart';

@JsonSerializable()
class CarDetail {
  CarDetail({
    this.ID,
    this.imgUrl,
    required this.gallery,
    this.imgCount,
    this.price,
    this.title,
    this.subTitle,
    this.content,
    this.carLocation,
    this.carLat,
    this.carLng,
    required this.info,
    this.features,
    this.author,
    this.listingSellerNote,
    this.inFavorites,
    required this.similar,
  });

  factory CarDetail.fromJson(Map<String, dynamic> json) => _$CarDetailFromJson(json);

  dynamic ID;
  dynamic imgUrl;
  List<Gallery?> gallery;
  dynamic imgCount;
  dynamic price;
  dynamic title;
  dynamic subTitle;
  dynamic content;
  @JsonKey(name: 'car_location')
  dynamic carLocation;
  @JsonKey(name: 'car_lat')
  dynamic carLat;
  @JsonKey(name: 'car_lng')
  dynamic carLng;
  List<Info?> info;
  List<String?>? features;
  Author? author;
  @JsonKey(name: 'listing_seller_note')
  dynamic listingSellerNote;
  dynamic inFavorites;
  List<Similar> similar;

  Map<String, dynamic> toJson() => _$CarDetailToJson(this);
}

@JsonSerializable()
class Gallery {
  Gallery(
    this.url,
  );

  factory Gallery.fromJson(Map<String, dynamic> json) => _$GalleryFromJson(json);

  dynamic url;

  Map<String, dynamic> toJson() => _$GalleryToJson(this);
}

@JsonSerializable()
class Info {
  Info(
    this.infoOne,
    this.infoTwo,
    this.infoThree,
  );

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);

  @JsonKey(name: 'info_1')
  dynamic infoOne;
  @JsonKey(name: 'info_2')
  dynamic infoTwo;
  @JsonKey(name: 'info_3')
  dynamic infoThree;

  Map<String, dynamic> toJson() => _$InfoToJson(this);
}

@JsonSerializable()
class Author {
  Author(
    this.userId,
    this.phone,
    this.stmWhatsappNumber,
    this.image,
    this.name,
    this.lastName,
    this.socials,
    this.email,
    this.showMail,
    this.logo,
    this.dealerImage,
    this.license,
    this.website,
    this.location,
    this.locationLat,
    this.locationLng,
    this.stmCompanyName,
    this.stmCompanyLicense,
    this.stmMessageToUser,
    this.stmSalesHours,
    this.stmSellerNotes,
    this.stmPaymentStatus,
    this.userRole,
    this.regDate,
  );

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  @JsonKey(name: 'user_id')
  dynamic userId;
  dynamic phone;
  @JsonKey(name: 'stm_whatsapp_number')
  dynamic stmWhatsappNumber;
  dynamic image;
  dynamic name;
  @JsonKey(name: 'last_name')
  dynamic lastName;
  dynamic socials;
  dynamic email;
  @JsonKey(name: 'show_mail')
  dynamic showMail;
  dynamic logo;
  @JsonKey(name: 'dealer_image')
  dynamic dealerImage;
  dynamic license;
  dynamic website;
  dynamic location;
  @JsonKey(name: 'location_lat')
  dynamic locationLat;
  @JsonKey(name: 'location_lng')
  dynamic locationLng;
  @JsonKey(name: 'stm_company_name')
  dynamic stmCompanyName;
  @JsonKey(name: 'stm_company_license')
  dynamic stmCompanyLicense;
  @JsonKey(name: 'stm_message_to_user')
  dynamic stmMessageToUser;
  @JsonKey(name: 'stm_sales_hours')
  dynamic stmSalesHours;
  @JsonKey(name: 'stm_seller_notes')
  dynamic stmSellerNotes;
  @JsonKey(name: 'stm_payment_status')
  dynamic stmPaymentStatus;
  @JsonKey(name: 'user_role')
  dynamic userRole;
  @JsonKey(name: 'reg_date')
  dynamic regDate;

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}

@JsonSerializable()
class Similar {
  Similar(
    this.ID,
    this.title,
    this.price,
    this.img,
  );

  factory Similar.fromJson(Map<String, dynamic> json) => _$SimilarFromJson(json);

  dynamic ID;
  dynamic title;
  dynamic price;
  dynamic img;

  Map<String, dynamic> toJson() => _$SimilarToJson(this);
}

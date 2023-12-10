import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserInfo {
  UserInfo(
    this.author,
    this.listingsFound,
    this.listings,
    this.favouritesFound,
    this.favourites,
  );

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Author author;
  @JsonKey(name: 'listings_found')
  int listingsFound;
  List<Listings> listings;
  @JsonKey(name: 'favourites_found')
  int? favouritesFound;
  List<Favourites>? favourites;

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

@JsonSerializable()
class Author {
  Author({
    this.user_id,
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
    this.username,
  });

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  @JsonKey(name: 'user_id')
  dynamic user_id;
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
  dynamic username;

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}

@JsonSerializable()
class Favourites {
  Favourites({
    this.key,
    this.ID,
    this.imgUrl,
    required this.gallery,
    this.imgCount,
    this.price,
    required this.grid,
    required this.list,
  });

  factory Favourites.fromJson(Map<String, dynamic> json) =>
      _$FavouritesFromJson(json);

  dynamic key;
  dynamic ID;
  dynamic imgUrl;
  List<GalleryAuto?> gallery;
  dynamic imgCount;
  dynamic price;
  Grid? grid;
  ListFav list;

  Map<String, dynamic> toJson() => _$FavouritesToJson(this);
}

@JsonSerializable()
class Listings {
  Listings({
    this.ID,
    this.imgUrl,
    required this.gallery,
    this.imgCount,
    this.price,
    required this.grid,
    required this.list,
  });

  factory Listings.fromJson(Map<String, dynamic> json) =>
      _$ListingsFromJson(json);

  dynamic ID;
  dynamic imgUrl;
  List<GalleryAuto?> gallery;
  dynamic imgCount;
  dynamic price;
  Grid? grid;
  ListFav list;

  Map<String, dynamic> toJson() => _$ListingsToJson(this);
}

@JsonSerializable()
class GalleryAuto {
  GalleryAuto({this.url});

  factory GalleryAuto.fromJson(Map<String, dynamic> json) =>
      _$GalleryAutoFromJson(json);

  dynamic url;

  Map<String, dynamic> toJson() => _$GalleryAutoToJson(this);
}

@JsonSerializable()
class Grid {
  Grid(
      {this.title,
      this.subTitle,
      this.infoIcon,
      this.infoTitle,
      this.infoDesc});

  factory Grid.fromJson(Map<String, dynamic> json) => _$GridFromJson(json);

  dynamic title;
  dynamic subTitle;
  dynamic infoIcon;
  dynamic infoTitle;
  dynamic infoDesc;

  Map<String, dynamic> toJson() => _$GridToJson(this);
}

@JsonSerializable()
class ListFav {
  ListFav({
    this.title,
    this.infoOneIcon,
    this.infoOneTitle,
    this.infoOneDesc,
    this.infoTwoIcon,
    this.infoTwoTitle,
    this.infoTwoDesc,
    this.infoThreeIcon,
    this.infoThreeTitle,
    this.infoThreeDesc,
    this.infoFourIcon,
    this.infoFourTitle,
    this.infoFourDesc,
  });

  factory ListFav.fromJson(Map<String, dynamic> json) =>
      _$ListFavFromJson(json);

  dynamic title;
  dynamic infoOneIcon;
  dynamic infoOneTitle;
  dynamic infoOneDesc;
  dynamic infoTwoIcon;
  dynamic infoTwoTitle;
  dynamic infoTwoDesc;
  dynamic infoThreeIcon;
  dynamic infoThreeTitle;
  dynamic infoThreeDesc;
  dynamic infoFourIcon;
  dynamic infoFourTitle;
  dynamic infoFourDesc;

  Map<String, dynamic> toJson() => _$ListFavToJson(this);
}

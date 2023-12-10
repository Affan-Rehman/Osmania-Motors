import 'package:json_annotation/json_annotation.dart';
import 'package:motors_app/data/models/car_detail/car_detail.dart';

part 'main_page.g.dart';

@JsonSerializable()
class MainPage {
  MainPage({
    required this.featured,
    required this.recent,
    this.viewType,
    this.offset,
    this.limit,
    this.featuredMaxNumPages,
    this.lastMaxNumPages,
  });

  factory MainPage.fromJson(Map<String, dynamic> json) => _$MainPageFromJson(json);

  List<Similar> featured;
  List<Recent?> recent;
  dynamic viewType;
  dynamic offset;
  dynamic limit;
  @JsonKey(name: 'featured_max_num_pages')
  dynamic featuredMaxNumPages;
  @JsonKey(name: 'last_max_num_pages')
  dynamic lastMaxNumPages;

  Map<String, dynamic> toJson() => _$MainPageToJson(this);
}

@JsonSerializable()
class Featured {
  Featured(
    this.ID,
    this.title,
    this.price,
    this.img,
  );

  factory Featured.fromJson(Map<String, dynamic> json) => _$FeaturedFromJson(json);

  dynamic ID;
  dynamic title;
  dynamic price;
  dynamic img;

  Map<String, dynamic> toJson() => _$FeaturedToJson(this);
}

@JsonSerializable()
class Recent {
  Recent(
    this.ID,
    this.imgUrl,
    this.gallery,
    this.imgCount,
    this.price,
    this.grid,
    this.list,
  );

  factory Recent.fromJson(Map<String, dynamic> json) => _$RecentFromJson(json);

  dynamic ID;
  dynamic imgUrl;
  List<Gallery?> gallery;
  dynamic imgCount;
  dynamic price;
  dynamic grid;
  dynamic list;

  Map<String, dynamic> toJson() => _$RecentToJson(this);
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

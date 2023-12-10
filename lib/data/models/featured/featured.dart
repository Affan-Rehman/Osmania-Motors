import 'package:json_annotation/json_annotation.dart';

part 'featured.g.dart';

@JsonSerializable()
class FeaturedResponse {
  FeaturedResponse(
    this.featured,
  );

  factory FeaturedResponse.fromJson(Map<String, dynamic> json) => _$FeaturedResponseFromJson(json);

  List<Featured?> featured;

  Map<String, dynamic> toJson() => _$FeaturedResponseToJson(this);
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

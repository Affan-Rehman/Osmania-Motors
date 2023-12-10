import 'package:json_annotation/json_annotation.dart';

part 'place_search.g.dart';

@JsonSerializable()
class PlaceSearchResponse {
  PlaceSearchResponse({required this.predictions, required this.status});

  factory PlaceSearchResponse.fromJson(Map<String, dynamic> json) => _$PlaceSearchResponseFromJson(json);

  final dynamic predictions;
  final String status;

  Map<String, dynamic> toJson() => _$PlaceSearchResponseToJson(this);
}

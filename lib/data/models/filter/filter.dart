import 'package:json_annotation/json_annotation.dart';

part 'filter.g.dart';

@JsonSerializable()
class Filter {
  Filter({
    this.condition,
    this.body,
    this.make,
    this.serie,
    this.mileage,
    this.fuel,
    this.engine,
    this.year,
    this.price,
    this.fuelConsumption,
    this.transmission,
    this.drive,
    this.fuelEconomy,
    this.exteriorColor,
    this.interiorColor,
    this.searchRadius,
  });

  factory Filter.fromJson(Map<String, dynamic> json) => _$FilterFromJson(json);

  dynamic condition;
  dynamic body;
  dynamic make;
  dynamic serie;
  dynamic mileage;
  dynamic fuel;
  dynamic engine;
  dynamic year;
  dynamic price;
  dynamic fuelConsumption;
  dynamic transmission;
  dynamic drive;
  dynamic fuelEconomy;
  dynamic exteriorColor;
  dynamic interiorColor;
  dynamic searchRadius;

  Map<String, dynamic> toJson() => _$FilterToJson(this);
}

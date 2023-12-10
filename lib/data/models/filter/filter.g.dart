// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Filter _$FilterFromJson(Map<String, dynamic> json) => Filter(
      condition: json['condition'],
      body: json['body'],
      make: json['make'],
      serie: json['serie'],
      mileage: json['mileage'],
      fuel: json['fuel'],
      engine: json['engine'],
      year: json['year'],
      price: json['price'],
      fuelConsumption: json['fuelConsumption'],
      transmission: json['transmission'],
      drive: json['drive'],
      fuelEconomy: json['fuelEconomy'],
      exteriorColor: json['exteriorColor'],
      interiorColor: json['interiorColor'],
      searchRadius: json['searchRadius'],
    );

Map<String, dynamic> _$FilterToJson(Filter instance) => <String, dynamic>{
      'condition': instance.condition,
      'body': instance.body,
      'make': instance.make,
      'serie': instance.serie,
      'mileage': instance.mileage,
      'fuel': instance.fuel,
      'engine': instance.engine,
      'year': instance.year,
      'price': instance.price,
      'fuelConsumption': instance.fuelConsumption,
      'transmission': instance.transmission,
      'drive': instance.drive,
      'fuelEconomy': instance.fuelEconomy,
      'exteriorColor': instance.exteriorColor,
      'interiorColor': instance.interiorColor,
      'searchRadius': instance.searchRadius,
    };

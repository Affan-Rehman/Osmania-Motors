part of 'filter_bloc.dart';

abstract class FilterEvent {}

class LoadFilterEvent extends FilterEvent {}

class AddToFilterEvent extends FilterEvent {
  AddToFilterEvent({
    this.limit,
    this.condition,
    this.body,
    this.make,
    this.model,
    this.mileage,
    this.fuel,
    this.engine,
    this.min_year,
    this.max_year,
    this.min_price,
    this.max_price,
    this.fuel_consumption,
    this.transmission,
    this.drive,
    this.fuel_economy,
    this.exterior_color,
    this.interior_color,
    this.search_radius,
  });

  final dynamic limit;
  final dynamic condition;
  final dynamic body;
  final dynamic make;
  final dynamic model;
  final dynamic mileage;
  final dynamic fuel;
  final dynamic engine;
  final dynamic min_year;
  final dynamic max_year;
  final dynamic min_price;
  final dynamic max_price;
  final dynamic fuel_consumption;
  final dynamic transmission;
  final dynamic drive;
  final dynamic fuel_economy;
  final dynamic exterior_color;
  final dynamic interior_color;
  final dynamic search_radius;
}

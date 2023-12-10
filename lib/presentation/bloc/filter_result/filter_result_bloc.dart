import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/utils/location_permission.dart';
import 'package:motors_app/core/utils/logger.dart';
import 'package:motors_app/data/repositories/filter_repository_impl.dart';

part 'filter_result_event.dart';
part 'filter_result_state.dart';

class FilterResultBloc extends Bloc<FilterResultEvent, FilterState> {
  FilterResultBloc(this.filterRepository, this.location)
      : super(InitialFilterListingState()) {
    on<AddToFilterEvent>((event, emit) async {
      emit(InitialFilterListingState());
      try {
        String? currentCity;
        double? maxPrice;
        List<String>? locations = [];
        List<String> models = [];
        List<dynamic>? filter2;

        currentCity = preferences.getString('city');
        log('currentCity' + currentCity.toString());
        List<dynamic> filter = await filterRepository.getFilteredListings(
          limit: event.limit,
          condition: event.location != null
              ? {}
              : event.model != null
                  ? {
                      'make[0]': event.model,
                    }
                  : event.condition,
          min_price: event.min_price,
          max_price: event.max_price,
          min_ca_year: event.min_year,
          max_ca_year: event.max_year,
          max_search_radius: event.search_radius,
        );

        // log(filter[0]['listings'].toString());
        if (filter[0]['listings'].toString() == '[]') {
          emit(EmptyFilteredListingState());
        } else {
          // log('models' + models.toString());
          try {
            maxPrice = filter[0]['listings']
                .map(
                  (e) => double.parse(
                    e['price']
                        .toString()
                        .substring(1)
                        .replaceAll(RegExp(r'[^0-9]'), ''),
                  ),
                )
                .reduce((value, element) => value > element ? value : element);
          } catch (e) {
            maxPrice = filter[0]['listings'].map(
              (e) {
                final priceString = e['price'].toString();
                final numericString =
                    priceString.replaceAll(RegExp(r'[^0-9.]'), '');
                if (numericString.isNotEmpty) {
                  return double.tryParse(numericString) ?? 0.0;
                } else {
                  return 100000000.0;
                }
              },
            ).reduce((value, element) => value > element ? value : element);
          }
          if (event.sort == null &&
              event.sort == null &&
              event.condition.isEmpty &&
              event.min_price == 0 &&
              event.max_price == 0 &&
              event.min_year == 'From' &&
              event.max_year == 'To' &&
              event.search_radius == null) {
            locations = filter[0]['listings']
                .map(
                  (e) => e['grid']['infoDesc'],
                )
                // remove empty locations and duplicates
                .where((e) => e != null && e != '' && e != 'null' && e != ' ')
                .toSet()
                .toList()
                .cast<String>();

            final currentLocations = locations;

            if (currentLocations != null) {
              preferences.setStringList('locations', currentLocations);
            }

            // get models from preferences
            List<dynamic> brands = await filterRepository.getBrands();
            log('brands' + brands.toString());
            models = brands.map((e) => e['slug'].toString()).toList();
            // set models to preferences
            final List<String>? currentModels = models;
            final savedModels = preferences.getStringList('models');

            if (currentModels != null && currentModels != savedModels) {
              preferences.setStringList('models', currentModels);
            }
          }
          if (event.condition.keys.contains('make[0]')) {
            filter2 = await filterRepository.getFilteredListings(
              limit: event.limit,
              condition: {},
              min_price: event.min_price,
              max_price: event.max_price,
              min_ca_year: event.min_year,
              max_ca_year: event.max_year,
              max_search_radius: event.search_radius,
            );
            locations = filter2[0]['listings']
                .map(
                  (e) => e['grid']['infoDesc'],
                )
                // remove empty locations and duplicates
                .where((e) => e != null && e != '' && e != 'null' && e != ' ')
                .toSet()
                .toList()
                .cast<String>();

            final currentLocations = locations;

            if (currentLocations != null) {
              preferences.setStringList('locations', currentLocations);
            }

            // get models from preferences
            List<dynamic> brands = await filterRepository.getBrands();
            models = brands.map((e) => e['slug'].toString()).toList();
            // set models to preferences
            final List<String>? currentModels = models;
            final savedModels = preferences.getStringList('models');

            if (currentModels != null && currentModels != savedModels) {
              preferences.setStringList('models', currentModels);
            }
          }
          // get locations from preferences
          // Retrieve the location preferences from shared preferences
          final List<String>? locationData =
              preferences.getStringList('locations');

// If locationData is not null and locations list is empty, parse the JSON data and add to locations list
          try {
            if (locationData != null && locations!.isEmpty) {
              // decode the JSON data and add to locations list
              locations = locationData;
            }
          } catch (e) {
            log(e.toString());
          }

          // log(locations.toString());
          if (event.sort != null && event.sort == 0) {
            filter[0]['listings']
                // remove the leading $ sign and sort the list by price ascending
                .sort(
              (a, b) => int.parse(
                a['price']
                    .toString()
                    .substring(1)
                    .replaceAll(RegExp(r'[^0-9]'), ''),
              ).compareTo(
                int.parse(
                  b['price']
                      .toString()
                      .substring(1)
                      .replaceAll(RegExp(r'[^0-9]'), ''),
                ),
              ),
            );
          }
          if (event.sort != null && event.sort == 1) {
            filter[0]['listings']
                // remove the leading $ sign and sort the list by price descending
                .sort(
              (a, b) => int.parse(
                b['price']
                    .toString()
                    .substring(1)
                    .replaceAll(RegExp(r'[^0-9]'), ''),
              ).compareTo(
                int.parse(
                  a['price']
                      .toString()
                      .substring(1)
                      .replaceAll(RegExp(r'[^0-9]'), ''),
                ),
              ),
            );
          }
          if (event.sort != null && event.sort == 2) {
            filter[0]['listings']
                // remove the leading $ sign and sort the list by manfucture year ascending
                .sort((a, b) {
              var infoOneDescA = a['grid']['subTitle'];
              var infoOneDescB = b['grid']['subTitle'];
              if (infoOneDescA == null ||
                  infoOneDescA.isEmpty ||
                  !infoOneDescA.contains(RegExp(r'[0-9]'))) {
                return 1;
              } else if (infoOneDescB == null ||
                  infoOneDescB.isEmpty ||
                  !infoOneDescB.contains(RegExp(r'[0-9]'))) {
                return -1;
              } else {
                return int.tryParse(
                      infoOneDescA.replaceAll(RegExp(r'[^\d]'), ''),
                    )?.compareTo(
                      int.tryParse(
                            infoOneDescB.replaceAll(RegExp(r'[^\d]'), ''),
                          ) ??
                          0,
                    ) ??
                    0;
              }
            });
          }
          if (event.sort != null && event.sort == 3) {
            filter[0]['listings']
                // remove the leading $ sign and sort the list by manfucture year descending
                .sort((a, b) {
              var infoOneDescA = a['grid']['subTitle'];
              var infoOneDescB = b['grid']['subTitle'];
              if (infoOneDescA == null ||
                  infoOneDescA.isEmpty ||
                  !infoOneDescA.contains(RegExp(r'[0-9]'))) {
                return 1;
              } else if (infoOneDescB == null ||
                  infoOneDescB.isEmpty ||
                  !infoOneDescB.contains(RegExp(r'[0-9]'))) {
                return -1;
              } else {
                return int.tryParse(
                      infoOneDescB.replaceAll(RegExp(r'[^\d]'), ''),
                    )?.compareTo(
                      int.tryParse(
                            infoOneDescA.replaceAll(RegExp(r'[^\d]'), ''),
                          ) ??
                          0,
                    ) ??
                    0;
              }
            });
          }
          if (event.sort != null && event.sort == 4) {
            filter[0]['listings']
                // remove the leading $ sign and sort the list by mileage ascending
                .sort((a, b) {
              var infoOneDescA = a['list']['infoOneDesc'];
              var infoOneDescB = b['list']['infoOneDesc'];
              if (infoOneDescA == null ||
                  infoOneDescA.isEmpty ||
                  !infoOneDescA.contains(RegExp(r'[0-9]'))) {
                return 1;
              } else if (infoOneDescB == null ||
                  infoOneDescB.isEmpty ||
                  !infoOneDescB.contains(RegExp(r'[0-9]'))) {
                return -1;
              } else {
                return int.tryParse(
                      infoOneDescA.replaceAll(RegExp(r'[^\d]'), ''),
                    )?.compareTo(
                      int.tryParse(
                            infoOneDescB.replaceAll(RegExp(r'[^\d]'), ''),
                          ) ??
                          0,
                    ) ??
                    0;
              }
            });
          }

          if (event.sort != null && event.sort == 5) {
            filter[0]['listings']
                // remove the leading $ sign and sort the list by mileage descending
                .sort((a, b) {
              var infoOneDescA = a['list']['infoOneDesc'];
              var infoOneDescB = b['list']['infoOneDesc'];
              if (infoOneDescA == null ||
                  infoOneDescA.isEmpty ||
                  !infoOneDescA.contains(RegExp(r'[0-9]'))) {
                return 1;
              } else if (infoOneDescB == null ||
                  infoOneDescB.isEmpty ||
                  !infoOneDescB.contains(RegExp(r'[0-9]'))) {
                return -1;
              } else {
                return int.tryParse(
                      infoOneDescB.replaceAll(RegExp(r'[^\d]'), ''),
                    )?.compareTo(
                      int.tryParse(
                            infoOneDescA.replaceAll(RegExp(r'[^\d]'), ''),
                          ) ??
                          0,
                    ) ??
                    0;
              }
            });
          }
          log(filter[0]['listings'].toString());
          log('event.location' + event.location.toString());

          if (event.location != null) {
            // filter = await filterRepository.getFilteredListings(
            //   limit: event.limit,
            //   condition: {},
            //   min_price: event.min_price,
            //   max_price: event.max_price,
            //   min_ca_year: event.min_year,
            //   max_ca_year: event.max_year,
            //   max_search_radius: event.search_radius,
            // );
            filter[0]['listings'] = filter[0]['listings'].where((element) {
              final infoDesc = element['grid']['infoDesc'];
              final sanitizedInfoDesc = infoDesc.toLowerCase();
              log('sanitizedInfoDesc' + sanitizedInfoDesc.toString());
              return sanitizedInfoDesc == event.location.toLowerCase();
            }).toList();
          }
          log(filter[0]['listings'].toString());
          emit(
            LoadedFilteredListingsState(
              filter,
              groupValue: event.sort,
              maxPrice: maxPrice,
              locations: locations ?? [],
              models: models,
              currentCity: currentCity,
            ),
          );
        }
      } on DioError catch (e, s) {
        logger.e('Error during with getFilteredListings, $e, $s');
        emit(ErrorFilterListingState());
      }
    });

    on<searchEvent>((event, emit) async {
      final double? maxPrice;
      List<String> locations = [];
      List<String> models = [];

      emit(InitialFilterListingState());
      try {
        String? currentCity;

        currentCity = preferences.getString('city');

        models = preferences.getStringList('models') ?? [];

        final List<dynamic> filter = await filterRepository.getFilteredListings(
          limit: event.limit,
          condition: event.condition,
          body: event.body,
          mileage: event.mileage,
          fuel: event.fuel,
          engine: event.engine,
          min_price: event.min_price,
          max_price: event.max_price,
          fuel_consumption: event.fuel_consumption,
          transmission: event.transmission,
          drive: event.drive,
          fuel_economy: event.fuel_economy,
          exterior_color: event.exterior_color,
          interior_color: event.interior_color,
          min_ca_year: event.min_year,
          max_ca_year: event.max_year,
          max_search_radius: event.search_radius,
        );
        if (event.isFromHome == true) {
          locations = filter[0]['listings']
              .map(
                (e) => e['grid']['infoDesc'],
              )
              // remove empty locations and duplicates
              .where((e) => e != null && e != '' && e != 'null' && e != ' ')
              .toSet()
              .toList()
              .cast<String>();
          log('locations' + locations.toString());
          final currentLocations = locations;

          preferences.setStringList('locations', currentLocations);

          // get models from preferences
          List<dynamic> brands = await filterRepository.getBrands();
          models = brands.map((e) => e['slug'].toString()).toList();
          // set models to preferences
          final List<String>? currentModels = models;
          final savedModels = preferences.getStringList('models');

          if (currentModels != null && currentModels != savedModels) {
            preferences.setStringList('models', currentModels);
          }
        }

        if (filter[0]['listings'].isEmpty) {
          emit(EmptyFilteredListingState());
        } else {
          try {
            // Retrieve the location preferences from shared preferences
            final List<String>? locationData =
                preferences.getStringList('locations');

// If locationData is not null and locations list is empty
            if (locationData != null && locations.isEmpty) {
              locations = locationData;
            }
          } catch (e) {
            log(e.toString(), stackTrace: StackTrace.current);
          }

          // get the max price from the list
          maxPrice = filter[0]['listings']
              .map(
                (e) => double.parse(
                  e['price']
                              .toString()
                              // .substring(1)
                              .replaceAll(RegExp(r'[^0-9]'), '') ==
                          ''
                      ? '0'
                      : e['price']
                          .toString()
                          // .substring(1)
                          .replaceAll(RegExp(r'[^0-9]'), ''),
                ),
              )
              .reduce((value, element) => value > element ? value : element);
          // log(filter[0]['listings'].toString());
          // filter the list by query
          List filteredList = (filter[0]['listings'] as List<dynamic>)
              .where(
                (element) =>
                    (element['grid']['title'] as String?)
                            ?.toLowerCase()
                            .contains(event.query.toLowerCase()) ==
                        true ||
                    (element['list']['infoDesc'] as String?)
                            ?.toLowerCase()
                            .contains(event.query.toLowerCase()) ==
                        true ||
                    (element['grid']['subTitle'] as String?)
                            ?.toLowerCase()
                            .contains(event.query.toLowerCase()) ==
                        true ||
                    (element['grid']['infoDesc'] as String?)
                            ?.toLowerCase()
                            .contains(event.query.toLowerCase()) ==
                        true ||
                    (element['list']['title'] as String?)
                            ?.toLowerCase()
                            .contains(event.query.toLowerCase()) ==
                        true ||
                    (element['list']['infoTwoDesc'] as String?)
                            ?.toLowerCase()
                            .contains(event.query.toLowerCase()) ==
                        true,

                // (element['grid']['title'] as String?)
              )
              .toList();
          filter[0]['listings'] = filteredList;

          if (filter[0]['listings'].isEmpty)
            emit(EmptyFilteredListingState());
          else
            emit(
              LoadedFilteredListingsState(
                filter,
                maxPrice: maxPrice,
                currentCity: currentCity,
                models: models,
                locations: locations,
              ),
            );
          // log(filter[0]['listings'].toString());
        }
      } on DioError catch (e, s) {
        logger.e('Error during with getFilteredListings, $e, $s');
        emit(ErrorFilterListingState());
      }
    });
  }

  final FilterRepository filterRepository;
  final LocationPermissionImpl location;
}

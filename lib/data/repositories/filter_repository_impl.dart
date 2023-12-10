import 'package:dio/dio.dart';
import 'package:motors_app/data/datasources/filter_data_source.dart';
import 'package:motors_app/data/models/models.dart';

abstract class FilterRepository {
  Future<dynamic> getFilter();
  Future<List<dynamic>> getBrands();

  Future<FeaturedResponse> getFeaturedFilter();

  Future<List<dynamic>> getFilteredListings({
    limit,
    min_ca_year,
    max_ca_year,
    min_price,
    max_price,
    max_search_radius,
    Map<String, dynamic> condition = const {},
    body,
    serie,
    mileage,
    fuel,
    engine,
    fuel_consumption,
    transmission,
    drive,
    fuel_economy,
    exterior_color,
    interior_color,
  });
}

class FilterRepositoryImpl implements FilterRepository {
  FilterDataSource filterDataSource = FilterRemoteDataSource();

  @override
  Future<dynamic> getFilter() {
    try {
      return filterDataSource.getFilter();
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future<List<dynamic>> getBrands() {
    try {
      return filterDataSource
          .getFilter()
          .then((value) => value[0]['make'])
          .then((value) {
        List<String> sequence = [
          'toyota',
          'suzuki',
          'honda',
          'daihatsu',
          'kia',
          'nissan',
          'hyundai',
          'mitsubishi',
          'changan',
          'mercedes',
          'mg',
          'faw',
          'audi',
          'bmw',
          'prince',
          'mazda',
        ];
        value.sort((a, b) {
          int indexA = sequence.indexOf(a['slug']);
          int indexB = sequence.indexOf(b['slug']);
          if (indexA == -1 && indexB == -1) {
            return 0; // Both slugs are unknown, maintain the order
          } else if (indexA == -1) {
            return 1; // Unknown slug comes after known slug
          } else if (indexB == -1) {
            return -1; // Known slug comes before unknown slug
          } else {
            return indexA.compareTo(indexB); // Compare known slugs
          }
        });
        return value;
      });
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future<FeaturedResponse> getFeaturedFilter() async {
    try {
      FeaturedResponse featuredResponse =
          await filterDataSource.getFeaturedFilter();

      return featuredResponse;
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future<List> getFilteredListings({
    limit,
    min_ca_year,
    max_ca_year,
    min_price,
    max_price,
    max_search_radius,
    Map<String, dynamic> condition = const {},
    body,
    serie,
    mileage,
    fuel,
    engine,
    fuel_consumption,
    transmission,
    drive,
    fuel_economy,
    exterior_color,
    interior_color,
  }) async {
    try {
      return filterDataSource.getFilteredListings(
        limit,
        min_ca_year,
        max_ca_year,
        min_price,
        max_price,
        max_search_radius,
        condition,
        body,
        serie,
        mileage,
        fuel,
        engine,
        fuel_consumption,
        transmission,
        drive,
        fuel_economy,
        exterior_color,
        interior_color,
      );
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }
}

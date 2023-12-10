import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:motors_app/core/dio_singleton.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/featured/featured.dart';
import 'package:motors_app/data/models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FilterDataSource {
  Future<dynamic> getFilter();

  Future<FeaturedResponse> getFeaturedFilter();

  Future<List<dynamic>> getFilteredListings(
    limit,
    min_ca_year,
    max_ca_year,
    min_price,
    max_price,
    max_search_radius,
    Map<String, dynamic> condition,
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
}

class FilterRemoteDataSource implements FilterDataSource {
  @override
  Future<dynamic> getFilter() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? savedFile = preferences.getString('saved_data');
    if (savedFile != null) {
      final file = File(savedFile);
      // Read the file.
      final fileContents = await file.readAsString();
      // Decode the JSON data.
      print('file contents from locally ${fileContents.toString()}');
      return jsonDecode(fileContents);
    }

    try {
      print('getting Car data');
      final response =
          await DioSingleton().instance().get('$apiEndPoint/add-car');

      List<dynamic> responseFilter = [];

      responseFilter.add(response.data);
      // Get the application directory.
      final directory = await getApplicationDocumentsDirectory();

// Create a file path with the file name.
      final file = File('${directory.path}/add-car-data.json');
      print(
        'saved file path : ${file.path}',
      );
      preferences.setString('saved_data', file.path);
// Write the JSON object to the file.
      await file.writeAsString(jsonEncode(response.data));
      return response.data;
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future<FeaturedResponse> getFeaturedFilter() async {
    try {
      final response =
          await DioSingleton().instance().get('$apiEndPoint/featured');

      return FeaturedResponse.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future<List> getFilteredListings(
    limit,
    min_ca_year,
    max_ca_year,
    min_price,
    max_price,
    max_search_radius,
    Map<String, dynamic> condition,
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
  ) async {
    try {
      Map<String, dynamic> queryParams = {};

      queryParams = {
        for (var el in filteredListForSearch.isEmpty
            ? condition.isEmpty
                ? []
                : [condition]
            : [filteredListForSearch])
          for (var entry in el.entries) '${entry.key}': entry.value,
        'limit': limit ?? -1,
        'min_price': min_price ?? 0,
        'max_price': max_price ?? 0,
        'min_ca_year': min_ca_year ?? 0,
        'max_ca_year': max_ca_year ?? 0,
        'max_search_radius': max_search_radius,
      };

      log('Query Params Filter: $queryParams');

      List<dynamic> responseFilteredListings = [];

      final response = await DioSingleton().instance().get(
            '$apiEndPoint/filtered-listings',
            queryParameters: queryParams,
          );

      responseFilteredListings.add(response.data);

      if (response.statusCode == 200) {
        filteredListForSearch.clear();
      }

      return responseFilteredListings;
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }
}

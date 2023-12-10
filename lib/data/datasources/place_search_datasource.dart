import 'package:dio/dio.dart';
import 'package:motors_app/core/dio_singleton.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/data/models/models.dart';

abstract class PlaceSearchDataSource {
  Future<PlaceSearchResponse> getAutoComplete(String search);
}

class PlaceSearchRemoteDataSource extends PlaceSearchDataSource {
  @override
  Future<PlaceSearchResponse> getAutoComplete(String search) async {
    var url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    var queryParams = {
      'key': googleApiToken,
      'input': search,
    };

    try {
      Response response = await DioSingleton().instance().get(url, queryParameters: queryParams);

      return PlaceSearchResponse.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }
}

import 'package:dio/dio.dart';
import 'package:motors_app/core/dio_singleton.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/car_detail/car_detail.dart';
import 'package:motors_app/data/models/dealer_user/dealer_user.dart';

abstract class CarDetailDataSource {
  Future<CarDetail> getCarDetail(int? id, int? userId);

  Future addToFavourite(userId, userToken, carId, action);

  Future<DealerResponse> getDealerProfile(dealerId);
}

class CarDetailRemoteDataSource implements CarDetailDataSource {
  @override
  Future<CarDetail> getCarDetail(int? id, int? userId) async {
    String url = '';
print('Hello user Id $userId');
print('Hello user id $id');
    if (id == null && userId == null) {
      url = '$apiEndPoint/listing';
    } else if (id != null && userId != null) {
      url = '$apiEndPoint/listing?id=$id&user_id=$userId';
    } else {
      url = '$apiEndPoint/listing?id=$id';
    }

    try {
      final response = await DioSingleton().instance().get(url);
      return CarDetail.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future addToFavourite(userId, userToken, carId, action) async {
    var record = {
      'userId': userId,
      'userToken': userToken,
      'carId': carId,
      'action': action,
    };

    try {
      await DioSingleton().instance().post(
            '$apiEndPoint/action-with-favorite',
            data: record,
          );
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future<DealerResponse> getDealerProfile(dealerId) async {
    try {
      if (dealerId.toString() == 'null') {
        dealerId = 0;
      }

      final response = await DioSingleton().instance().get('$apiEndPoint/user/$dealerId');

      return DealerResponse.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }
}

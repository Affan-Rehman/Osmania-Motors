import 'package:dio/dio.dart';

import 'package:motors_app/data/datasources/car_detail_datasource.dart';
import 'package:motors_app/data/models/car_detail/car_detail.dart';
import 'package:motors_app/data/models/dealer_user/dealer_user.dart';

abstract class CarDetailRepository {
  Future<CarDetail> getCarDetail({int? id, int? userId});

  Future addToFavorite(userId, userToken, carId, action);

  Future<DealerResponse> getDealerProfile(dealerId);
}

class CarDetailRepositoryImpl implements CarDetailRepository {
  CarDetailDataSource carDetailDataSource = CarDetailRemoteDataSource();

  @override
  Future<CarDetail> getCarDetail({int? id, int? userId}) async {
    try {
      CarDetail carDetail = await carDetailDataSource.getCarDetail(id, userId);

      return carDetail;
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future addToFavorite(userId, userToken, carId, action) async {
    try {
      await carDetailDataSource.addToFavourite(userId, userToken, carId, action);
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future<DealerResponse> getDealerProfile(dealerId) async {
    try {
      DealerResponse dealerResponse = await carDetailDataSource.getDealerProfile(dealerId);

      return dealerResponse;
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }
}

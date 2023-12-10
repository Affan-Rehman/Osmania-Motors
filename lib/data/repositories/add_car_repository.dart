import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:motors_app/data/datasources/add_car_datasource.dart';
import 'package:motors_app/data/datasources/place_search_datasource.dart';
import 'package:motors_app/data/models/models.dart';

abstract class AddCarRepository {
  Future getAddCarParams();

  Future<AddedCarResponse> addCar({Map<String, dynamic> data});

  Future deleteCar(data);

  Future getEditCarData(carId);

  Future<AddedCarResponse> updateCar({Map<String, dynamic> data});

  Future uploadCarPhoto({Map<String, dynamic> data});

  Future searchPlaces({search});
}

class AddCarRepositoryImpl extends AddCarRepository {
  AddCarDataSource addCarDataSource = AddCarRemoteDataSource();
  PlaceSearchDataSource placeSearchDataSource = PlaceSearchRemoteDataSource();

  @override
  Future getAddCarParams() async {
    try {
      AddCarResponse addCarResponse = await addCarDataSource.getAddCarParams();

      return addCarResponse;
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future searchPlaces({search}) async {
    try {
      PlaceSearchResponse placeSearchResponse =
          await placeSearchDataSource.getAutoComplete(search);

      return placeSearchResponse;
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future<AddedCarResponse> addCar({Map<String, dynamic>? data}) async {
    try {
      AddedCarResponse addedCarResponse =
          await addCarDataSource.addCar(data: data!);

      return addedCarResponse;
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future uploadCarPhoto({Map<String, dynamic>? data}) async {
    try {
      var response = await addCarDataSource.uploadCarPhoto(data: data!);

      return response;
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future deleteCar(data) async {
    try {
      var response = await addCarDataSource.deleteCar(data);
      return response;
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future getEditCarData(carId) async {
    try {
      var response = await addCarDataSource.getEditCarData(carId);

      return response;
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future<AddedCarResponse> updateCar({Map<String, dynamic>? data}) async {
    try {
      AddedCarResponse addedCarResponse =
          await addCarDataSource.updateCar(data: data!);

      return addedCarResponse;
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }
}

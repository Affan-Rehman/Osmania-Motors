import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:motors_app/core/dio_singleton.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AddCarDataSource {
  Future<AddCarResponse> getAddCarParams();

  Future<AddedCarResponse> addCar({Map<String, dynamic> data});

  Future deleteCar(data);

  Future getEditCarData(carId);

  Future updateCar({Map<String, dynamic> data});

  Future uploadCarPhoto({Map<String, dynamic> data});
}

class AddCarRemoteDataSource extends AddCarDataSource {
  @override
  Future<AddCarResponse> getAddCarParams() async {
    print('getting cars for choose make');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? savedFile = preferences.getString('saved_data');
    if (savedFile != null) {
      final file = File(savedFile);
      // Read the file.
      final fileContents = await file.readAsString();
      // Decode the JSON data.
      return AddCarResponse.fromJson(jsonDecode(fileContents));
    }

    try {
      final response =
          await DioSingleton().instance().get('$apiEndPoint/add-car');

      return AddCarResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future<AddedCarResponse> addCar({Map<String, dynamic>? data}) async {
    print('Hello add car $data');
    try {
      final response = await DioSingleton().instance().post(
            '$apiEndPoint/add-a-car',
            data: data,
            options: Options(
              headers: {
                'content-Type': 'application/x-www-form-urlencoded',
                'accept': '`Application/json',
              },
            ),
          );

      return AddedCarResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future uploadCarPhoto({Map<String, dynamic>? data}) async {
    try {
      final response = await DioSingleton().instance().post(
            '$apiEndPoint/upload-media',
            data: data,
            options: Options(
              headers: {
                'content-Type': 'application/x-www-form-urlencoded',
                'accept': 'Application/json',
              },
            ),
          );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future deleteCar(data) async {
    try {
      final response = await DioSingleton().instance().post(
            '$apiEndPoint/delete-car',
            data: data,
          );
      return AddedCarResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future getEditCarData(carId) async {
    try {
      final response = await DioSingleton().instance().get(
            '$apiEndPoint/get-edit-car/$carId',
          );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }

  @override
  Future updateCar({Map<String, dynamic>? data}) async {
    try {
      final response = await DioSingleton().instance().post(
            '$apiEndPoint/edit-car',
            data: data,
          );

      return AddedCarResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response);
    }
  }
}

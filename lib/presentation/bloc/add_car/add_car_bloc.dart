import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:motors_app/core/shared_components/location_service.dart';
import 'package:motors_app/data/models/models.dart';
import 'package:motors_app/data/repositories/add_car_repository.dart';
import 'package:provider/provider.dart';

part 'add_car_event.dart';
part 'add_car_state.dart';

class AddCarBloc extends Bloc<AddCarEvent, AddCarState> with ChangeNotifier {
  AddCarBloc() : super(InitialAddCarState()) {
    List<Placemark> locations = [];

    on<LoadAddCarParamsEvent>((event, emit) async {
      // ensure widget is mounted
      if (!event.context.mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Provider.of<LocationService>(event.context, listen: false)
            .getCurrentPosition()
            .then((value) async {
          if (Provider.of<LocationService>(event.context, listen: false)
                  .position !=
              null) {
            locations = await placemarkFromCoordinates(
              Provider.of<LocationService>(event.context, listen: false)
                  .position!
                  .latitude,
              Provider.of<LocationService>(event.context, listen: false)
                  .position!
                  .longitude,
            );
          }
        });
      });
      AddCarResponse addCarResponse = await addCarRepository.getAddCarParams();
      emit(
        LoadedAddCarState(
          addCarResponse: addCarResponse,
          locations: locations,
        ),
      );
    });

    on<AddCar>((event, emit) async {
      AddedCarResponse addedCarResponse = await addCarRepository.addCar(
        data: event.data,
      );

      if (addedCarResponse.code != 200) {
        emit(ErrorAddedCarState(message: addedCarResponse.message));
      } else {
        emit(
          SuccessAddedCarState(addedCarResponse: addedCarResponse),
        );
      }
    });

    on<UploadPhotoEvent>((event, emit) async {
      var response = await addCarRepository.uploadCarPhoto(
        data: event.data,
      );

      emit(SuccessUploadCarPhotoState(response: response));
    });

    on<UpdateCar>((event, emit) async {
      log("car updated ok");
      AddedCarResponse addedCarResponse = await addCarRepository.updateCar(
        data: event.data,
      );

      if (addedCarResponse.code != 200) {
        emit(ErrorAddedCarState(message: addedCarResponse.message));
      } else {
        emit(
          SuccessEditCarState(addedCarResponse: addedCarResponse),
        );
      }
    });
  }

  AddCarRepository addCarRepository = AddCarRepositoryImpl();
}

class AddCarFunctions extends ChangeNotifier {
  AddCarRepository addCarRepository = AddCarRepositoryImpl();
  PlaceSearchResponse? placeSearchResponse;

  //Map для добавление машин
  final Map<String, dynamic> _addCarMap = {};

  Map<String, dynamic> get addCarMap => _addCarMap;

  void addCarParams({type, element}) {
    _addCarMap[type] = element;
    notifyListeners();
  }

  void removeCarParams({type}) {
    if (_addCarMap.containsKey(type)) {
      _addCarMap.remove(type);
      notifyListeners();
    }
  }

  void searchPlaces({search}) async {
    PlaceSearchResponse response =
        await addCarRepository.searchPlaces(search: search);

    placeSearchResponse = response;

    notifyListeners();
  }
}

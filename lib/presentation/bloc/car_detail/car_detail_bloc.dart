import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motors_app/core/utils/logger.dart';
import 'package:motors_app/data/models/car_detail/car_detail.dart';
import 'package:motors_app/data/repositories/car_detail_repository_impl.dart';

part 'car_detail_event.dart';

part 'car_detail_state.dart';

class CarDetailBloc extends Bloc<CarDetailEvent, CarDetailState> {
  CarDetailBloc(this.carDetailRepository) : super(InitialCarDetailState()) {
    on<CarDetailLoadEvent>((event, emit) async {
      BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(100, 100)),
        'assets/images/location_mark.png',
      );

      emit(InitialCarDetailState());

      
      try {
        CarDetail carDetail = await carDetailRepository.getCarDetail(
          id: event.id,
          userId: event.userId,
        );

        if (carDetail.carLat != '' && carDetail.carLng != '') {
          latitude = double.parse(carDetail.carLat);
          longitude = double.parse(carDetail.carLng);
        } else {
          latitude = 37.42796133580664;
          longitude = -122.085749655962;
        }

        markers.add(
          Marker(
            markerId: MarkerId(carDetail.carLocation),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: carDetail.carLocation,
            ),
            icon: markerbitmap,
          ),
        );

        emit(
          LoadedCarDetailState(
            loadedDetailCar: carDetail,
            latitude: latitude,
            longitude: longitude,
            marker: markers,
          ),
        );
      } on DioError catch (e, s) {
        logger.e('Error during with getCarDetail, $e, $s');
        emit(ErrorCarDetailState());
      }
    });

    on<AddToFavorite>((event, emit) async {
      try {
        await carDetailRepository.addToFavorite(
          event.userId,
          event.userToken,
          event.carId,
          event.action,
        );
      } catch (e, s) {
        logger.e('Error during with addToFavorite, $e, $s');
      }
    });

    on<RemoveFromFavorite>((event, emit) async {
      try {
        await carDetailRepository.addToFavorite(
          event.userId,
          event.userToken,
          event.carId,
          event.action,
        );
      } catch (e, s) {
        logger.e('Error during with removeFromFavorite, $e, $s');
      }
    });
  }

  final CarDetailRepository carDetailRepository;

  late double latitude;
  late double longitude;
  Set<Marker> markers = {};
}

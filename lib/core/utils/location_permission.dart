import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:motors_app/core/utils/logger.dart';

abstract class LocationPermissionRequest {
  Future<String?> getCurrentCity();
  Future<String> getAddressFromLatLng(Position position);
}

class LocationPermissionImpl implements LocationPermissionRequest {
  late bool _serviceEnabled;
  late LocationPermission _permission;

  Future<bool> requstLocationPermission() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      // Location services are disabled on the device.
      return false;
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.deniedForever) {
      // Permission denied forever, handle appropriately.
      return false;
    }

    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission != LocationPermission.whileInUse &&
          _permission != LocationPermission.always) {
        // Permissions are denied, handle appropriately.
        return false;
      }
    }
    return true;
  }

  @override
  Future<String?> getCurrentCity() async {
    String? cityName;
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        // forceAndroidLocationManager: true,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        // localeIdentifier: 'en_US',
      );
      // log('placemarks: ${placemarks.map((e) => e.toJson()).toList()}');
      log('placemarks: ${placemarks.map((e) => e.toJson()).toList()}');
      cityName = placemarks[0].locality?.toLowerCase();
    } catch (e) {
      // print(e);
      logger.e('getCurrentCity error: $e');
    }
    return cityName;
  }

  @override
  Future<String> getAddressFromLatLng(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];

    String address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';

    return address;
  }
}

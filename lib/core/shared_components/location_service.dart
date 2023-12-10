import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

enum PositionItemType {
  log,
  position,
}

class PositionItem {
  PositionItem({required this.type, this.position, this.message});

  final PositionItemType type;
  final Position? position;
  final String? message;
}

class LocationService extends ChangeNotifier {
  static const String _kLocationServicesDisabledMessage = 'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage = 'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
  List<PositionItem> positionItems = <PositionItem>[];
  Position? position;
  StreamSubscription<Position>? positionStreamSubscription;
  StreamSubscription<ServiceStatus>? serviceStatusStreamSubscription;
  bool positionStreamStarted = true;
  String? locationServiceStatus = '';

  //Получаем текущую локацию пользователя
  Future<void> getCurrentPosition() async {
    final hasPermission = await handlePermission();

    if (!hasPermission) {
      return;
    }

    Position position = await geolocatorPlatform.getCurrentPosition();

    this.position = position;

    notifyListeners();

    updatePositionList(
      PositionItemType.position,
      position: position,
    );

    notifyListeners();
  }

  //Проверка на permission, принял ли пользователь или нет
  Future<bool> handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await geolocatorPlatform.isLocationServiceEnabled();

    if (!serviceEnabled) {
      updatePositionList(
        PositionItemType.log,
        message: _kLocationServicesDisabledMessage,
      );

      locationServiceStatus = _kLocationServicesDisabledMessage;

      notifyListeners();

      return false;
    }

    permission = await geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        updatePositionList(
          PositionItemType.log,
          message: _kPermissionDeniedMessage,
        );

        locationServiceStatus = _kPermissionDeniedMessage;

        notifyListeners();

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      updatePositionList(
        PositionItemType.log,
        message: _kPermissionDeniedForeverMessage,
      );

      locationServiceStatus = _kPermissionDeniedForeverMessage;

      notifyListeners();
      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    updatePositionList(
      PositionItemType.log,
      message: _kPermissionGrantedMessage,
    );

    locationServiceStatus = _kPermissionGrantedMessage;

    notifyListeners();
    return true;
  }

  //Обновляет класс positionItems
  void updatePositionList(PositionItemType type, {Position? position, dynamic message}) {
    positionItems.add(PositionItem(type: type, position: position, message: message));
  }

  void toggleServiceStatusStream() {
    if (serviceStatusStreamSubscription == null) {
      final serviceStatusStream = geolocatorPlatform.getServiceStatusStream();
      serviceStatusStreamSubscription = serviceStatusStream.handleError((error) {
        serviceStatusStreamSubscription?.cancel();
        serviceStatusStreamSubscription = null;
      }).listen((serviceStatus) {
        String serviceStatusValue;
        if (serviceStatus == ServiceStatus.enabled) {
          if (positionStreamStarted) {
            toggleListening();
          }
          serviceStatusValue = 'enabled';
        } else {
          if (positionStreamSubscription != null) {
            positionStreamSubscription?.cancel();
            positionStreamSubscription = null;
            updatePositionList(PositionItemType.log, message: 'Position Stream has been canceled');
            notifyListeners();
          }
          serviceStatusValue = 'disabled';
        }
        updatePositionList(
          PositionItemType.log,
          message: 'Location service has been $serviceStatusValue',
        );
      });
    }
  }

  void toggleListening() {
    if (positionStreamSubscription == null) {
      final positionStream = geolocatorPlatform.getPositionStream();
      positionStreamSubscription = positionStream.handleError((error) {
        positionStreamSubscription?.cancel();
        positionStreamSubscription = null;
      }).listen((position) {
        this.position = position;
        updatePositionList(
          PositionItemType.position,
          position: position,
        );
      });
      positionStreamSubscription?.pause();
    }

    if (positionStreamSubscription == null) {
      return;
    }

    String statusDisplayValue;
    if (positionStreamSubscription!.isPaused) {
      positionStreamSubscription!.resume();
      statusDisplayValue = 'resumed';
    } else {
      positionStreamSubscription!.pause();
      statusDisplayValue = 'paused';
    }

    updatePositionList(
      PositionItemType.log,
      message: 'Listening for position updates $statusDisplayValue',
    );
  }

  @override
  void dispose() {
    if (positionStreamSubscription != null) {
      positionStreamSubscription!.cancel();
      positionStreamSubscription = null;
    }

    super.dispose();
  }
}

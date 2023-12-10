import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/shared_components/expansion_panel.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/presentation/bloc/car_detail/car_detail_bloc.dart';
import 'package:provider/provider.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({Key? key, required this.state}) : super(key: key);
  final LoadedCarDetailState state;

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.state.loadedDetailCar.carLocation == '' || widget.state.loadedDetailCar.carLocation == null ? false : true,
      child: ExpansionPanelList(
        elevation: 0,
        expansionCallback: (int index, bool isExpanded) {
          Provider.of<ExpansionPanelProvider>(context, listen: false).toggleExpansionLocation();
        },
        children: [
          ExpansionPanel(
            canTapOnHeader: true,
            isExpanded: Provider.of<ExpansionPanelProvider>(context).isExpandedLocation,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: [
                    Icon(IconsMotors.locationMarkFill, color: secondaryColor),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              translations?['location'] ?? 'LOCATION',
                              style: TextStyle(
                                color: grey88,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              widget.state.loadedDetailCar.carLocation,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
            body: SizedBox(
              height: 200,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.state.latitude!, widget.state.longitude!),
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) async {
                  if (!_controller.isCompleted) {
                    _controller.complete(controller);
                  } else {
                    log('Load completer');
                  }
                },
                gestureRecognizers: Set()..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
                markers: widget.state.marker!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

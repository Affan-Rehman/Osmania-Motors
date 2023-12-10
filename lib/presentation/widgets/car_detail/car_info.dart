import 'package:flutter/material.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/presentation/bloc/car_detail/car_detail_bloc.dart';

class CarInfoWidget extends StatelessWidget {
  const CarInfoWidget({Key? key, required this.state}) : super(key: key);

  final LoadedCarDetailState state;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Wrap(
        children: [
          for (var el in state.loadedDetailCar.info)
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 15.0,
                  bottom: 15,
                  right: 15,
                  left: 15,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      dictionaryIcons[el!.infoThree],
                      color: mainColor,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            el.infoOne != null && el.infoOne != ''
                                ? el.infoOne
                                : 'No info',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            el.infoTwo != null && el.infoTwo != ''
                                ? el.infoTwo
                                : 'No info',
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

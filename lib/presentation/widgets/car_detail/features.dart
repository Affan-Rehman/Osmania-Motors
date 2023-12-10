import 'package:flutter/material.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/shared_components/expansion_panel.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/presentation/bloc/car_detail/car_detail_bloc.dart';
import 'package:provider/provider.dart';

class FeaturesWidget extends StatelessWidget {
  const FeaturesWidget({Key? key, required this.state}) : super(key: key);

  final LoadedCarDetailState state;

  @override
  Widget build(BuildContext context) {
    if (state.loadedDetailCar.features == null) {
      return const SizedBox();
    }

    return ExpansionPanelList(
      elevation: 0,
      expansionCallback: (int index, bool isExpanded) {
        Provider.of<ExpansionPanelProvider>(context, listen: false)
            .toggleExpansionFeatures();
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          isExpanded:
              Provider.of<ExpansionPanelProvider>(context).isExpandedFeatures,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 12.5),
              child: Text(
                translations!['features'].toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          body: Wrap(
            children: [
              for (var el in state.loadedDetailCar.features!)
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  margin:
                      const EdgeInsets.only(right: 15, bottom: 20, left: 15),
                  child: Wrap(
                    children: [
                      Icon(
                        IconsMotors.iconComplete,
                        color: mainColor,
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        el!,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

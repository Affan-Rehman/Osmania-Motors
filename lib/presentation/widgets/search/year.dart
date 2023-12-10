import 'package:flutter/material.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/core/shared_components/components.dart';
import 'package:motors_app/presentation/bloc/filter/filter_bloc.dart';
import 'package:provider/provider.dart';

class YearWidget extends StatelessWidget {
  const YearWidget({Key? key, this.element, this.typeKey, required this.state}) : super(key: key);

  final dynamic element;
  final dynamic typeKey;
  final LoadedFilterState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PopupMenuButton(
          onSelected: (val) => Provider.of<SearchFilterProvider>(context, listen: false).toggleFrom(val),
          child: Container(
            width: 100,
            padding: const EdgeInsets.only(left: 15, top: 12, right: 15, bottom: 12),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0xffe9eef0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Provider.of<SearchFilterProvider>(context).from,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(IconsMotors.dropDown, size: 13),
              ],
            ),
          ),
          itemBuilder: (context) => [
            for (var el in element[typeKey])
              PopupMenuItem(
                value: el['value'],
                child: Text(el['label']),
              ),
          ],
        ),
        const SizedBox(width: 20),
        PopupMenuButton(
          onSelected: (val) {
            if (Provider.of<SearchFilterProvider>(context, listen: false).from == 'From') {
              var snackBar = SnackBar(
                content: Text(translations?['year_range_error'] ?? 'First select "from"'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              if (int.parse(val.toString()) <= int.parse(Provider.of<SearchFilterProvider>(context, listen: false).from.toString())) {
                var snackBar = SnackBar(
                  content: Text(translations?['year_range_error_1'] ?? '"From" is bigger than "TO"'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                Provider.of<SearchFilterProvider>(context, listen: false).toggleTo(val);
              }
            }
          },
          child: Container(
            width: 100,
            padding: const EdgeInsets.only(left: 15, top: 12, right: 15, bottom: 12),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0xffe9eef0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Provider.of<SearchFilterProvider>(context).to,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(IconsMotors.dropDown, size: 13),
              ],
            ),
          ),
          itemBuilder: (context) => [
            for (var el in element[typeKey])
              PopupMenuItem(
                value: el['value'],
                child: Text(el['label']),
              ),
          ],
        ),
      ],
    );
  }
}

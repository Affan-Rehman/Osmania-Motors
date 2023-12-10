import 'package:flutter/material.dart';

showCustomBottomSheet(
  BuildContext context, {
  required String type,
  required Widget child,
  Widget? submitButton,
}) {
  showModalBottomSheet(
    isScrollControlled: type == 'location' || type == 'model' ? true : false,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    context: context,
    builder: (context) {
      return Container(
        height: type == 'location' || type == 'model'
            ? MediaQuery.sizeOf(context).height
            : 200,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  children: [
                    Icon(
                      type == 'model_year'
                          ? Icons.time_to_leave_sharp
                          : Icons.shopping_bag_outlined,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      getLabelForType(type),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: type == 'location' || type == 'model'
                  ? Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: child,
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          child,
                          submitButton!
                        ],
                      ),
                    ),
            ),
          ],
        ),
      );
    },
  );
}

String getLabelForType(String type) {
  switch (type) {
    case 'price':
      return 'Price';
    case 'location':
      return 'Location';
    case 'model':
      return 'Make';
    case 'model_year':
      return 'Model Year';

    default:
      return '';
  }
}

import 'package:flutter/material.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/presentation/screens/edit_profile/widgets/text_field.dart';

class PriceRangeWidget extends StatelessWidget {
  const PriceRangeWidget({Key? key, required this.minPriceController, required this.maxPriceController}) : super(key: key);

  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: CustomTextField(
            hintText: translations?['min'] ?? 'Min',
            controller: minPriceController,
            keyboardType: TextInputType.number,
            validator: (val) {
              if (maxPriceController.text != '' && minPriceController.text == '') {
                return translations?['fill_the_form'] ?? 'Fill the form';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          width: 100,
          child: CustomTextField(
            hintText: translations?['max'] ?? 'Max',
            controller: maxPriceController,
            keyboardType: TextInputType.number,
            validator: (val) {
              if (minPriceController.text != '') {
                if (int.parse(maxPriceController.text) < int.parse(minPriceController.text)) {
                  return translations?['price_error'] ?? 'The price cannot be less than the minimum';
                }
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

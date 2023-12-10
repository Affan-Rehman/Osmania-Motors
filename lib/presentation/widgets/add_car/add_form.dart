import 'package:flutter/material.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/presentation/bloc/add_car/add_car_bloc.dart';
import 'package:motors_app/presentation/screens/edit_profile/widgets/text_field.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddFormCard extends StatelessWidget {
  AddFormCard({
    Key? key,
    this.type,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.typeForApi,
    this.priceIsEmpty = false,
    this.validator,
  }) : super(key: key);

  final dynamic type;
  final dynamic typeForApi;
  final TextEditingController? controller;
  TextInputType? keyboardType;
  final dynamic hintText;
  bool priceIsEmpty;
  FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            type,
            style: TextStyle(
              fontSize: 16,
              color: priceIsEmpty ? Colors.red : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          flex: 2,
          child: CustomTextField(
            validator: validator,
            keyboardType: keyboardType,
            controller: controller,
            hintText: hintText,
            onChanged: (val) {
              Provider.of<AddCarFunctions>(context, listen: false).addCarParams(
                type: typeForApi,
                element: controller!.text,
              );

              carData[typeForApi] = controller!.text;
            },
          ),
        ),
      ],
    );
  }
}

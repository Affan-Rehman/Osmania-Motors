import 'package:flutter/material.dart';

class EditFormCard extends StatelessWidget {
  const EditFormCard({
    Key? key,
    this.controller,
    this.keyboardType,
    this.validator,
    this.obscureText,
    this.readOnly,
    this.helperText,
    this.suffixIcon,
    this.hintText,
    this.onTap,
    this.onChanged,
    this.onEditingCompleted,
    this.title,
  }) : super(key: key);

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final bool? obscureText;
  final bool? readOnly;
  final String? helperText;
  final Widget? suffixIcon;
  final String? hintText;
  final GestureTapCallback? onTap;
  final dynamic onChanged;
  final dynamic onEditingCompleted;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, right: 20, left: 10),
      child: Row(
        children: [
          Text(
            '$title',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.8,
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText ?? false,
              onTap: onTap,
              onChanged: onChanged,
              onEditingComplete: onEditingCompleted,
              readOnly: readOnly ?? false,
              decoration: InputDecoration(
                helperText: helperText,
                filled: true,
                fillColor: const Color(0xffe9eef0),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0, color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                isDense: true,
                suffixIcon: suffixIcon,
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 12),
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}

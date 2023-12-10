import 'package:flutter/services.dart';

class FormReg {
  FormReg({
    this.name,
    this.required,
    this.hintText,
    this.suffixIcon,
    this.obscure,
    this.validate,
    this.keyboardType,
    this.emailValidate,
    this.phoneValidate,
    this.imgValidate,
    this.inputFormat,
  });

  dynamic name;
  dynamic required;
  dynamic hintText;
  dynamic suffixIcon;
  dynamic obscure;
  dynamic validate;
  dynamic keyboardType;
  dynamic emailValidate;
  dynamic phoneValidate;
  dynamic imgValidate;
  List<TextInputFormatter>? inputFormat;
}

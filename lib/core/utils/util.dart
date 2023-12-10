import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/icons_motors_icons.dart';
import 'package:motors_app/data/models/form_reg/form_reg.dart';
import 'package:path_provider/path_provider.dart';

///Environment
// const String BASE_URL = 'https://motors.stylemixstage.com/classified';
const String BASE_URL = 'https://osmaniamotors.com';
const String apiEndPoint = '$BASE_URL/wp-json/stm-mra/v1';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

Map<String, dynamic> dictionaryIcons = {
  'road': IconsMotors.road,
  'fuel': IconsMotors.fuel,
  'body_type': IconsMotors.body,
  'engine_fill': IconsMotors.engine,
  'transmission_fill': IconsMotors.transmission,
  'drive_2': IconsMotors.drivingType,
  'color_type': IconsMotors.salonColor,
  '': null,
};

Future<File> urlToFile(String imageUrl) async {
// generate random number.
  var rng = Random();
// get temporary directory of device.
  Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
  String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
  File file = File('$tempPath${rng.nextInt(100)}.png');
// call http.get method and pass imageUrl into it to get response.
  http.Response response = await http.get(Uri.parse(imageUrl));
// write bodyBytes received in response to file.
  await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
  return file;
}

//Преобразовывает из одинаковых ключей в один ключ и добавляет значение в массив
void addValueToMap<K, V>(Map<K, List<V>> map, K key, V value) =>
    map.update(key, (list) => list..add(value), ifAbsent: () => [value]);

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

List<FormReg> itemList = [
  FormReg(
    name: translations!['login'],
    required: '*',
    hintText: '',
    suffixIcon: const SizedBox(),
    obscure: false,
  ),
  FormReg(
    name: translations!['first_name'],
    required: '',
    hintText: '',
    suffixIcon: const SizedBox(),
    obscure: false,
  ),
  FormReg(
    name: translations!['last_name'],
    required: '',
    hintText: '',
    suffixIcon: const SizedBox(),
    obscure: false,
  ),
  FormReg(
    name: translations!['phone'],
    required: '',
    inputFormat: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
    hintText: '',
    suffixIcon: const SizedBox(),
    obscure: false,
    keyboardType: TextInputType.number,
  ),
  FormReg(
    name: translations!['email'],
    required: '*',
    hintText: '',
    suffixIcon: const SizedBox(),
    obscure: false,
    emailValidate: true,
  ),
  FormReg(
    name: translations!['password'],
    required: '*',
    hintText: '',
    obscure: true,
    suffixIcon: const Icon(IconsMotors.eyeShow),
    phoneValidate: true,
  ),
];
// get context global key
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

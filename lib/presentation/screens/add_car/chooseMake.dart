import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motors_app/data/models/hive/add_car.dart';
import 'package:motors_app/presentation/screens/screens.dart';
import 'package:motors_app/presentation/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarMake {
  CarMake({
    required this.label,
    required this.slug,
    required this.logoUrl,
  });
  final String label;
  final String slug;
  final String logoUrl;

  String get GetLabel {
    return label;
  }

  String get GetSlug {
    return slug;
  }

  String get GetURL {
    return logoUrl;
  }
}

class AddCarDetailScreensTwo extends StatefulWidget {
  @override
  _AddCarDetailScreenStateTWO createState() => _AddCarDetailScreenStateTWO();
}

class _AddCarDetailScreenStateTWO extends State<AddCarDetailScreensTwo> {
  List<CarMake> carMakes = [];
  List<CarMake> makes = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? savedFile = preferences.getString('saved_data');
    if (savedFile != null) {
      final file = File(savedFile);
      // Read the file.
      final fileContents = await file.readAsString();
      // Decode the JSON data.
      print('file contents from locally ${fileContents.toString()}');
      // return fileContents;
      AddCarModelHive addCarModelHive = addCarModelHiveFromJson(fileContents);
      if (addCarModelHive.stepOne != null &&
          addCarModelHive.stepOne!.make != null) {
        final makeData = addCarModelHive.stepOne!.make;
        for (var i = 0; i < makeData!.length; i++) {
          makes.add(
            CarMake(
              label: makeData[i].label ?? '',
              slug: makeData[i].slug ?? '',
              logoUrl: makeData[i].logo ?? '',
            ),
          );
        }
        setState(() {
          carMakes = makes;
        });
      }
      return;
    }

    final response = await http
        .get(Uri.parse('https://osmaniamotors.com/wp-json/stm-mra/v1/add-car'));

    if (response.statusCode == 200) {
      // final jsonData = json.decode(response.body);
      AddCarModelHive addCarModelHive = addCarModelHiveFromJson(response.body);
      if (addCarModelHive.stepOne != null &&
          addCarModelHive.stepOne!.make != null) {
        final makeData = addCarModelHive.stepOne!.make;
        for (var i = 0; i < makeData!.length; i++) {
          makes.add(
            CarMake(
              label: makeData[i].label ?? '',
              slug: makeData[i].slug ?? '',
              logoUrl: makeData[i].logo ?? '',
            ),
          );
        }
        setState(() {
          carMakes = makes;
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: carMakes.isEmpty
            ? LoaderWidget()
            : AddCarDetailScreen(
                addType: 'make',
                data: makes.toList(),
              ),
      ),
    );
  }

  void passData() {}
}

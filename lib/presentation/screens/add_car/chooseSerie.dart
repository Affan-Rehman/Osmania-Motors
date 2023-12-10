import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motors_app/presentation/screens/screens.dart';
import 'package:motors_app/presentation/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseSerie extends StatefulWidget {
  @override
  _ChooseSerie createState() => _ChooseSerie();
}

class _ChooseSerie extends State<ChooseSerie> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<Map<String, dynamic>> series = [];

  Future<void> fetchData() async {
    final endpointUrl = 'https://osmaniamotors.com/wp-json/stm-mra/v1/add-car';

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? savedFile = preferences.getString('saved_data');
      if (savedFile != null) {
        final file = File(savedFile);
        // Read the file.
        final fileContents = await file.readAsString();
        // Decode the JSON data.
        print('file contents from locally ${fileContents.toString()}');
        // return jsonDecode(fileContents);
        final Map<String, dynamic> responseData = json.decode(fileContents);

        if (responseData.containsKey('step_one')) {
          final serieData = responseData['step_one']['serie'];
          if (serieData is List) {
            setState(() {
              series = List.from(serieData);
            });
          }
          print(serieData.toString());
        } else {
          print('Serie data not found in the response.');
        }

        return;
      }

      final response = await http.get(Uri.parse(endpointUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('step_one')) {
          final serieData = responseData['step_one']['serie'];
          if (serieData is List) {
            setState(() {
              series = List.from(serieData);
            });
          }
          print(serieData.toString());
        } else {
          print('Serie data not found in the response.');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: series.isEmpty
          ? LoaderWidget()
          : AddCarDetailScreen(
              addType: 'serie',
              data: series,
            ),
    );
  }
}

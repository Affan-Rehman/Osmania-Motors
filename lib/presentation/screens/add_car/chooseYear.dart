import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motors_app/presentation/screens/screens.dart';
import 'package:motors_app/presentation/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseYear extends StatefulWidget {
  @override
  _ChooseYear createState() => _ChooseYear();
}

class _ChooseYear extends State<ChooseYear> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<Map<String, dynamic>> years = [];

  Future<void> fetchData() async {
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
          final yearData = responseData['step_one']['year'];
          if (yearData is List) {
            setState(() {
              years = List.from(yearData);
            });
          }
          print(yearData.toString());
        } else {
          print('Serie data not found in the response.');
        }
    }

    final endpointUrl = 'https://osmaniamotors.com/wp-json/stm-mra/v1/add-car';

    try {
      final response = await http.get(Uri.parse(endpointUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('step_one')) {
          final yearData = responseData['step_one']['year'];
          if (yearData is List) {
            setState(() {
              years = List.from(yearData);
            });
          }
          print(yearData.toString());
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
        body: years.isEmpty
            ? LoaderWidget()
            : AddCarDetailScreen(
                addType: 'year',
                data: years,
              ),);
  }
}

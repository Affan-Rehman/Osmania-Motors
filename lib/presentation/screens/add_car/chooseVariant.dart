import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motors_app/presentation/screens/screens.dart';
import 'package:motors_app/presentation/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseVariant extends StatefulWidget {
  @override
  _ChooseVariantState createState() => _ChooseVariantState();
}

class _ChooseVariantState extends State<ChooseVariant> {
  List<Map<String, dynamic>> variations = [];

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
      // return jsonDecode(fileContents);
      final Map<String, dynamic> responseData = json.decode(fileContents);

      if (responseData.containsKey('step_one')) {
        setState(() {
          variations = List.from(responseData['step_one']['variation']);
        });

        print(variations.toString());
      } else {
        print('Variation data not found in the response.');
      }
      return;
    }

    final endpointUrl = 'https://osmaniamotors.com/wp-json/stm-mra/v1/add-car';

    try {
      final response = await http.get(Uri.parse(endpointUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('step_one')) {
          setState(() {
            variations = List.from(responseData['step_one']['variation']);
          });

          print(variations.toString());
        } else {
          print('Variation data not found in the response.');
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
      body: Center(
        child: variations.isEmpty
            ? LoaderWidget() // Show a loader while fetching data
            : AddCarDetailScreen(
                addType: 'variation',
                data: variations,
              ),
      ),
    );
  }
}

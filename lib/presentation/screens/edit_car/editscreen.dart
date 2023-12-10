// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:motors_app/data/models/user/user.dart';

//implement classes into this! Framework only.

class EditCarScreen extends StatefulWidget {
  Listings car;

  EditCarScreen({Key? key, required this.car}) : super(key: key);

  @override
  State<EditCarScreen> createState() => _EditCarScreenState();
}

class _EditCarScreenState extends State<EditCarScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController mileageCon = TextEditingController();
  TextEditingController bodyCon = TextEditingController();
  TextEditingController locCon = TextEditingController();
  TextEditingController tranCon = TextEditingController();
  // Add controllers for other fields as needed...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
              // Add validation or other properties as needed...
            ),
            // TextFormField(
            //   controller: infoOneDescController,
            //   decoration: InputDecoration(labelText: 'Info One Description'),
            //   // Add validation or other properties as needed...
            // ),
            // TextFormField(
            //   controller: infoTwoDescController,
            //   decoration: InputDecoration(labelText: 'Info Two Description'),
            //   // Add validation or other properties as needed...
            // ),
            // TextFormField(
            //   controller: infoThreeDescController,
            //   decoration: InputDecoration(labelText: 'Info Three Description'),
            //   // Add validation or other properties as needed...
            // ),
            // TextFormField(
            //   controller: infoFourDescController,
            //   decoration: InputDecoration(labelText: 'Info Four Description'),
            //   // Add validation or other properties as needed...
            // ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate back on cancel
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.car.price = 23;

                    Navigator.pop(context); // Navigate back on confirm
                  },
                  child: Text('Confirm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    // infoOneDescController.dispose();
    // infoTwoDescController.dispose();
    // infoThreeDescController.dispose();
    // infoFourDescController.dispose();
    // Dispose other controllers as needed...
    super.dispose();
  }
}

// import cloud_firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/styles/styles.dart';
import 'package:motors_app/core/utils/util.dart';
import 'package:motors_app/data/models/buyer_requests/buy_request.dart';
import 'package:motors_app/presentation/screens/screens.dart';
import 'package:motors_app/presentation/widgets/app_bar_icon.dart';

class NewRequest extends StatefulWidget {
  @override
  _NewRequestState createState() => _NewRequestState();
}

class _NewRequestState extends State<NewRequest> {
  String title = '';
  double price = 0;
  String description = '';
  String location = '';
  String vehicleType = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red,
        leading: AppBarIcon(
          iconData: Icons.arrow_back_outlined,
          borderColor: white,
          iconColor: white,
          onTap: () {
            // if (widget.addType != 'make') {
            //   Navigator.push(context, MaterialPageRoute(builder: (context) {
            //     return AddCarDetailScreensTwo();
            //   }));
            // } else {
            //   Navigator.pop(context);
            // }
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MainScreen(
                  selectedIndex: 0,
                ),
              ),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: Text(
          'New Request',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title:',
              style: TextStyle(
                fontSize: 18,
                fontFamily: GoogleFonts.montserrat().fontFamily,
              ),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
            ),
            // SizedBox(height: 16),
            // Text(
            //   'Price:',
            //   style: TextStyle(fontSize: 18),
            // ),
            // TextField(
            //   keyboardType: TextInputType.number,
            //   onChanged: (value) {
            //     setState(() {
            //       price = double.parse(value);
            //     });
            //   },
            // ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 18,
                fontFamily: GoogleFonts.montserrat().fontFamily,
              ),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
            ),
            SizedBox(height: 16),
            // Text(
            //   'Vehicle Type:',
            //   style: TextStyle(fontSize: 18),
            // ),
            // TextField(
            //   onChanged: (value) {
            //     setState(() {
            //       vehicleType = value;
            //     });
            //   },
            // ),
            // SizedBox(height: 16),
            Text(
              'Location:',
              style: TextStyle(
                fontSize: 18,
                fontFamily: GoogleFonts.montserrat().fontFamily,
              ),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  location = value;
                });
              },
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ElevatedButton(
                    child: Text('Submit'),
                    onPressed: () async {
                      // make validation for all fields

                      if (title.isEmpty ||
                          description.isEmpty ||
                          location.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Please fill all fields'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      await _makeRequest(
                        title: title,
                        // price: price,
                        desc: description,
                        location: location,
                        // vehicleType: vehicleType,
                      );
                      navigatorKey = GlobalKey<NavigatorState>();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Request made successfully'),
                        ),
                      );
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(
                            selectedIndex: 0,
                          ),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _makeRequest({
    required String title,
    // required num price,
    required String desc,
    required String location,
    // required String vehicleType,
  }) async {
    // reference to our firestore database document
    var request = FirebaseFirestore.instance.collection('requests').doc();

    // get user id from shared preferences
    var userId = preferences.getString('userId');

    // create map to send to firebase
    BuyRequest requestMap = BuyRequest(
      ID: userId,
      buyRequestID: request.id,
      title: title,
      // price: price,
      description: desc,
      location: location,
      // vehicleType: vehicleType,
      date: DateTime.now(),
    );

    // try to create the document in firebase
    try {
      await request.set(requestMap.toJson());
    } catch (e) {
      print(e);
    }
  }
}

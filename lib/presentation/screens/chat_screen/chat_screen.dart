import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import intl
import 'package:motors_app/core/env.dart';
import 'package:motors_app/presentation/screens/chat_screen/widgets/image_source_dialog.dart';
import 'package:motors_app/presentation/screens/chat_screen/widgets/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.carTitle,
    required this.dealerId,
    required this.carID,
    required this.authorName,
  }) : super(key: key);
  final String carTitle;
  final String dealerId;
  final String carID;
  final String authorName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  File? _imageFile;
  final fs = FirebaseFirestore.instance;

  // get user id from shared preferences
  final String userId = preferences.getString('userId') ?? '';

  TextEditingController message = TextEditingController();
  @override
  void initState() {
    // var prefs = preferences.getKeys();
    // log(prefs.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          children: [
            Text(
              'Chat for ${widget.carTitle}',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Text(
              'with ${widget.authorName}',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Messages(
                userID: userId,
                carID: int.parse(widget.carID),
                receiverId: widget.dealerId,
                authorName: widget.authorName,
              ),
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.1,
            // ),
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                children: [
                  // image picker
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () {
                        _showImageSourceDialog();
                      },
                      icon: Icon(
                        Icons.image,
                        color: Colors.lightBlue,
                        size: 35,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: message,
                      decoration: InputDecoration(
                        // filled: true,
                        // fillColor: Colors.green[50],
                        hintText: 'message',
                        enabled: true,
                        contentPadding: const EdgeInsets.only(
                          left: 14.0,
                          bottom: 8.0,
                          top: 8.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      validator: (value) {
                        return null;
                      },
                      onSaved: (value) {
                        message.text = value!;
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (message.text.isNotEmpty || _imageFile != null) {
                        // firebase storage instance
                        Reference databaseReference =
                            FirebaseStorage.instance.ref().child('messages');
                        if (_imageFile != null) {
                          log(message.text);
                          String text = message.text;
                          // upload image to firebase storage
                          UploadTask uploadTask = databaseReference
                              .child(DateTime.now().toString())
                              .putFile(_imageFile!);
                          uploadTask.whenComplete(() async {
                            String url =
                                await uploadTask.snapshot.ref.getDownloadURL();
                            fs.collection('Messages').doc().set({
                              'image': url,
                              'time': DateTime.now(),
                              'sender': userId,
                              'receiver': widget.dealerId,
                              'carId': widget.carID,
                              'message': text.isEmpty ? ' ' : text.trim(),
                              'carTitle': widget.carTitle,
                              'receiverName': widget.authorName,
                            });
                          });
                        } else {
                          log(message.text);
                          fs.collection('Messages').doc().set({
                            'message': message.text.trim(),
                            'time': DateTime.now(),
                            'sender': userId,
                            'receiver': widget.dealerId,
                            'carId': int.parse(widget.carID),
                            'image': ' ',
                            'carTitle': widget.carTitle,
                            'receiverName': widget.authorName,
                          });
                        }

                        message.clear();
                        setState(() {
                          _imageFile = null;
                        });
                      }
                    },
                    icon: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.send_sharp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showImageSourceDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return ImageSourceDialog(
          onImageSourceSelected: (ImageSource source) {
            _getImage(source);
          },
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
    }
  }
}

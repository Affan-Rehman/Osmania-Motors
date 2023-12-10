import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Comment {
  Comment({
    required this.id,
    required this.author,
    required this.text,
    required this.timestamp,
  });
  static var url;

  final String id;
  final String author;
  final String text;
  final DateTime timestamp;
}

class CommentWidget2 extends StatefulWidget {

  CommentWidget2({required this.postId, this.userID});
  final String postId;
  final userID;

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget2> {
  bool _imagePicked = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Give Your Feedback On Car Description:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('comments')
              .where('postId', isEqualTo: widget.postId)
              // .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: Text(
                'Failed to load comments',
              ),);
            }
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Center(child: CircularProgressIndicator());
            // }
            // if (snapshot.hasError) {
            //   return Center(child: Text('Error loading comments'));
            // }
            print('reached here');
            final comments = snapshot.data!.docs;
            List<Comment> commentList = [];
            for (var comment in comments) {
              final data = comment.data() as Map<String, dynamic>;
              final author = data['author'];
              final text = data['text'];
              final timestamp = data['timestamp'].toDate();
              commentList.add(Comment(
                id: comment.id,
                author: widget.userID.toString(),
                text: text,
                timestamp: timestamp,
              ),);
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: commentList.length,
              itemBuilder: (context, index) {
                final comment = commentList[index];
                return ListTile(
                  title: Text(comment.text),
                  subtitle: Text('${comment.author} - ${comment.timestamp}'),
                );
              },
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(25.0),
                              topRight: const Radius.circular(25.0),
                            ),
                          ),
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: DraggableScrollableSheet(
                            initialChildSize: 0.95,
                            maxChildSize: 1,
                            builder: (context, scrollController) {
                              return Column(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        'Warning: This form is only for those who visited vehicle recently!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Got insights from a deal?  Was the car description accurate? Did the buyer represent the condition correctly? Your input informs the community, enabling smarter choices for all.',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height:
                                  //       MediaQuery.of(context).size.height / 5,
                                  // ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final picker = ImagePicker();
                                      var image = await picker.pickImage(
                                          source: ImageSource.gallery,);

                                      if (image != null) {
                                        final imageFile = File(image.path);
                                        final storage =
                                            FirebaseStorage.instance;
                                        final fileName =
                                            widget.userID.toString() +
                                                widget.postId.toString() +
                                                DateTime.now().toString();
                                        final reference = storage
                                            .ref()
                                            .child('images/$fileName');

                                        final upload =
                                            reference.putFile(imageFile);
                                        upload.whenComplete(() async {
                                          _imagePicked = true;
                                          Comment.url =
                                              await reference.getDownloadURL();
                                          print('The URL IS: ${Comment.url}');
                                        });
                                      } else {
                                        _imagePicked = false;
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .blue, // Button background color
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 24,),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.camera_alt,
                                            color: Colors.white,),
                                        Text(
                                          'Submit Proof Of Visit',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 40,
                                  ),

                                  Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                top: 10,
                                                right: 10,
                                                bottom: 10,),
                                            child: Container(
                                              height: 100,
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: Colors.blue,),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2, bottom: 10,),
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'Share Your Review To Help Community:',),
                                                  controller:
                                                      _commentController,
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.all(8.0),
                                        //   child: IconButton(
                                        //       disabledColor: Colors.grey,
                                        //       color: Colors.blue,
                                        //       icon: Icon(
                                        //         Icons.send,
                                        //         //color: Colors.blue,
                                        //       ),
                                        //       onPressed: !_imagePicked
                                        //           ? null
                                        //           : () async {
                                        //               if (_imagePicked) {
                                        //                 final String
                                        //                     commentText =
                                        //                     _commentController
                                        //                         .text;
                                        //                 final String author = widget
                                        //                     .userID; // Replace with actual user data if you have authentication
                                        //                 final DateTime
                                        //                     timestamp =
                                        //                     DateTime.now();

                                        //                 if (commentText
                                        //                         .isNotEmpty &&
                                        //                     _imagePicked ==
                                        //                         true) {
                                        //                   await FirebaseFirestore
                                        //                       .instance
                                        //                       .collection(
                                        //                           'comments')
                                        //                       .add({
                                        //                     'postId':
                                        //                         widget.postId,
                                        //                     'author': author,
                                        //                     'text': commentText,
                                        //                     'timestamp':
                                        //                         timestamp,
                                        //                     'url': Comment.url,
                                        //                   });
                                        //                   _commentController
                                        //                       .clear();
                                        //                 }
                                        //               }
                                        //             }),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          disabledBackgroundColor: Colors.grey,
                                          minimumSize: Size(250, 50),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0),),),
                                      onPressed: !_imagePicked
                                          ? null
                                          : () async {
                                              if (_imagePicked) {
                                                final String commentText =
                                                    _commentController.text;
                                                final String author = widget
                                                    .userID; // Replace with actual user data if you have authentication
                                                final DateTime timestamp =
                                                    DateTime.now();

                                                if (commentText.isNotEmpty &&
                                                    _imagePicked == true) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('comments')
                                                      .add({
                                                    'postId': widget.postId,
                                                    'author': author,
                                                    'text': commentText,
                                                    'timestamp': timestamp,
                                                    'url': Comment.url,
                                                  });
                                                  _commentController.clear();
                                                }
                                              }
                                            },
                                      child: Text('Submit'),)
                                ],
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Text(
                      'Add your honest reviews',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // IconButton(
              //   icon: Icon(Icons.send),
              //   onPressed: () async {
              //     final String commentText = _commentController.text;
              //     final String author = widget
              //         .userID; // Replace with actual user data if you have authentication
              //     final DateTime timestamp = DateTime.now();

              //     if (commentText.isNotEmpty) {
              //       await FirebaseFirestore.instance
              //           .collection('comments')
              //           .add({
              //         'postId': widget.postId,
              //         'author': author,
              //         'text': commentText,
              //         'timestamp': timestamp,
              //       });
              //       _commentController.clear();
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

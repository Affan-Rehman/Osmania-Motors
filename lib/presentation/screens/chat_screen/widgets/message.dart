import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/env.dart';

class Messages extends StatefulWidget {
  Messages({
    required this.userID,
    required this.carID,
    required this.receiverId,
    required this.authorName,
  });

  String userID;
  int carID;
  String receiverId;
  String authorName;

  @override
  _MessagesState createState() => _MessagesState(
        userID: userID,
        carID: carID,
        receiverId: receiverId,
        authorName: authorName,
      );
}

class _MessagesState extends State<Messages> {
  _MessagesState({
    required this.userID,
    required this.carID,
    required this.receiverId,
    required this.authorName,
  });

  ScrollController _scrollController = ScrollController();
  String userID;
  int carID;
  String receiverId;
  String authorName;
  late Stream<QuerySnapshot> _messageStream;
  String userName = '*';

  @override
  void initState() {
    _messageStream = FirebaseFirestore.instance
        .collection('Messages')
        .where('carId', isEqualTo: carID)
        // .where('sender', isEqualTo: userID)
        // .where('receiver', isEqualTo: receiverId)
        .orderBy('time')
        .snapshots();
    // get userName from shared preferences
    userName = preferences.getString('userName') ?? '*';
    if (userName.isEmpty) {
      userName = '*';
    }
    if (authorName.isEmpty) {
      authorName = '*';
    }
    print('UserName 222 $authorName');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // scroll to bottom
    return StreamBuilder(
      stream: _messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          log(snapshot.error.toString());
          return Text('something is wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
        return ScrollNotificationObserver(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: snapshot.data!.docs.length,
            physics: ScrollPhysics(),
            shrinkWrap: true,
            // primary: true,
            itemBuilder: (_, index) {
              QueryDocumentSnapshot qs = snapshot.data!.docs[index];
              String senderId = qs.get('sender');
              String receiverID = qs.get('receiver');
              // log(senderId);
              // log(receiverID);
              Timestamp t = qs['time'];
              DateTime d = t.toDate();

              if (senderId == userID || receiverID == receiverId || receiverID == userID || senderId == receiverId) {
                if (index == snapshot.data!.docs.length - 1) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  });
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Column(
                    crossAxisAlignment: userID == qs['sender'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 300,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: userID == qs['sender'] ? Colors.blue : Colors.grey,
                              width: 1,
                            ),
                            color: userID == qs['sender'] ? Colors.blue: Colors.grey[50],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),

                            ],

                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 220,
                                child: qs['image'] != ' '
                                    ? qs['message'] == ' '
                                        ? Image.network(qs['image']!)
                                        : Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Image.network(qs['image']!),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  // avatar with user first letter
                                                  CircleAvatar(
                                                    radius: 18,
                                                    backgroundColor: Colors.purple,
                                                    child: Text(
                                                      userID == qs['sender'] ? userName[0] : authorName[0],
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(
                                                    qs['message'],
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: userID == qs['sender'] ? Colors.lightBlue : Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                    : Row(
                                        children: [
                                          // avatar with user first letter
                                          if (userID != qs['sender']) ...[
                                            CircleAvatar(
                                              radius: 18,
                                              backgroundColor: Colors.purple,
                                              child: Image.asset('assets/images/avatar.png'),
                                              /*Text(
                                              userID == qs['sender'] ? userName[0] : authorName[0],
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),*/
                                            ),

                                          ],
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Flexible(
                                            child: Text(
                                              qs['message'],
                                              softWrap: true,
                                              // maxLines: 10,
                                              overflow: TextOverflow.visible,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: qs['sender'] == userID ? Colors.white : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Text(
                                  d.hour.toString() + ':' + d.minute.toString(),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        );
      },
    );
  }
}

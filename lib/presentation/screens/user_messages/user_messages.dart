import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/presentation/screens/chat_screen/chat_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserMessagesScreen extends StatefulWidget {
  @override
  State<UserMessagesScreen> createState() => _UserMessagesScreenState();
}

class _UserMessagesScreenState extends State<UserMessagesScreen> {
  late Stream<QuerySnapshot> _messageStream;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: _messageStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('something is wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No messages yet'),
            );
          }
          // Filter messages by carId
          // Filter messages by carId
          Map<String, List<QueryDocumentSnapshot>> messagesByCarId = {};
          snapshot.data!.docs.forEach((message) {
            final carId = message['carId'].toString();
            final userId = preferences.getString('userId') ?? '';
            final senderId = message['sender'].toString();
            final receiverId = message['receiver'].toString();
            if (messagesByCarId.containsKey(carId)) {
              if (userId == senderId || userId == receiverId)
                messagesByCarId[carId]!.add(message);

              // messagesByCarId[carId]!.add(message);
            } else {
              if (userId == senderId || userId == receiverId) {
                messagesByCarId[carId] = [message];
              }
            }
          });

          return ListView.builder(
            itemCount: messagesByCarId.keys.length,
            itemBuilder: (context, index) {
              final carId = messagesByCarId.keys.elementAt(index);
              final carMessages = messagesByCarId[carId]!;
              final message = carMessages.first;
              final text = message['message'].toString();
              final userName = preferences.getString('userName') ?? '*';
              final chatWith = userName == message['receiverName']
                  ? userName
                  : message['receiverName'];
              if (carMessages.isEmpty) {
                return Center(
                  child: Text('No messages yet'),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          carTitle: message['carTitle'],
                          dealerId: message['sender'],
                          carID: message['carId'].toString(),
                          authorName: chatWith,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 8.0,
                      ),
                      MessageTile(
                        message: text,
                        time: message['time'],
                        carTitle: message['carTitle'],
                        chatWith: chatWith,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    // get user id from shared preferences
    String userID = preferences.getString('userId') ?? '';
    // TODO: implement initState

    _messageStream = FirebaseFirestore.instance
        .collection('Messages')
        // .where('receiver', isEqualTo: userID)
        .orderBy('time', descending: true)
        .orderBy('carId')
        .snapshots();

    // filter the stream to get only per car id

    super.initState();
  }
}

class MessageTile extends StatelessWidget {
  const MessageTile({
    required this.message,
    required this.time,
    required this.carTitle,
    required this.chatWith,
  });
  final String message;
  final Timestamp time;
  final String carTitle;
  final String chatWith;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        isThreeLine: false,
        title: Text(
          carTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
          ),
        ),
        subtitle: Text(
          chatWith,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),
        trailing: Column(
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.25,
              child: Text(
                message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24.0,
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.3,
              child: Text(
                timeago.format(time.toDate(), allowFromNow: true),
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

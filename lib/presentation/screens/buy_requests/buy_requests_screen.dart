// imprt firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/data/models/user_messages/user_messages.dart';
import 'package:motors_app/presentation/bloc/profile/profile_bloc.dart';

class UserMessageScreen extends StatefulWidget {
  const UserMessageScreen({Key? key, required this.buyRequestId})
      : super(key: key);

  final String buyRequestId;
  @override
  State<UserMessageScreen> createState() => _UserMessageScreenState();
}

class _UserMessageScreenState extends State<UserMessageScreen> {
  TextEditingController _messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Messages', style: TextStyle(color: Colors.black)),
          ),
          body: Column(
            children: [
              StreamBuilder<List<UserMessage>>(
                stream: getUserMessages(widget.buyRequestId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                snapshot.data![index].userName!.substring(0, 1),
                              ),
                            ),
                            title: Text(snapshot.data![index].userName!),
                            subtitle: Text(snapshot.data![index].message!),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(child: Text('No messages'));
                  }
                },
              ),
              // Spacer(),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    FloatingActionButton(
                      child: Icon(Icons.send),
                      onPressed: () {
                        if (state is LoadedProfileState) {
                          var userName = state.userInfo.author.username ?? '';
                          sendMessage(
                            widget.buyRequestId,
                            userName,
                            _messageController.text,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // get userId from prefs

    var userId = preferences.getString('userId');

    // TODO: implement initState
    // get user profile from bloc
    BlocProvider.of<ProfileBloc>(context).add(LoadProfileEvent(userId));

    super.initState();
  }
}

Stream<List<UserMessage>> getUserMessages(String buyRequestId) {
  return FirebaseFirestore.instance
      .collection('requests')
      .doc(buyRequestId)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return UserMessage.fromJson(doc.data());
    }).toList();
  });
}

Future sendMessage(String buyRequestId, String userName, String message) async {
  var userId = preferences.getString('userId');

  final docMessage = FirebaseFirestore.instance
      .collection('requests')
      .doc(buyRequestId)
      .collection('messages');

  var userMessage = UserMessage(
    id: docMessage.id,
    userId: userId,
    userName: userName,
    message: message,
  );

  await docMessage.add(userMessage.toJson());
}

List<Map<String, String>> messages = [
  {'userName': 'John Doe', 'message': 'Hello, how are you?'},
  {'userName': 'Jane Smith', 'message': 'I am good, thanks!'},
  // Add more messages here...
];

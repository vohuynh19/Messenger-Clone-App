import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone_app/firebase_method.dart';
import 'package:messenger_clone_app/screen/chat_screen/chat_screen.dart';

class ChatRoomWidget extends StatefulWidget {
  ChatRoomWidget({
    @required this.size,
  });
  final Size size;

  @override
  _ChatRoomWidgetState createState() => _ChatRoomWidgetState();
}

class _ChatRoomWidgetState extends State<ChatRoomWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(10),
      width: widget.size.width,
      height: widget.size.height * 0.7,
      child: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chatrooms')
              .orderBy('lastSent', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var list = snapshot.data.docs.where((element) {
              return element.id.contains(FirebaseAuth.instance.currentUser.uid);
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list.map((e) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ChatScreen(
                            e.id.replaceAll(
                                FirebaseAuth.instance.currentUser.uid, ''),
                            widget.size)));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: widget.size.width,
                    height: 50,
                    child: Row(
                      children: [
                        AvatarWidget(
                            id: e.id.replaceAll(
                                FirebaseAuth.instance.currentUser.uid, ''),
                            width: widget.size.width * 0.2),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder(
                                future: getUserInfo(e.id.replaceAll(
                                    FirebaseAuth.instance.currentUser.uid, '')),
                                builder: (context,
                                    AsyncSnapshot<Map<String, dynamic>>
                                        snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text('Loading..');
                                  }
                                  return Text(
                                    snapshot.data['email'],
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  );
                                }),
                            e.data()['senter'] ==
                                    FirebaseAuth.instance.currentUser.uid
                                ? Text('You: ' + e.data()['message'])
                                : Text('He/She: ' + e.data()['message']),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

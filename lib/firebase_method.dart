import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>> getUserInfo(String uid) async {
  DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  return doc.data();
}

String chatRoomStandard(String id_1, String id_2) {
  if (id_1.compareTo(id_2) == -1) {
    return id_1 + id_2;
  }
  return id_2 + id_1;
}

Future<void> sendAMessage(
    String senterUid, String receiverUid, String message, DateTime date) async {
  String roomID = chatRoomStandard(senterUid, receiverUid);
  FirebaseFirestore.instance.collection('chatrooms').doc(roomID).set({
    'lastSent': date,
    'senter': senterUid,
    'message': message,
  });
  FirebaseFirestore.instance
      .collection('chatrooms')
      .doc(roomID)
      .collection('messages')
      .add({
    'lastSent': date,
    'senter': senterUid,
    'message': message,
  });
}

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    Key key,
    @required this.id,
    @required this.width,
  }) : super(key: key);
  final id;
  final width;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserInfo(id),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircleAvatar(
              radius: width / 2,
            );
          }
          return CircleAvatar(
            radius: width / 2,
            backgroundImage: NetworkImage(
              snapshot.data['avatarUrl'],
            ),
          );
        });
  }
}

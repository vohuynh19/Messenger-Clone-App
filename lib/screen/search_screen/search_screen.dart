import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone_app/screen/chat_screen/chat_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  void enterChatRoom(String friendId, Size size) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ChatScreen(friendId, size),
      ),
    );
  }

  List<Widget> getItem(
      AsyncSnapshot<QuerySnapshot> snapshot, String id, Size size) {
    var list = snapshot.data.docs.map((doc) {
      if (doc.data()['email'] == null) {
        return null;
      }
      if (doc.data()['email'].toString().contains(id)) {
        return InkWell(
          onTap: () => enterChatRoom(doc.id, size),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(doc.data()['avatarUrl']),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(doc.data()['email']),
              ],
            ),
          ),
        );
      }
    }).toList();
    return list.where((element) => element != null).toList();
  }

  String text = '!';
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            width: size.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  text = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter email',
              ),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: ((context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return Container(
            width: size.width,
            height: size.height * 0.8,
            child: SingleChildScrollView(
              child: Column(
                children: getItem(snapshot, text, size),
              ),
            ),
          );
        }),
      ),
    );
  }
}

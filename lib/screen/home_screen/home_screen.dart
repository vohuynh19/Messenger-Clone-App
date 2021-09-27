import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone_app/firebase_method.dart';
import 'component/chatroom_widget.dart';
import 'component/search_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: FutureBuilder(
          future: getUserInfo(FirebaseAuth.instance.currentUser.uid),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.data != null) {
              return Container(
                margin: EdgeInsets.only(left: 10),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data['avatarUrl']),
                ),
              );
            }
            return Container(
                margin: EdgeInsets.only(left: 10), child: CircleAvatar());
          },
        ),
        title: Text(
          'Chat',
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: [
          InkWell(
            child: Icon(
              Icons.exit_to_app_outlined,
              color: Colors.black,
              size: 35,
            ),
            onTap: _signOut,
          ),
          SizedBox(
            width: 10,
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchWidget(size: size),
            ChatRoomWidget(size: size),
          ],
        ),
      ),
    );
  }
}

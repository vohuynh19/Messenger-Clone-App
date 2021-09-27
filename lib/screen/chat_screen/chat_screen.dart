import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone_app/firebase_method.dart';

class ChatScreen extends StatefulWidget {
  final String friendID;
  final String myID = FirebaseAuth.instance.currentUser.uid;
  final size;
  ChatScreen(this.friendID, this.size);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _textController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: FutureBuilder(
          future: getUserInfo(widget.friendID),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.black,
                ),
              );
            }
            return Text(
              snapshot.data['email'],
              style: TextStyle(
                color: Colors.black,
              ),
            );
          },
        ),
      ),
      body: Container(
        height: widget.size.height * (0.85),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(chatRoomStandard(widget.myID, widget.friendID))
                    .collection('messages')
                    .orderBy('lastSent', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: widget.size.height * 0.77,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return Container(
                    height: widget.size.height * 0.77,
                    child: ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, idx) {
                        var element = snapshot.data.docs[idx];
                        if (element.data()['senter'] == widget.myID) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 5),
                            width: widget.size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: widget.size.width * 0.83,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                    ),
                                    child: Text(
                                      element.data()['message'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container(
                          margin: EdgeInsets.only(bottom: 5),
                          width: widget.size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AvatarWidget(
                                  width: widget.size.width * 0.15,
                                  id: widget.friendID),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: widget.size.width * 0.8,
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    element.data()['message'],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: widget.size.width,
                height: widget.size.height * 0.065,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: widget.size.width * 0.8,
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          sendAMessage(
                              FirebaseAuth.instance.currentUser.uid,
                              widget.friendID,
                              _textController.text.trim(),
                              DateTime.now());
                          _textController.clear();
                        },
                        child: Icon(Icons.send)),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

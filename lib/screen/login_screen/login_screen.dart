import 'package:flutter/material.dart';
import 'package:messenger_clone_app/screen/login_screen/component/decorate.dart';
import 'component/input.dart';
import 'component/decorate.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.network(
            'https://logos-world.net/wp-content/uploads/2021/02/Facebook-Messenger-Logo.png'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DecorateElement(),
            SizedBox(
              height: 30,
            ),
            InputElement(),
          ],
        ),
      ),
    );
  }
}

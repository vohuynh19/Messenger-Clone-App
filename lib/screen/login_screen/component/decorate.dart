import 'package:flutter/material.dart';
import '../helper/gradient.dart';

class DecorateElement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
        width: size.width,
        padding: EdgeInsets.only(left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientText(),
            SizedBox(
              height: 30,
            ),
            Text(
              'Messenger makes it easy and fun to stay close to your favorite people.',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ));
  }
}

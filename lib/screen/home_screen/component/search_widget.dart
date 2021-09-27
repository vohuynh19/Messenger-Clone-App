import 'package:flutter/material.dart';
import 'package:messenger_clone_app/screen/search_screen/search_screen.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SearchScreen()),
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        padding: EdgeInsets.all(10),
        width: size.width,
        height: size.height * 0.05,
        decoration: BoxDecoration(
            color: Colors.black12, borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.search_sharp),
            SizedBox(
              width: 10,
            ),
            Text(
              'Search by email',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

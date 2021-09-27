import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF0088FF), Color(0xFFA033FF), Color(0xFFFF5C87)],
      ).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Hang out',
            style: TextStyle(
              // The color must be set to white for this to work
              color: Colors.white,
              fontSize: 65,
            ),
          ),
          Text(
            'anytime,',
            style: TextStyle(
              // The color must be set to white for this to work
              color: Colors.white,
              fontSize: 65,
            ),
          ),
          Text(
            'anywhere',
            style: TextStyle(
              // The color must be set to white for this to work
              color: Colors.white,
              fontSize: 65,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HeadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 70.0),
        child: Text(
          "Eserve",
          style: TextStyle(
            fontSize: 40.0,
            color: Colors.white,
            wordSpacing: 4.0,
          ),
        ),
      ),
    );
  }
}

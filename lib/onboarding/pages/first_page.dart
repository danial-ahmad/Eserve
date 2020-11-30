import 'package:flutter/material.dart';
import 'package:Eserve/onboarding/heading.dart';
import 'package:Eserve/onboarding/image_with_gradient.dart';

class MyFirstPage extends StatelessWidget {
  final String _subheading;
  final Image _icon;
  final String _backgroundImage;
  final String _footer;

  MyFirstPage(
      this._subheading, this._icon, this._backgroundImage, this._footer);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        color: Colors.blueAccent,
      ),
      ImageWithGradient(_backgroundImage),
      Column(
        children: <Widget>[
          HeadingWidget(),
          Container(
            padding: EdgeInsets.all(20.0),
          ),
          Text(this._subheading,
              style: TextStyle(fontSize: 30.0, color: Colors.white)),
          Container(margin: EdgeInsets.only(top: 40.0), child: this._icon),
          Container(
            padding: EdgeInsets.only(top: 20),
          ),
          Text(this._footer,
              style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                  fontStyle: FontStyle.italic),
              textAlign: TextAlign.center)
        ],
      )
    ]);
  }
}

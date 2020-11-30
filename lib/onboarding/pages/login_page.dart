import 'package:Eserve/login_register/login_pro.dart';
import 'package:Eserve/login_register/login_cust.dart';
import 'package:flutter/material.dart';

import 'package:Eserve/onboarding/heading.dart';
import 'package:Eserve/onboarding/image_with_gradient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyLoginPage extends StatelessWidget {
  final String _subheading;
  final String _backgroundImage;
  final String _footer;

  MyLoginPage(this._subheading, this._backgroundImage, this._footer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        ImageWithGradient(_backgroundImage),
        ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 40.0),
                HeadingWidget(),
                SizedBox(height: 30.0),
                Container(
                  margin: EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 25.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 10.0, bottom: 30.0, left: 30.0, right: 30.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          Text("Choose who you are"),
                          SizedBox(height: 20),
                          CLoginBtn(context),
                          SizedBox(height: 20),
                          BLoginBtn(context),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Text(_footer,
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center)
              ],
            ),
          ],
        )
      ]),
    );
  }

  Widget CLoginBtn(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
          gradient: LinearGradient(
              begin: FractionalOffset.bottomLeft,
              end: FractionalOffset.topRight,
              colors: [
                Color(0xFFC04848),
                Color(0xFF480048),
              ],
              stops: [
                0.0,
                1.0
              ])),
      child: MaterialButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'I am Customer',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ],
        ),
        splashColor: Colors.green,
        height: 45.0,
        minWidth: 45.0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginCust()),
          );
        },
      ),
    );
  }

  Widget BLoginBtn(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.white,
          gradient: LinearGradient(
              begin: FractionalOffset.bottomLeft,
              end: FractionalOffset.topRight,
              colors: [
                Color(0xFF480048),
                Color(0xFFC04848),
              ],
              stops: [
                0.0,
                1.0
              ])),
      child: MaterialButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'I am Professional',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ],
        ),
        splashColor: Colors.green,
        height: 45.0,
        minWidth: 45.0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPro()),
          );
        },
      ),
    );
  }
}

import 'package:Eserve/Professional/prohome.dart';
import 'package:Eserve/login_register/create_account.dart';

import 'package:Eserve/login_register/register_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Eserve/login_register/models/user.dart';
import 'package:Eserve/onboarding/heading.dart';
import 'package:Eserve/onboarding/image_with_gradient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPro extends StatefulWidget {
  @override
  _LoginProState createState() => _LoginProState();
}

class _LoginProState extends State<LoginPro> {
  final _formKey = GlobalKey<FormState>();
  String error = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  bool _autoValidate = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String message = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        ImageWithGradient("images/salon_shop.png"),
        ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                HeadingWidget(),
                SizedBox(height: 10.0),
                // Container(
                //   padding: EdgeInsets.all(20.0),
                // ),
                Text("Welcome Professional",
                    style: TextStyle(fontSize: 30.0, color: Colors.white)),
                SizedBox(height: 48.0),
                // _GoogleLoginBtn(context),
                /* SizedBox(height: 8.0),
                Text(
                  'OR',
                  style: TextStyle(color: Colors.white),
                ),*/
                Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 25.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 30.0, right: 30.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _emailController,
                              validator: emailValidator,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: "you@example.com",
                                  labelText: "Email"),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              validator: pwdValidator,
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: "Your password here...",
                                  labelText: "Password"),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: RaisedButton(
                                child: new Text(
                                  'Login',
                                  style: new TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    try {
                                      var result = FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text)
                                          .then((AuthResult auth) {
                                        FirebaseUser user = auth.user;
                                        var userid = user.uid;
                                        _showMyDialog(userid);
                                      }).catchError((e) {
                                        print(e);
                                        setState(() {
                                          message =
                                              "invalid password or username";
                                        });
                                      });
                                    } catch (e) {
                                      setState(() {
                                        message =
                                            "invalid password or username";
                                      });
                                    }
                                  }
                                },
                                color: Colors.green,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                    child: Text(
                  message,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account? ",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                            fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => RegPro()));
                      },
                      child: Text("Sign UP!",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.green,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                    )
                  ],
                ),
              ],
            ),
          ],
        )
      ]),
    );
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return '*Required';
    if (!regex.hasMatch(value))
      return '*Enter a valid email';
    else
      return null;
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  Future<void> _showMyDialog(String ussid) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Welcome!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    "Now Sign In!",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => ProHome(ussid)),
                      (Route<dynamic> route) => false);

                  setState(() {
                    _emailController.text = "";
                    _passwordController.text = "";
                  });
                },
              ),
            ],
          );
        });
  }

  Widget _GoogleLoginBtn(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 0.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Log in with   ',
                  style: TextStyle(fontSize: 20.0),
                ),
                Image(
                  image: AssetImage('images/google_logo.png'),
                  height: 60.0,
                  width: 40.0,
                  fit: BoxFit.contain,
                )
              ],
            ),
            splashColor: Colors.green,
            height: 45.0,
            minWidth: 45.0,
            onPressed: () {}),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Colors.white,
        elevation: 15.0,
      ),
    );
  }
}

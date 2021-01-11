import 'package:Eserve/login_register/services/auth.dart';
import 'package:Eserve/login_register/shared/loading.dart';
import 'package:flutter/material.dart';

import 'package:Eserve/onboarding/heading.dart';
import 'package:Eserve/onboarding/image_with_gradient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_pro.dart';

class RegPro extends StatefulWidget {
  @override
  _RegProState createState() => _RegProState();
}

class _RegProState extends State<RegPro> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;

  final AuthService _auth = AuthService();

  final TextEditingController _username = TextEditingController();

  final TextEditingController _phone = TextEditingController();

  final TextEditingController _address = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool loading = false;

  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
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
                          style:
                              TextStyle(fontSize: 30.0, color: Colors.white)),
                      SizedBox(height: 20.0),
                      Text(
                        'Register Now !',
                        style: TextStyle(color: Colors.white),
                      ),
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
                                  top: 10.0,
                                  bottom: 10.0,
                                  left: 30.0,
                                  right: 30.0),
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    controller: _username,
                                    validator: (val) => val.isEmpty
                                        ? 'Enter an User Name'
                                        : null,
                                    keyboardType: TextInputType.text,
                                    decoration:
                                        InputDecoration(labelText: "Username"),
                                  ),
                                  TextFormField(
                                    validator: emailValidator,
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        hintText: "you@example.com",
                                        labelText: "Email"),
                                  ),
                                  TextFormField(
                                    validator: (val) => val.isEmpty
                                        ? 'Enter an Full Address'
                                        : null,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        labelText: "Full Address"),
                                    controller: _address,
                                  ),
                                  TextFormField(
                                    validator: (val) => val.isEmpty
                                        ? 'Enter an Phone Number'
                                        : null,
                                    keyboardType: TextInputType.number,
                                    decoration:
                                        InputDecoration(labelText: "Phone"),
                                    controller: _phone,
                                  ),
                                  TextFormField(
                                    validator: pwdValidator,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        hintText: "Your password here...",
                                        labelText: "Password"),
                                    controller: _passwordController,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.0),
                                    child: RaisedButton(
                                      child: new Text(
                                        'Sign Up',
                                        style:
                                            new TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          setState(() => loading = true);
                                          dynamic result = await _auth
                                              .registerWithEmailAndPassword(
                                                  _emailController.text,
                                                  _passwordController.text,
                                                  _username.text,
                                                  _address.text,
                                                  _phone.text);
                                          if (result == null) {
                                            setState(() {
                                              loading = false;
                                              error =
                                                  'Please supply a valid email';
                                            });
                                          } else {
                                            _pushPage(context, LoginPro());
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

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Already have an account? ",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center),
                          InkWell(
                            onTap: () {
                              Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPro()),
                              );
                            },
                            child: Text("Login Now!",
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Successfully Registered!"),
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
                  _pushPage(context, LoginPro());
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
          onPressed: () {},
        ),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Colors.white,
        elevation: 15.0,
      ),
    );
  }
}

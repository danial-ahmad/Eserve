import 'package:Eserve/detail/booking.dart';
import 'package:Eserve/home/edit_profile.dart';
import 'package:Eserve/login_register/login_cust.dart';
import 'package:Eserve/login_register/modelsCust/userss.dart';

import 'package:Eserve/util/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Eserve/home/catalogue.dart';
import 'package:Eserve/util/custom_colors.dart';
import 'package:Eserve/login_register/login_pro.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  String profileId;
  String pu;
  String dn;
  String em;
  String cat;
  String loc;
  String ll;

  HomeScreen({this.profileId, this.dn, this.em, this.pu, this.loc, this.ll});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final usersRef = Firestore.instance.collection('Customerusers');

  buildProfileHeader() {
    CustomColors customColor = CustomColors();
    return FutureBuilder(
      future: usersRef.document(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        return Card(
          color: customColor.primaryColor,
          child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 120.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(user.photourl),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(60.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              blurRadius: 3.0,
                              offset: Offset(0.0, 4.0))
                        ],
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          user.username,
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          user.email,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile(
                                        currentUserId: widget.profileId)));
                          },
                          child: Container(
                            height: 25.0,
                            width: 65.0,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Center(
                                child: Text(
                              "Edit",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColor = CustomColors();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Eserve"),
          backgroundColor: customColor.primaryColor,
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute(builder: (context) => LoginCust()),
                    (_) => false,
                  );
                },
                child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  buildProfileHeader(),
                  Card(
                      elevation: 2.0,
                      margin: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Column(
                            children: <Widget>[
                              Text(
                                "Last Visit",
                                style: TextStyle(
                                    color: customColor.primaryColor,
                                    fontSize: 30.0),
                              ),
                            ],
                          )),
                          RaisedButton(
                            onPressed: () {},
                            color: customColor.primaryColor,
                            textColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.ll.substring(0, 10) +
                                    "\n" +
                                    widget.ll.substring(11, 19),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 25.0),
                              ),
                            ),
                          )
                        ],
                      )),
                  SizedBox(height: 20),
                  Text(
                    "Services Categories",
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(height: 20),
                  listcategories(),
                  SizedBox(height: 20),
                  Text(
                    "Services Available",
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(height: 20),
                  listdata(widget.profileId),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget listcategories() {
    return Container(
      width: 900,
      height: 70,
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('categories').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new CircularProgressIndicator();

              default:
                return new ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        height: 150,
                        width: 190,
                        child: Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          margin: EdgeInsets.only(
                              left: 5.0, right: 7.0, bottom: 7.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Flexible(
                                  child: Text(
                                    document['categories'],
                                    style: TextStyle(
                                      color: Colors.purple[700],
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
            }
          }),
    );
  }
}

Widget listdata(String uid) {
  return Container(
    width: 900,
    height: 220,
    child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('services').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new CircularProgressIndicator();

            default:
              return new ListView(
                scrollDirection: Axis.horizontal,
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Booking(
                                  proId: document['ownerId'],
                                  pr: document['price'],
                                  sn: document['description'],
                                  mu: document['mediaUrl'],
                                  loc: document['location'],
                                  cid: uid,
                                )),
                      );
                    },
                    child: Container(
                      height: 300,
                      width: 190,
                      child: Card(
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        margin:
                            EdgeInsets.only(left: 5.0, right: 7.0, bottom: 7.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 10.0, bottom: 2),
                              height: 150.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        document['mediaUrl']),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Text(
                                document['description'],
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              document['price'],
                              style: TextStyle(color: Colors.purple),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
          }
        }),
  );
}

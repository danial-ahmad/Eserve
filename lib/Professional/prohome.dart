import 'package:Eserve/Professional/custbook.dart';
import 'package:Eserve/Professional/uploadservice.dart';
import 'package:Eserve/Professional/googlemap.dart';
import 'package:Eserve/login_register/login_pro.dart';
import 'package:Eserve/login_register/models/user.dart';
import 'package:Eserve/util/custom_colors.dart';
import 'package:Eserve/util/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:Eserve/login_register/models/userss.dart';
import 'package:uuid/uuid.dart';

class ProHome extends StatefulWidget {
  String _usserid;

  ProHome(String usserid) {
    this._usserid = usserid;
  }

  @override
  _ProHomeState createState() => _ProHomeState();
}

class _ProHomeState extends State<ProHome> {
  List<Marker> allMarkers = [];
  String address;
  String name;
  String inputaddr = '';
  String searchloc = '';

  bool mapToggle = false;
  var lat;
  var long;

  String _name;
  String _shopname;
  String _description;
  String _speciality;

  String postId = Uuid().v4();


  buildProfileHeader() {
    
    CustomColors customColor = CustomColors();
    final usersRef = Firestore.instance.collection('Prousers');
    return FutureBuilder(
      future: usersRef.document(widget._usserid).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        Userr user = Userr.fromDocument(snapshot.data);

        address = user.address;
        name = user.username;

        return Card(
          color: customColor.primaryColor,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
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
                          user.phone,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          user.address,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 20.0),
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

  getcurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      lat = position.latitude;
      long = position.longitude;
      mapToggle = true;
    });

    allMarkers.add(Marker(
      markerId: MarkerId("Your Location"),
      draggable: false,
      position: LatLng(lat, long),
    ));
  }

  Widget loadMap() {
    return Container(
        height: 300,
        width: 500,
        child: mapToggle
            ? GoogleMap(
                markers: Set.from(allMarkers),
                mapType: MapType.normal,
                initialCameraPosition:
                    CameraPosition(target: LatLng(lat, long), zoom: 10.0),
                onMapCreated: (GoogleMapController controller) {
                  controller = controller;
                })
            : Center(
                child: Text(
                'Loading .. Please wait..',
                style: TextStyle(fontSize: 20.0),
              )));
  }

  @override
  void initState() {
    getcurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
            children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Welcome! ",
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(builder: (context) => LoginPro()),
                      (_) => false,
                    );
                  },
                  child: Text("Logout")),
            ],
          ),
          SizedBox(height: 20),
          buildProfileHeader(),
          SizedBox(height: 20),
          loadMap(),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => MapsPage()),
              )
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
              decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(13)),
              child: Center(
                child: Text(
                  "Your Location ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Add your Service! ",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => Upload(currentUser: widget._usserid)),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
              decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(13)),
              child: Center(
                child: Text(
                  "Add Service ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "View Customer Request! ",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => CustBook(pid: widget._usserid)),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
              decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(13)),
              child: Center(
                child: Text(
                  "View customer Request ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(height: 10),
        ]));
  }
}

import 'package:Eserve/util/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:call_number/call_number.dart';

class NearbyUi extends StatefulWidget {
  @override
  _NearbyUiState createState() => _NearbyUiState();
}

class _NearbyUiState extends State<NearbyUi> {
  CustomColors cc = new CustomColors();

  var callnumber = '';

  List<Marker> allMarkers = [];
  var location = "";

  bool mapToggle = false;
  var lat;
  var long;

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

  _initCall() async {
    if (callnumber != null) await new CallNumber().callNumber(callnumber);
  }

  @override
  void initState() {
    // TODO: implement initState
    getcurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Your location",
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.80,
                          child: Expanded(
                            child: Text(location,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          )),
                    ],
                  ),
                  Icon(
                    Icons.location_on,
                    size: 20.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            loadgoogleMap(),
            SizedBox(
              height: 20,
            ),
            Text("Services Nearby",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              height: 1,
            ),
            listdata(),
          ],
        ),
      ),
    );
  }

  Widget loadgoogleMap() {
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

  Future<void> _showMyDialog(String location) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Location!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    location,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget listdata() {
    return Container(
      width: 500,
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('Prousers').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');

              default:
                return new ListView(
                  shrinkWrap: true,
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          callnumber = document['phone'];
                          print(callnumber);
                          _initCall();
                        });
                      },
                      child: Card(
                        color: cc.secondaryTextColor,
                        child: Container(
                          decoration: BoxDecoration(
                              color: cc.secondaryTextColor,
                              borderRadius: BorderRadius.circular(20)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 18),
                          child: Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    document['username'],
                                    style: TextStyle(
                                        color: cc.primaryColor, fontSize: 19),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    document['address'],
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 9),
                                      decoration: BoxDecoration(
                                          color: cc.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(13)),
                                      child: Text(
                                        "Call:" + document['phone'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              SizedBox(height: 30),
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

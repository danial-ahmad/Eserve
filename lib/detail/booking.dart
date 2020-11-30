import 'package:Eserve/Professional/progress.dart';
import 'package:Eserve/detail/navigate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:Eserve/home/catalogue.dart';
import 'package:Eserve/util/custom_colors.dart';

class Booking extends StatefulWidget {
  String proId;
  String mu;
  String sn;
  String pr;
  String loc;
  String cid;

  Booking({this.proId, this.mu, this.sn, this.pr, this.loc, this.cid});
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  TextEditingController td = new TextEditingController();
  DateTime date;
  TimeOfDay time;

  String description = "";
  var lat;
  var locations;
  bool locfetch = false;

  @override
  void initState() {
    getcurrentLocation();
    super.initState();
  }

  getcurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";

    setState(() {
      locations = completeAddress;
      locfetch = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors();

    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              title: Text("Hire Professional"),
              backgroundColor: customColors.primaryColor,
            ),
            body: locfetch
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(8.0)),
                          Container(
                            height: 300,
                            width: 500,
                            child: Center(
                                child: Image(
                                    image:
                                        CachedNetworkImageProvider(widget.mu))),
                          ),
                          Text(widget.sn),
                          Text("Price:" + widget.pr),
                          SizedBox(height: 20),
                          Card(
                            semanticContainer: true,
                            color: Colors.purple[100],
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10),
                                new ListTile(
                                  leading: const Icon(Icons.speaker_notes),
                                  title: new TextField(
                                    controller: td,
                                    decoration: new InputDecoration(
                                      hintText: "Extra Notes",
                                    ),
                                  ),
                                ),
                                const Divider(
                                  height: 8.0,
                                ),
                                RaisedButton(
                                    child: Text("Hire Professional"),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MapView(
                                              proId: widget.proId,
                                              pr: widget.pr,
                                              sn: widget.sn,
                                              mu: widget.mu,
                                              dlocation: widget.loc,
                                              cid: widget.cid,
                                            ),
                                          ));
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : circularProgress()));
  }
}

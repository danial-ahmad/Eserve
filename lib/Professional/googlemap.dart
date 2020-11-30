import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController controller;

  List<Marker> allMarkers = [];
  bool mapToggle = false;
  var lat;
  var long;

  getUserLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      List<Placemark> placemarks = await Geolocator()
          .placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark placemark = placemarks[0];
      String completeAddress =
          '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
      print(completeAddress);
      setState(() {
        lat = position.latitude;
        long = position.longitude;
      });

      String formattedAddress = "${placemark.locality}, ${placemark.country}";
    } catch (e) {}
  }

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position:
          LatLng(specify['location'].latitude, specify['location'].longitude),
      infoWindow: InfoWindow(title: 'Shop', snippet: specify['address']),
    );
    setState(() {});
  }

  getMarkerData() async {
    Firestore.instance.collection('data').getDocuments().then((myMockDoc) {
      if (myMockDoc.documents.isNotEmpty) {
        for (int i = 0; i < myMockDoc.documents.length; i++) {
          initMarker(
              myMockDoc.documents[i].data, myMockDoc.documents[i].documentID);
        }
      }
    });
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

  @override
  void initState() {
    getcurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> getMarker() {
      return <Marker>[
        Marker(
            markerId: MarkerId('your position'),
            position: LatLng(lat, long),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: 'Home'))
      ].toSet();
    }

    return Scaffold(
        body: mapToggle
            ? GoogleMap(
                markers: Set.from(allMarkers),
                mapType: MapType.hybrid,
                initialCameraPosition:
                    CameraPosition(target: LatLng(lat, long), zoom: 30.0),
                onMapCreated: (GoogleMapController controller) {
                  controller = controller;
                })
            : Center(
                child: Text(
                'Loading .. Please wait..',
                style: TextStyle(fontSize: 20.0),
              )));
  }
}

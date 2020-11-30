import 'package:Eserve/home/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong/latlong.dart';

class BookingFull extends StatefulWidget {
  String pid;
  BookingFull({this.pid});

  @override
  _BookingFullState createState() => _BookingFullState();
}

class _BookingFullState extends State<BookingFull> {
  @override
  Color _color = Colors.purple[100];

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Center(child: Text("Slots Available")),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('BarberSlot').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return new ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return GestureDetector(
                        onTap: () {
                          var bpid = document['id'];
                          var adress = document['shopname'];
                          var name = document['name'];
                          var to = document['to'];
                          var from = document['from'];
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                                builder: (_) => Payment(
                                      bpid: bpid,
                                      pid: widget.pid,
                                      address: adress,
                                      name: name,
                                    )),
                          );
                        },
                        child: new Card(
                          semanticContainer: true,
                          color: _color,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Barber:" + document['name'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 10),
                              Text("Shop:" + document['shopname'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 10),
                              Text("From:" + document['from'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 10),
                              Text("To:" + document['to'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
              }
            }));
  }
}

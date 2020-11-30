import 'package:Eserve/home/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong/latlong.dart';

class BookingCustomer extends StatefulWidget {
  String pid;

  BookingCustomer({this.pid});

  @override
  _BookingCustomerState createState() => _BookingCustomerState();
}

class _BookingCustomerState extends State<BookingCustomer> {
  @override
  Color _color = Colors.purple[100];

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Center(child: Text("Your Hiring Detail")),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('Customerusers')
                .document(widget.pid)
                .collection('customerbook')
                .snapshots(),
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
                        onTap: () {},
                        child: new Card(
                          semanticContainer: true,
                          elevation: 10,
                          color: _color,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Service:" + document['service'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(height: 10),
                                Text(
                                    "Payment Method:" +
                                        document['paymentMethod'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(height: 10),
                                Text("Bill:" + document['total'].toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
              }
            }));
  }
}

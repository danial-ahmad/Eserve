import 'package:Eserve/home/bookingcust.dart';
import 'package:Eserve/home/datamainpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class Payment extends StatefulWidget {
  String pid;
  String name;
  String address;
  String bpid;
  String price;
  String sd;

  Payment({this.pid, this.address, this.name, this.bpid, this.price, this.sd});
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  List _myActivities;
  String _myActivitiesResult;
  final formKey = new GlobalKey<FormState>();

  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  String _currText = '';

  List<String> text = ["By hand", "jazzcash", "credit card"];
  @override
  void initState() {
    super.initState();
    _myActivities = [];
    _myActivitiesResult = '';
  }

  _saveForm() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        List<int> dataListAsInt =
            _myActivities.map((data) => int.parse(data)).toList();
        var res =
            dataListAsInt.fold(0, (previous, current) => previous + current);
        _myActivitiesResult = res.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Bill & Payment"),
          centerTitle: true,
          backgroundColor: Colors.purple,
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Center(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Pay to Professional:" + widget.price,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Select Payment Method",
                      style: TextStyle(fontSize: 25),
                    ),
                    CheckboxListTile(
                      title: Text(" Hand Cash"),
                      value: _isChecked1,
                      onChanged: (val) {
                        setState(() {
                          _isChecked1 = val;
                          if (val == true) {
                            _currText = "By Hand Cash";
                            _isChecked2 = false;
                            _isChecked3 = false;
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Row(
                        children: <Widget>[
                          Text("Jazz Cash or Easy Paisa"),
                          Image(width: 70, image: AssetImage('images/jazz.jpg'))
                        ],
                      ),
                      value: _isChecked2,
                      onChanged: (val) {
                        setState(() {
                          _isChecked2 = val;
                          if (val == true) {
                            _currText = "By Jazz Cash";
                            _isChecked1 = false;
                            _isChecked3 = false;
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Row(
                        children: <Widget>[
                          Text("Credit Card"),
                          Image(
                              width: 170,
                              image: AssetImage('images/creditcards.png'))
                        ],
                      ),
                      value: _isChecked3,
                      onChanged: (val) {
                        setState(() {
                          _isChecked3 = val;
                          if (val == true) {
                            _currText = "By Credit Card";
                            _isChecked2 = false;
                            _isChecked1 = false;
                          }
                        });
                      },
                    ),
                    Center(
                      child: Text(_currText,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      child: Text('Confirm'),
                      onPressed: () {
                        Firestore.instance
                            .collection('Customerusers')
                            .document(widget.pid)
                            .collection('customerbook')
                            .add({
                          'total': widget.price,
                          'paymentMethod': _currText,
                          'adress': widget.address,
                          'service': widget.sd
                        });

                        Firestore.instance
                            .collection('Prousers')
                            .document(widget.bpid)
                            .collection('customerbook')
                            .add({
                          'total': widget.price,
                          'paymentMethod': _currText,
                          'adress': widget.address,
                        });
                        _showMyDialog();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Successfully Hired!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    "Thanks!",
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
}

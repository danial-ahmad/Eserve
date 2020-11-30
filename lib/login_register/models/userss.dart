import 'package:cloud_firestore/cloud_firestore.dart';

class Userr {

final String address;
final String username;
final String email;
final String phone;

Userr({this.phone,this.address,this.email,this.username});
factory Userr.fromDocument(DocumentSnapshot doc){

return Userr(


email: doc['email'],
username: doc['username'],
phone: doc['phone'],

address: doc['address']
);
}

}

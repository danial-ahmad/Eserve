import 'package:cloud_firestore/cloud_firestore.dart';

class User {

final String id;
final String username;
final String photourl;
final String bio;
final String email;
final String displayName;

User({this.id,this.displayName,this.photourl,this.bio,this.email,this.username});
factory User.fromDocument(DocumentSnapshot doc){

return User(

id: doc['uid'],
email: doc['email'],
username: doc['username'],
photourl: doc['photourl'],
bio: doc['bio'],
displayName: doc['displayname']
);
}

}

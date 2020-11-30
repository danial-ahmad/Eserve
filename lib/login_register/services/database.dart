import 'package:Eserve/login_register/models/brew.dart';
import 'package:Eserve/login_register/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference brewCollection =
      Firestore.instance.collection('Prousers');

  Future<void> updateUserData(
      String username, String email, String address, String phone) async {
    return await brewCollection.document(uid).setData({
      'username': username,
      'address': address,
      'email': email,
      'phone': phone,
    });
  }

  // brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return Brew(
          firstname: doc.data['firstname'] ?? '',
          lastname: doc.data['lastname'] ?? 0,
          email: doc.data['email'] ?? '0');
    }).toList();
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        firstname: snapshot.data['firstname'],
        lastname: snapshot.data['lastname'],
        email: snapshot.data['email']);
  }

  // get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}

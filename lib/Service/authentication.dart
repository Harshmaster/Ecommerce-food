import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
Future<FirebaseUser> getCurrentUser() async {
  FirebaseUser user = await auth.currentUser();
  return user;
}

Future<void> sendEmailVerification() async {
  FirebaseUser user = await auth.currentUser();
  user.sendEmailVerification();
}

Future<void> signOut() async {
  return auth.signOut();
}

Future<bool> signIn(
    String email, String password, BuildContext context) async {
  try {
    AuthResult result = await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      _showDialog(context,e.toString());
      print(e.toString() +  "error");
    });

    assert(result.user != null);
    assert(result.user.getIdToken() != null);
    final FirebaseUser currentUser = result.user;
    assert(result.user.uid == currentUser.uid);
    // AnalyticsService().setUserProperties(currentUser.uid);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

// void showInSnackBar(String value) {
//   _scaffoldKey.currentState.showSnackBar(new SnackBar(
//       content: new Text(value)
//   ));
// }
Future<bool> signUp(name, email, password, mobile, context) async {
  try {
    AuthResult result = await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      _showDialog(context,e.toString());
      print(e.toString());
    });
    FirebaseUser currentuser = result.user;
    assert(currentuser != null);
    assert(await currentuser.getIdToken() != null);

    print(currentuser);
    if (currentuser != null) {
      createUsersInFirestore(
          currentuser.uid, name, currentuser.email, password, mobile, context);
    }

    // AnalyticsService().setUserProperties(currentuser.uid);
    return true;
  } catch (e) {
    print("error is " + e.toString());
    return false;
  }
}

void _showDialog(BuildContext context, error) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("OOPS! "),
        content: new Text("$error"),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

var userref = Firestore.instance.collection("users");
createUsersInFirestore(String userId, String name, String email,
    String password, String phone, BuildContext context) async {
  // DocumentSnapshot doc = await userref.document(userId).get();
  final DateTime timestamp = DateTime.now();

  if (true) {
    Firestore.instance.collection('users').document(userId).setData({
      "id": userId,
      "name": name,
      "email": email,
      "passCode": password,
      "timeStamp": timestamp,
      "allow_push": true,
      "mobile_number": phone,
      "created": timestamp,
      "cart_amount": 0,
      "cart_count": 0,
      "cart_vendor": "",
      "has_address": false,
      "Address_line_1": "",
      "Address_line_2": "",
      "Landmark": "",
      "City": "",
      "delivery_mobile": "",
    }).then((onValue) {
      print("New User Added to Database SuccessFully");
      // new FirebaseNotifications().setUpFirebase();
    });
  }

  // doc = await userref.document(userId).get();

  // currentUser = User.fromDocument(doc);
  // print(currentUser);
  // print(currentUser.name);
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kirana_app/Service/local_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;

  void setUpFirebase() {

    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessaging_Listeners();

  }

  
getid()async{

   SharedPreferences prefs =  await SharedPreferences.getInstance();
  
    return prefs.getString("userId");
  

}


  void firebaseCloudMessaging_Listeners() async{
    // 8240957387
    // kumar harsh
    // if (Platform.isIOS) iOS_Permission();

    String user = await getid();
    
    _firebaseMessaging.getToken().then((token) {
      print(token);
      print("======");
      print(user);
   Firestore.instance.collection('users').document(user).updateData({
       "token_id": token,
      }).then((onValue){
        print("Token saved");
      }).catchError((e){
        print(e);
      });
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        LocalNotificaion().showNotification(message);

      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
           LocalNotificaion().showNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
           LocalNotificaion().showNotification(message);
      },
    );
  }

  // void iOS_Permission() {
  //   _firebaseMessaging.requestNotificationPermissions(
  //       IosNotificationSettings(sound: true, badge: true, alert: true));
  //   _firebaseMessaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings settings) {
  //     print("Settings registered: $settings");
  //   });
  // }
}
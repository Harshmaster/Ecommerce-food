import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:kirana_app/Service/authentication.dart';
import 'package:kirana_app/UI/AcountUIComponent/past_orders.dart';
import 'package:kirana_app/UI/LoginOrSignup/ChoseLoginOrSignup.dart';
import 'package:kirana_app/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AboutApps.dart';
import 'CallCenter.dart';
import 'CreditCardSetting.dart';
import 'Message.dart';
import 'MyOrders.dart';
import 'Notification.dart';
import 'SettingAcount.dart';

class profil extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  profil({this.analytics, this.observer});
  @override
  _profilState createState() => _profilState();
}

/// Custom Font
var _txt = TextStyle(
  color: Colors.black,
  fontFamily: "Sans",
);

/// Get _txt and custom value of Variable for Name User
var _txtName = _txt.copyWith(fontWeight: FontWeight.w700, fontSize: 17.0);

/// Get _txt and custom value of Variable for Edit text
var _txtEdit = _txt.copyWith(color: Colors.black26, fontSize: 15.0);

/// Get _txt and custom value of Variable for Category Text
var _txtCategory = _txt.copyWith(
    fontSize: 14.5, color: Colors.black54, fontWeight: FontWeight.w500);

class _profilState extends State<profil> {
  String username,userId;

  // Future<Null> _sendAnalytics() async {
  //   await widget.analytics.logEvent(
  //       name: "Profile Screen Logged", parameters: <String, dynamic>{});
  //   print("profile Screen logged");
  // }

  @override
  void initState() {
    // TODO: implement initState
    // _sendAnalytics();
    getname();
    super.initState();
  }



  getname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("name");
         userId = prefs.getString("userId");
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Declare MediaQueryData
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    /// To Sett PhotoProfile,Name and Edit Profile
    var _profile = Padding(
      padding: EdgeInsets.only(
        top: 185.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2.5),
                  shape: BoxShape.circle,
                  // image: DecorationImage(
                  //     image: AssetImage("assets/img/womanface.jpg"))
                ),
                child: Center(
                  child: CircleAvatar(
                      radius: 50,
                      child: Text(
                        username != null
                            ? username.substring(0, 2).toUpperCase()
                            : "MM",
                        style: TextStyle(fontSize: 40),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  // AppLocalizations.of(context).tr('name'),
                  username != null ? username.toUpperCase() : "Rasoi Ghar User",
                  style: _txtName,
                ),
              ),
           
              // InkWell(
              //   onTap: null,
              //   child: Padding(
              //     padding: const EdgeInsets.only(top: 0.0),
              //     child: Text(
              //       // AppLocalizations.of(context).tr('editProfile'),
              //       "Edit Profile",
              //       style: _txtEdit,
              //     ),
              //   ),
              // ),
            ],
          ),
          Container(),
        ],
      ),
    );

    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              /// Setting Header Banner
              Container(
                height: 240.0,
                decoration: BoxDecoration(
                    // image: DecorationImage(
                    //     image: AssetImage("assets/img/headerProfile.png"),
                    //     fit: BoxFit.cover)
                    color: ColorPlatte.themecolor),
              ),

              /// Calling _profile variable
              _profile,
              Padding(
                padding: const EdgeInsets.only(top: 360.0),
                child: Column(
                  /// Setting Category List
                  children: <Widget>[
                    /// Call category class
                    category(
                      txt:
                          // AppLocalizations.of(context).tr('notification'),
                          "Notification",
                      padding: 35.0,
                      image: "assets/icon/notification.png",
                      tap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => new notification()));
                      },
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       top: 20.0, left: 85.0, right: 30.0),
                    //   child: Divider(
                    //     color: Colors.black12,
                    //     height: 2.0,
                    //   ),
                    // ),
                    // category(
                    //   txt:
                    //   // AppLocalizations.of(context).tr('payments'),
                    //   "Payments",
                    //   padding: 35.0,
                    //   image: "assets/icon/creditAcount.png",
                    //   tap: () {
                    //     Navigator.of(context).push(PageRouteBuilder(
                    //         pageBuilder: (_, __, ___) =>
                    //             new creditCardSetting()));
                    //   },
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 85.0, right: 30.0),
                      child: Divider(
                        color: Colors.black12,
                        height: 2.0,
                      ),
                    ),
                    category(
                      txt:
                          //  AppLocalizations.of(context).tr('message'),
                          "Message",
                      padding: 26.0,
                      image: "assets/icon/chat.png",
                      tap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => new chat()));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 85.0, right: 30.0),
                      child: Divider(
                        color: Colors.black12,
                        height: 2.0,
                      ),
                    ),
                    category(
                      txt:
                          //  AppLocalizations.of(context).tr('myOrders'),
                          "My Orders",
                      padding: 23.0,
                      image: "assets/icon/truck.png",
                      tap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                new PastOrderScreen()));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 85.0, right: 30.0),
                      child: Divider(
                        color: Colors.black12,
                        height: 2.0,
                      ),
                    ),
                    category(
                      txt:
                          // AppLocalizations.of(context).tr('settingAccount'),
                          "Delivery Address",
                      padding: 30.0,
                      image: "assets/icon/setting.png",
                      tap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => new settingAcount()));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 85.0, right: 30.0),
                      child: Divider(
                        color: Colors.black12,
                        height: 2.0,
                      ),
                    ),
                    category(
                      txt:
                          // AppLocalizations.of(context).tr('callCenter'),
                          "Call Center",
                      padding: 30.0,
                      image: "assets/icon/callcenter.png",
                      tap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => new callCenter()));
                      },
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       top: 20.0, left: 85.0, right: 30.0),
                    //   child: Divider(
                    //     color: Colors.black12,
                    //     height: 2.0,
                    //   ),
                    // ),
                    //     category(
                    //   txt:
                    //   // AppLocalizations.of(context).tr('language'),
                    //   "Language",
                    //   padding: 30.0,
                    //   image: "assets/icon/language.png",
                    //   tap: () {
                    //     // Navigator.of(context).push(PageRouteBuilder(
                    //     //     pageBuilder: (_, __, ___) => new languageSetting()));
                    //   },
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 85.0, right: 30.0),
                      child: Divider(
                        color: Colors.black12,
                        height: 2.0,
                      ),
                    ),
                    category(
                      padding: 38.0,
                      txt:
                          //  AppLocalizations.of(context).tr('aboutApps'),
                          "Log Out",
                      image: "assets/icon/aboutapp.png",
                      tap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool("isLogged", false);
                        Navigator.of(context).pushReplacement(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => new ChoseLogin()));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 85.0, right: 30.0),
                      child: Divider(
                        color: Colors.black12,
                        height: 2.0,
                      ),
                    ),
                    category(
                      padding: 38.0,
                      txt:
                          //  AppLocalizations.of(context).tr('aboutApps'),
                          "About Rasoi Ghar",
                      image: "assets/icon/aboutapp.png",
                      tap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => new aboutApps()));
                      },
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 20.0)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Component category class to set list
class category extends StatelessWidget {
  @override
  String txt, image;
  GestureTapCallback tap;
  double padding;

  category({this.txt, this.image, this.tap, this.padding});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 30.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: padding),
                  child: Image.asset(
                    image,
                    height: 25.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    txt,
                    style: _txtCategory,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

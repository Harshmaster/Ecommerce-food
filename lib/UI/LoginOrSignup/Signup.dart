import 'dart:async';

import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:kirana_app/Service/notification_handler.dart';
import 'package:kirana_app/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kirana_app/Service/authentication.dart';
import 'package:kirana_app/UI/BottomNavigationBar.dart';
import 'package:kirana_app/UI/LoginOrSignup/Login.dart';
import 'package:kirana_app/UI/LoginOrSignup/LoginAnimation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class Signup extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  Signup({this.analytics, this.observer});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> with TickerProviderStateMixin {
  //Animation Declaration
  AnimationController sanimationController;
  AnimationController animationControllerScreen;
  Animation animationScreen;
  var tap = 0;

  /// Set AnimationController to initState
  @override
  void initState() {
    sanimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800))
          ..addStatusListener((statuss) {
            if (statuss == AnimationStatus.dismissed) {
              setState(() {
                tap = 0;
              });
            }
          });
    // TODO: implement initState
    super.initState();
  }

  /// Dispose animationController
  @override
  void dispose() {
    sanimationController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      backgroundColor: Colors.red,
      content: new Text(value),
    ));
  }

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phonenumberController = TextEditingController();
  bool isloading = false;

  /// Playanimation set forward reverse
  Future<Null> _PlayAnimation() async {
    try {
      await sanimationController.forward();
      await sanimationController.reverse();
    } on TickerCanceled {}
  }

  /// Component Widget layout UI
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    mediaQueryData.devicePixelRatio;
    mediaQueryData.size.height;
    mediaQueryData.size.width;

    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            Container(
              /// Set Background image in layout
              // decoration: BoxDecoration(
              //     image: DecorationImage(
              //   image: AssetImage("assets/img/backgroundgirl.png"),
              //   fit: BoxFit.cover,
              // )),
              color: ColorPlatte.themecolor,
              child: Container(
                /// Set gradient color in image
                // decoration: BoxDecoration(
                //   gradient: LinearGradient(
                //     colors: [
                //       Color.fromRGBO(0, 0, 0, 0.2),
                //       Color.fromRGBO(0, 0, 0, 0.3)
                //     ],
                //     begin: FractionalOffset.topCenter,
                //     end: FractionalOffset.bottomCenter,
                //   ),
                // ),

                /// Set component layout
                child: ListView(
                  padding: EdgeInsets.all(0.0),
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          alignment: AlignmentDirectional.topCenter,
                          child: Column(
                            children: <Widget>[
                              /// padding logo
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: mediaQueryData.padding.top + 40.0)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // Image(
                                  //   image: AssetImage("assets/img/Logo.png"),
                                  //   height: 70.0,
                                  // ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0)),

                                  /// Animation text treva shop accept from login layout
                                  Hero(
                                    tag: "Treva",
                                    child: Text(
                                      // AppLocalizations.of(context).tr('title'),
                                      "Rasoi Ghar",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.6,
                                          fontFamily: "gotik",
                                          color: Colors.white,
                                          fontSize: 40.0),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 100,
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 30.0)),
                              textFromField(
                                controller: _nameController,
                                icon: Icons.person,
                                password: false,
                                email:
                                    //  AppLocalizations.of(context).tr('email'),
                                    "Name",
                                inputType: TextInputType.text,
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0)),
                              PhonetextFromField(
                                controller: _phonenumberController,
                                icon: Icons.phone,
                                password: false,
                                email:
                                    //  AppLocalizations.of(context).tr('email'),
                                    "Phone Number",
                                inputType: TextInputType.number,
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0)),

                              /// TextFromField Email
                              textFromField(
                                controller: _emailController,
                                icon: Icons.email,
                                password: false,
                                email:
                                    //  AppLocalizations.of(context).tr('email'),
                                    "Email",
                                inputType: TextInputType.emailAddress,
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0)),

                              /// TextFromField Password
                              textFromField(
                                controller: _passController,
                                icon: Icons.vpn_key,
                                password: true,
                                email:
                                    //  AppLocalizations.of(context).tr('password'),
                                    "Password",
                                inputType: TextInputType.text,
                              ),

                              /// Button Login
                              FlatButton(
                                  padding: EdgeInsets.only(top: 20.0),
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new loginScreen(analytics: widget.analytics,observer: widget.observer,)));
                                  },
                                  child: Text(
                                    // AppLocalizations.of(context).tr('notHaveLogin'),
                                    "Already have a Account??",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Sans"),
                                  )),
                              // Padding(
                              //   padding: EdgeInsets.only(
                              //       top: mediaQueryData.padding.top,
                              //       bottom: 0.0),
                              // )
                            ],
                          ),
                        ),
                      ],
                    ),

                    /// Set Animaion after user click buttonLogin
                    // tap == 0
                    //     ?
                    InkWell(
                      splashColor: Colors.yellow,
                      onTap: () {
                        // _PlayAnimation();
                        // return tap;
                      },
                      child: isloading != true
                          ? GestureDetector(
                              onTap: () {
                                print("pressed");

                                if (_phonenumberController.text.length < 10 ||
                                    _phonenumberController.text.length > 10) {
                                  print("Invalid Phone number");
                                  showInSnackBar("Invalid Phone number");
                                } else {
                                  setState(() {
                                    isloading = true;
                                  });
                                  signUp(
                                          _nameController.text,
                                          _emailController.text,
                                          _passController.text,
                                          _phonenumberController.text,
                                          context)
                                      .then((value) {
                                    print(value);

                                    if (value) {
                                      setPrefabData();
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new bottomNavigationBar(analytics: widget.analytics,observer: widget.observer,)));
                                    } else {
                                      setState(() {
                                        isloading = false;
                                      });
                                      // setState(() {
                                      //   tap = 1;
                                      // });

                                    }
                                  });
                                }
                              },
                              child: SizedBox(child: buttonBlackBottom()))
                          : SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            ),
                    )
                    // : new LoginAnimation(
                    //     animationController: sanimationController.view,
                    //   )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  setPrefabData() async {
    getCurrentUser().then((user) async {
      String userId = user.uid;
      DocumentSnapshot doc = await userref.document(userId).get();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(doc["name"]);
      prefs.setString("name", doc["name"]);
      prefs.setString("email", doc["email"]);
      prefs.setString("phone", doc["mobile_number"]).then((status) {
        if (status) {
          print("Prefab Settings Done Successfully");
          FirebaseNotifications().setUpFirebase();
        }
      });
      prefs.setString("userId", userId);
      prefs.setBool("isLogged", true);
    });
  }
}

/// textfromfield custom class
class textFromField extends StatelessWidget {
  TextEditingController controller;
  bool password;
  String email;
  IconData icon;
  TextInputType inputType;

  textFromField(
      {this.email, this.icon, this.inputType, this.password, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        height: 60.0,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 10.0, color: Colors.black12)]),
        padding:
            EdgeInsets.only(left: 20.0, right: 30.0, top: 0.0, bottom: 0.0),
        child: Theme(
          data: ThemeData(
            hintColor: Colors.transparent,
          ),
          child: TextFormField(
            controller: controller,
            obscureText: password,
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: email,
                icon: Icon(
                  icon,
                  color: Colors.black38,
                ),
                labelStyle: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Sans',
                    letterSpacing: 0.3,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600)),
            keyboardType: inputType,
          ),
        ),
      ),
    );
  }
}

class PhonetextFromField extends StatelessWidget {
  TextEditingController controller;
  bool password;
  String email;
  IconData icon;
  TextInputType inputType;

  PhonetextFromField(
      {this.email, this.icon, this.inputType, this.password, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        height: 60.0,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 10.0, color: Colors.black12)]),
        padding:
            EdgeInsets.only(left: 20.0, right: 30.0, top: 0.0, bottom: 0.0),
        child: Theme(
          data: ThemeData(
            hintColor: Colors.transparent,
          ),
          child: TextFormField(
            // maxLength: 10,

            controller: controller,
            obscureText: password,
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: email,
                icon: Icon(
                  icon,
                  color: Colors.black38,
                ),
                labelStyle: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Sans',
                    letterSpacing: 0.3,
                    color: Colors.black38,
                    fontWeight: FontWeight.w600)),
            keyboardType: inputType,
          ),
        ),
      ),
    );
  }
}

///ButtonBlack class
class buttonBlackBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Container(
        height: 55.0,
        width: 600.0,
        child: Text(
          // AppLocalizations.of(context).tr('signUp'),
          "Sign Up",
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 0.2,
              fontFamily: "Sans",
              fontSize: 18.0,
              fontWeight: FontWeight.w800),
        ),
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 15.0)],
            borderRadius: BorderRadius.circular(30.0),
            gradient: LinearGradient(
                colors: <Color>[Color(0xFF121940), Color(0xFF6E48AA)])),
      ),
    );
  }
}

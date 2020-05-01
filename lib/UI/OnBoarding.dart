import 'package:flutter/material.dart';
import 'package:kirana_app/Library/intro_views_flutter-2.4.0/lib/Models/page_view_model.dart';
import 'package:kirana_app/Library/intro_views_flutter-2.4.0/lib/intro_views_flutter.dart';
import 'package:kirana_app/UI/LoginOrSignup/ChoseLoginOrSignup.dart';
import 'package:shared_preferences/shared_preferences.dart';


class onBoarding extends StatefulWidget {
  @override
  _onBoardingState createState() => _onBoardingState();
}

var _fontHeaderStyle = TextStyle(
  fontFamily: "Popins",
  fontSize: 21.0,
  fontWeight: FontWeight.w800,
  color: Colors.black87,
  letterSpacing: 1.5
);

var _fontDescriptionStyle = TextStyle(
  fontFamily: "Sans",
  fontSize: 15.0,
  color: Colors.black26,
  fontWeight: FontWeight.w400
);

///
/// Page View Model for on boarding
///
final pages = [
  new PageViewModel(
      pageColor:  Colors.white,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'Online Grocery App',style: _fontHeaderStyle,
      ),
      body: Container(
        height: 250.0,
        child: Text(
          'Best Online Grocery App in Chhatarpur',textAlign: TextAlign.center,
          style: _fontDescriptionStyle
        ),
      ),
      mainImage: Image.asset(
        'assets/imgIllustration/IlustrasiOnBoarding1.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),

  new PageViewModel(
      pageColor:  Colors.white,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'Choose Item',style: _fontHeaderStyle,
      ),
      body: Container(
        height: 250.0,
        child: Text(
            'Choose from variety of products and get it delivered at your doorStep',textAlign: TextAlign.center,
            style: _fontDescriptionStyle
        ),
      ),
      mainImage: Image.asset(
        'assets/imgIllustration/IlustrasiOnBoarding2.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),

  new PageViewModel(
      pageColor:  Colors.white,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'Buy Item',style: _fontHeaderStyle,
      ),
      body: Container(
        height: 250.0,
        child: Text(
            'We are commited to provide high quality and upto date products at reasonable price',textAlign: TextAlign.center,
            style: _fontDescriptionStyle
        ),
      ),
      mainImage: Image.asset(
        'assets/imgIllustration/IlustrasiOnBoarding3.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),

];

class _onBoardingState extends State<onBoarding> {
  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      pages,
      pageButtonsColor: Colors.black45,
      skipText: Text("SKIP",style: _fontDescriptionStyle.copyWith(color: Colors.deepPurpleAccent,fontWeight: FontWeight.w800,letterSpacing: 1.0),),
      doneText: Text("DONE",style: _fontDescriptionStyle.copyWith(color: Colors.deepPurpleAccent,fontWeight: FontWeight.w800,letterSpacing: 1.0),),
      onTapDoneButton: ()async {

     SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
       prefs.setString("username", "Login");
        Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> new ChoseLogin(),
        transitionsBuilder: (_,Animation<double> animation,__,Widget widget){
          return Opacity(
            opacity: animation.value,
            child: widget,
          );
        },
        transitionDuration: Duration(milliseconds: 1500),
        ));
      },
    );
  }
}


import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:kirana_app/UI/AcountUIComponent/Profile.dart';
import 'package:kirana_app/UI/BrandUIComponent/BrandLayout.dart';
import 'package:kirana_app/UI/CartUIComponent/CartLayout.dart';
import 'package:kirana_app/UI/HomeUIComponent/Home.dart';
import 'package:kirana_app/colors.dart';
 


class bottomNavigationBar extends StatefulWidget {

     final FirebaseAnalytics analytics;
final FirebaseAnalyticsObserver observer;

bottomNavigationBar({this.analytics,this.observer});

 @override
 _bottomNavigationBarState createState() => _bottomNavigationBarState();
}

class _bottomNavigationBarState extends State<bottomNavigationBar> {
 int currentIndex = 0;
 /// Set a type current number a layout class
 Widget callPage(int current) {
  switch (current) {
   case 0:
    return new Menu(analytics: widget.analytics,observer: widget.observer,);
   case 1:
    return new brand(analytics: widget.analytics,observer: widget.observer,);
   case 2:
    return new cart(analytics: widget.analytics,observer: widget.observer,);
   case 3:
    return new profil(analytics: widget.analytics,observer: widget.observer,);
  //  case 3:
  //   return new Container();
    break;
   default:
    return Menu();
  }
 }

 /// Build BottomNavigationBar Widget
 @override
 Widget build(BuildContext context) {
        var data = EasyLocalizationProvider.of(context).data;
  return EasyLocalizationProvider(
          data: data,
      child: Scaffold(
     body: callPage(currentIndex),
     bottomNavigationBar: Theme(
         data: Theme.of(context).copyWith(
             canvasColor: Colors.white,
             textTheme: Theme.of(context).textTheme.copyWith(
                 caption: TextStyle(color: Colors.black26.withOpacity(0.15)))),
         child: BottomNavigationBar(
            
           backgroundColor: ColorPlatte.themecolor,
          unselectedItemColor: Colors.white, 
          selectedItemColor: Colors.amberAccent,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          // fixedColor: Color(0xFF6991C7),
          onTap: (value) {
           currentIndex = value;
           setState(() {});
          },
          items: [
           BottomNavigationBarItem(
               icon: Icon(
                Icons.home,
                size: 23.0,
               ),
               title: Text(
                // AppLocalizations.of(context).tr('home'),
                "Home",
                style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
               )),
           BottomNavigationBarItem(
               icon: Icon(Icons.shop),
               title: Text(
                //  AppLocalizations.of(context).tr('brand'),
                "Brands",
                style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
               )),
           BottomNavigationBarItem(
               icon: Icon(Icons.shopping_cart),
               title: Text(
                 "Cart",
                // AppLocalizations.of(context).tr('cart'),
                style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
               )),
           BottomNavigationBarItem(
               icon: Icon(
                Icons.person,
                size: 24.0,
               ),
               title: Text(
                //  AppLocalizations.of(context).tr('account'),
                "Account",
                style: TextStyle(fontFamily: "Berlin", letterSpacing: 0.5),
               )),
          ],
         )),
    ),
  );
 }
}


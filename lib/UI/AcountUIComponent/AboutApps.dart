import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class aboutApps extends StatefulWidget {
  @override
  _aboutAppsState createState() => _aboutAppsState();
}

class _aboutAppsState extends State<aboutApps> {
  @override

  static var _txtCustomHead = TextStyle(
    color: Colors.black54,
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    fontFamily: "Gotik",
  );

  static var _txtCustomSub = TextStyle(
    color: Colors.black38,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: "Gotik",
  );
String userId;
getid()async{

   SharedPreferences prefs =  await SharedPreferences.getInstance();
   setState(() {
     userId = prefs.getString("userId");
   });

}

@override
void initState() { 
  super.initState();
  getid();
}

  Widget build(BuildContext context) {
        var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
          data: data,
          child: Scaffold(
        appBar: AppBar(
          title: Text(
            // AppLocalizations.of(context).tr('aboutApps'),
            "About Rasoi Ghar",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15.0,
                color: Colors.black54,
                fontFamily: "Gotik"),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFF6991C7)),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Divider(
                    height: 0.5,
                    color: Colors.black12,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 15.0,right: 15.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.shopping_cart,color: Colors.redAccent,size: 40,),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              // AppLocalizations.of(context).tr('title'),
                              "Rasoi Ghar",
                              style: _txtCustomSub.copyWith(
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              // AppLocalizations.of(context).tr('uiKit'),
                              "Grocery App",
                              style: _txtCustomSub,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Divider(
                    height: 0.5,
                    color: Colors.black12,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Rasoi Ghar is an online supermarket where customers can purchase - Grocery, household items, personal care products and anything needed in a household on day to day basis. Unbeatable prices and discounts with fast and timely home delivery in chhatarpur mp. Your Grocery is now just a click away. With Rasoi Ghar app you can buy all your household needs including - Grocery, beverages, oils, cleaning products, household items, personal care products - with a touch of your fingertips. why stand in line when you can get online.",
                    style: _txtCustomSub,
                    textAlign: TextAlign.justify,
                  ),
                ),
                       Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  // AppLocalizations.of(context).tr('name'),
                  userId != null ? "User Id: "+userId : "Rasoi Ghar User",
                  style: TextStyle(
                    fontSize: 10
                  ),
                ),
              ),
                           Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  // AppLocalizations.of(context).tr('name'),
                  "Version 2.2",
                  style: TextStyle(
                    fontSize: 10
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

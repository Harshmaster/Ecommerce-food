import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:kirana_app/UI/CartUIComponent/Payment.dart';
import 'package:kirana_app/UI/CartUIComponent/confirm_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class delivery extends StatefulWidget {
  @override
  _deliveryState createState() => _deliveryState();
}

class _deliveryState extends State<delivery> {
String userId;
  getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");
    });
   check_address();
  }

TextEditingController _add1Controller = TextEditingController();
TextEditingController _add2Controller = TextEditingController();
TextEditingController _landmarkController = TextEditingController();
TextEditingController _cityController = TextEditingController();
TextEditingController _mobileNumberController = TextEditingController();

check_address()async{
DocumentSnapshot doc = await Firestore.instance.collection("users").document(userId).get();
bool check = doc["has_address"];
print(check);
if(check){
_add1Controller.text = doc["Address_line_1"];
_add1Controller.text +=", "+ doc["Address_line_2"];
_landmarkController.text = doc["Landmark"];
_cityController.text = doc["City"];
_mobileNumberController.text = doc["delivery_mobile"];
}else{
  print("NO Adress found");
}


}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      backgroundColor: Colors.green,
      content: new Text(value),
      
      
      ));

}
@override
  void initState() {
    // TODO: implement initState
    getid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
          data: data,
          child: Scaffold(
            key: _scaffoldKey,
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop(false);
              },
              child: Icon(Icons.arrow_back)),
          elevation: 0.0,
          title: Text(
            // AppLocalizations.of(context).tr('deliveryAppBar'),
            "Delivery",


            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                color: Colors.black54,
                fontFamily: "Gotik"),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Color(0xFF6991C7)),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  Text(
                   "Delivery Address",
                    style: TextStyle(
                        letterSpacing: 0.1,
                        fontWeight: FontWeight.w600,
                        fontSize: 25.0,
                        color: Colors.black54,
                        fontFamily: "Gotik"),
                  ),
                  Padding(padding: EdgeInsets.only(top: 50.0)),
                  TextFormField(
                    controller:_add1Controller,
                    decoration: InputDecoration(
                        labelText: "Address",
                        hintText:"Address",
                        hintStyle: TextStyle(color: Colors.black54)),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  TextFormField(
                    controller: _landmarkController,
                    decoration: InputDecoration(
                        labelText:"Landmark",
                        hintText: "Landmark",
                        hintStyle: TextStyle(color: Colors.black54)),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                        labelText: "City",
                        hintText: "City",
                        hintStyle: TextStyle(color: Colors.black54)),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _mobileNumberController,
                    maxLength: 10,
                    decoration: InputDecoration(

                        labelText: "Mobile Number",
                        hintText: "Mobile Number",
                        hintStyle: TextStyle(color: Colors.black54)),
                  ),
                  Padding(padding: EdgeInsets.only(top: 80.0)),
                  InkWell(
                    onTap: () {
                      if(_add1Controller.text =="" || _cityController.text =="" || _mobileNumberController.text =="" || _landmarkController.text ==""){
   print("fill all details first");
   showInSnackBar("Kindly fill all details first");
                  }else{
                                       Navigator.of(context).pushReplacement(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => ConfirmScreen(address: _add1Controller.text,city: _cityController.text,landmark: _landmarkController.text,mobile: _mobileNumberController.text,)));
                  }
                  
                  
                  },
                    child: Container(
                      height: 55.0,
                      width: 300.0,
                      decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.all(Radius.circular(40.0))),
                      child: Center(
                        child: Text(
                          // AppLocalizations.of(context).tr('goPayment'),
                          "Go to Payment",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.5,
                              letterSpacing: 1.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

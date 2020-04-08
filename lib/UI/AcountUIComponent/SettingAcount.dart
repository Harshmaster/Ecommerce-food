import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class settingAcount extends StatefulWidget {
  @override
  _settingAcountState createState() => _settingAcountState();
}

class _settingAcountState extends State<settingAcount> {
TextEditingController _add1Controller = TextEditingController();
TextEditingController _add2Controller = TextEditingController();
TextEditingController _landmarkController = TextEditingController();
TextEditingController _cityController = TextEditingController();
TextEditingController _mobileNumberController = TextEditingController();
String userId;

@override
void initState() { 
  super.initState();
  getid();
}


getid()async{

   SharedPreferences prefs =  await SharedPreferences.getInstance();
   setState(() {
     userId = prefs.getString("userId");
   });
check_address();
}

check_address()async{
DocumentSnapshot doc = await Firestore.instance.collection("users").document(userId).get();
bool check = doc["has_address"];
print(check);
if(check){
_add1Controller.text = doc["Address_line_1"];
_add2Controller.text = doc["Address_line_2"];
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

  static var _txtCustomHead = TextStyle(
    color: Colors.white,
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

  @override
  Widget build(BuildContext context) {
        var data = EasyLocalizationProvider.of(context).data;
    
    return EasyLocalizationProvider(
          data: data,
          child: Scaffold(
          key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            // AppLocalizations.of(context).tr('settingAccount'),
            "Delivery Address",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                color: Colors.black54,
                fontFamily: "Gotik"),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFF6991C7)),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 100,
            child: Column(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // setting(
                //   head: "account",
                //   sub1: "address",
                //   sub2:  "telephone",
                //   sub3: "email",
                // ),
                // setting(
                //   head:  "setting",
                //   sub1:  "orderNotification",
                //   sub2:  "discountNotification",
                //   sub3:  "creditCard",
                // ),
                Padding(padding: EdgeInsets.only(left: 20,right: 30),
                child: Column(
                  children: <Widget>[
TextField(
  
  controller: _add1Controller,
  decoration: InputDecoration(
   hintText: "Address Line 1",
   border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
      color: Colors.amber,
      style: BorderStyle.solid,
    ),
  ),

  ),
),
SizedBox(height: 20,),
TextField(
  controller: _add2Controller,
  decoration: InputDecoration(
   hintText: "Address Line 2",
      border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
      color: Colors.amber,
      style: BorderStyle.solid,
    ),
  ),
  ),
),
SizedBox(height: 20,),
TextField(
  controller: _landmarkController,
  decoration: InputDecoration(
   hintText: "Landmark",
     border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
      color: Colors.amber,
      style: BorderStyle.solid,
    ),
  ), 
  ),
),
SizedBox(height: 20,),
TextField(
  controller: _cityController,
  decoration: InputDecoration(
   hintText: "City",
     border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
      color: Colors.amber,
      style: BorderStyle.solid,
    ),
  ), 
  ),
),
SizedBox(height: 20,),
TextField(
  controller: _mobileNumberController,
  keyboardType: TextInputType.number,
  maxLength: 10,
  decoration: InputDecoration(
    enabled: true,
   hintText: "Mobile Number",
      border: OutlineInputBorder(

    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
     
      style: BorderStyle.solid,
    ),
  ),
   
  ),
),
SizedBox(height: 20,),
                  ],
                ),),
               
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: GestureDetector(
                    onTap: (){
                      print("tapped");
                      print(userId);
Firestore.instance.collection("users").document(userId).updateData({
  "Address_line_1": _add1Controller.text,
  "Address_line_2": _add2Controller.text,
  "Landmark": _landmarkController.text,
  "City":_cityController.text,
  "delivery_mobile": _mobileNumberController.text,
  "has_address":true
}).then((onvalue){
print("Delivery data sent successfully");
showInSnackBar("Address Saved Successfully");
})


.catchError((onError){
  print(onError.toString());
});
                    },
                                      child: Container(
                      height: 50.0,
                      width: 1000.0,
                      color: Colors.redAccent,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 13.0, left: 20.0, bottom: 15.0),
                        child: Text(
                          // AppLocalizations.of(context).tr('logout'),
                          "Save",textAlign: TextAlign.center,
                          style: _txtCustomHead,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class setting extends StatelessWidget {
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

  String head, sub1, sub2, sub3;

  setting({this.head, this.sub1, this.sub2, this.sub3});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Container(
        height: 235.0,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
                child: Text(
                  head,
                  style: _txtCustomHead,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
                  color: Colors.black12,
                  height: 0.5,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        sub1,
                        style: _txtCustomSub,
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black38,
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
                  color: Colors.black12,
                  height: 0.5,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        sub2,
                        style: _txtCustomSub,
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black38,
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
                  color: Colors.black12,
                  height: 0.5,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        sub3,
                        style: _txtCustomSub,
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black38,
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
                  color: Colors.black12,
                  height: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

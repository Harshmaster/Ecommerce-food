import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class FacultyContactPage extends StatefulWidget {
  FacultyContactPage({Key key}) : super(key: key);

  @override
  _FacultyContactPageState createState() => _FacultyContactPageState();
}

class _FacultyContactPageState extends State<FacultyContactPage> {


  // String storename;

  //   getpref() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();

  //   String value = pref.getString("storename");
  //   print(value);
  //   setState(() {
  //     storename = value;
  //   });
  // }


  List<FacultyInfo> parseJosn(String response) {
    if (response == null) {
      return [];
    }
    final parsed =
        json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed
        .map<FacultyInfo>((json) => new FacultyInfo.fromJson(json))
        .toList();
  }

  List<FacultyInfo> facultyList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("All Item Codes"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                //  Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => FacultySearchPage(facultyList: facultyList,)
                //               ));
              },
            ),
          )
        ],
      ),
      // drawer: ManagerDrawer(storename: storename,),
      body: SingleChildScrollView(
        // controller: controller,
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          child: FutureBuilder(
              future:
                  DefaultAssetBundle.of(context).loadString('assets/rate.json'),
              builder: (context, snapshot) {
                facultyList = parseJosn(snapshot.data.toString());

                return facultyList.isNotEmpty
                    ? Container(
                        child: new ListView.builder(
                            itemCount:
                                facultyList == null ? 0 : facultyList.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (facultyList[index] == null) {
                                return CircularProgressIndicator();
                              }
                             if( facultyList[index].available =="available" && facultyList[index].category == "Beverages"){
    // var product_id = Uuid().v4();
                              Firestore.instance
                                  .collection("essential_products")
                                  .document(facultyList[index].id.toString())
                                  .setData({
                                "product_name": facultyList[index].name,
                                "product_price": facultyList[index].price.toString(),
                                "product_size": facultyList[index].size,
                                "product_id": facultyList[index].id.toString(),
                                "product_image_url":
                                    facultyList[index].product_image_url,
                                "product_category": facultyList[index].category,
                                "product_vendor": facultyList[index].vendor,
                                "isRecommended": true,
                                "max_qty": 2,
                                "product_brand": facultyList[index].brandname
                              }).then((onValue) {
                                print("done  cleaning" + facultyList[index].id.toString());
                                 
                              });
                             }
                             else{
                               print(index.toString() + "not available");
                             }
                          

                              return ListTile(
                                  title: Text(facultyList[index].name),
                                  trailing: Text(index.toString()),);
                              // return buildFacultyCard(facultyList[index].name,facultyList[index].email,facultyList[index].phoneno.toString(),facultyList[index].profileImageUrl,facultyList[index].designation,facultyList[index].department);

                              // ListTile(
                              //   title: Text(facultyList[index].name),
                              // );
                            }),
                      )
                    : Container();
                // : new Center(child: new CircularProgressIndicator());
              }),
        ),
      ),
    );
  }
}

class FacultyInfo {
  final String name;
  final int id;
  final int price;
  final String size;
  final String category;
  final String vendor;
  final String product_image_url;
  final String brandname;
  final String available;
  // final String profileImageUrl;

  FacultyInfo(
      {this.name,
      this.id,
      this.price,
      this.size,
      this.category,
      this.vendor,
      this.product_image_url,this.brandname,this.available});

  factory FacultyInfo.fromJson(Map<String, dynamic> json) {
    return new FacultyInfo(
        name: json['product_name'] as String,
        id: json["product_id"] as int,
        price: json['product_price'] as int,
        size: json['product_size'] as String,
        category: json['Category'] as String,
        vendor: json['Vendor'] as String,
        brandname: json["Brand"] as String,
        available: json["status"] as String,
        // vendor: "Quality Store",
        product_image_url: json["product_image_url"] as String);
  }
}

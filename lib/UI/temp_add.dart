import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

TextEditingController _name =  TextEditingController();
TextEditingController _price =  TextEditingController();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  title: Text("Add Products"),
),
body: Column(
  children: <Widget>[
    Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        controller: _name,
        decoration: InputDecoration(
          hintText: "Name"
        ),
      ),
    ),

     Padding(
       padding: const EdgeInsets.all(15.0),
       child: TextField(
        controller: _price,
          decoration: InputDecoration(
          hintText: "Price"
        ),
    ),
     ),

    RaisedButton(onPressed: (){
String product_id = Uuid().v4();
Firestore.instance.collection("product").document(product_id).setData({
"product_name": "Everest Chole Masala",
"product_price": "60",
"product_image_url": "https://www.bigbasket.com/media/uploads/p/l/268078_2-everest-chhole-masala.jpg",
"isRecommended": true,
"product_id": product_id,
"vendor_id": "vishal_1",
"category": "Spices"

}).then((onValue){

  print("Product Added");
}).catchError((onError){
  print(onError.toString());
  });

    },child: Text("Add Product"),)
  ],
),
    );
  }
}
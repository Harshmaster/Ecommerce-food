import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:kirana_app/UI/BottomNavigationBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ConfirmScreen extends StatefulWidget {
  final String address, landmark, city, mobile;
  ConfirmScreen(
      {@required this.address, this.city, this.landmark, this.mobile});
  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  /// Duration for popup card if user succes to payment
  StartTime() async {
    return Timer(Duration(milliseconds: 4000), navigator);
  }
TextEditingController _comment = TextEditingController();
  int charges;

  /// Navigation to route after user succes payment
  void navigator() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => new bottomNavigationBar()));
  }

  @override
  void initState() {
    super.initState();
    getid();
  }

  void order() async {
    // var order_id = Uuid().v4();

    var rng = new Random();
    var order_id = rng.nextInt(9000000) + 1000000;
    var docs = await Firestore.instance
        .collection("users")
        .document(userId)
        .collection("cart")
        .getDocuments();
    var doc =
        await Firestore.instance.collection("users").document(userId).get();
    int cart_value = doc["cart_amount"];
    String cart_vendor = doc["cart_vendor"];
    int cart_count = doc["cart_count"];
    String user_name = doc["name"];
    String address = doc["Address_line_1"] +
        ", " +
        doc["Address_line_2"] +
        " \n" +
        doc["Landmark"];
    print(user_name);
    print(address);

// String cart_count = doc["cart_count"];

    await Firestore.instance
        .collection("orders")
        .document(order_id.toString())
        .setData({
      "order_id": order_id.toString(),
      "user_id": userId,
      "timestamp": DateTime.now(),
      "order_vendor": cart_vendor,
      // "order_count": cart_count,
      "order_amount": cart_value,
      "order_count": cart_count,
      "user_name": user_name,
      "address": address,
      "status": "Ordered",
      "order_vendor": cart_vendor,
      "mode_of_payment": "Cash",
      "address": widget.address.toString(),
      "landmark": widget.landmark.toString(),
      "city": widget.city.toString(),
      "mobile": widget.mobile.toString(),
"comment": _comment.text
    }).then((onValue) {
      print("done_basic_order");
    });
    docs.documents.forEach((doc) {
      Firestore.instance
          .collection("orders")
          .document(order_id.toString())
          .collection("items")
          .add({
        "order_id": order_id.toString(),
        "user_id": userId,
        "user_name": user_name,
        "product_name": doc["product_name"],
        "product_image_url": doc["product_image_url"],
        "product_qty": doc["product_qty"],
        "product_price": doc["product_price"],
        "vendor_name": doc["vendor_name"],
      }).then((onValue) {
        print("done one item");
      });

      Firestore.instance
          .collection("users")
          .document(userId)
          .collection("cart")
          .document(doc.documentID)
          .delete()
          .then((onValue) {
        print("one cart document deleted");
      });
    });

    Firestore.instance
        .collection("users")
        .document(userId)
        .updateData({"cart_amount": 0, "cart_count": 0});

    Firestore.instance
        .collection("users")
        .document(userId)
        .collection("notification")
        .add({
      "title": "You order is placed",
      "desc":
          "$cart_count items ordered of total $cart_value ₹ from $cart_vendor"
    });
  }

  String userId;
  int total_amount;
  getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");
    });
    var doc =
        await Firestore.instance.collection("users").document(userId).get();
    total_amount = doc["cart_amount"];
    var extraAmount;
    if (total_amount < 300) {
      extraAmount = 50;
    } else if (total_amount < 800) {
      extraAmount = 40;
    } else if (total_amount < 1200) {
      extraAmount = 30;
    } else {
      extraAmount = 0;
    }
    setState(() {
      charges =extraAmount;
      total_pay = total_amount + extraAmount;
    });
  }

  int total_pay;
  @override

  /// For radio button
  // int tapvalue = 0;
  // int tapvalue2 = 0;
  // int tapvalue3 = 0;
  // int tapvalue4 = 0;

  /// Custom Text
  var _customStyle = TextStyle(
      fontFamily: "Gotik",
      fontWeight: FontWeight.w800,
      color: Colors.black,
      fontSize: 17.0);

  Widget build(BuildContext context) {
    // int total_amount = charges + widget.amt;
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        /// Appbar
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.of(context).pop(false);
              },
              child: Icon(Icons.arrow_back)),
          elevation: 0.0,
          title: Text(
            // AppLocalizations.of(context).tr('payment'),
            "Order Confirmation",
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
              padding:
                  const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  // Text(
                  //   // AppLocalizations.of(context).tr('chosePaymnet'),
                  //   "Choose payments",
                  //   style: TextStyle(
                  //       letterSpacing: 0.1,
                  //       fontWeight: FontWeight.w600,
                  //       fontSize: 22.0,
                  //       color: Colors.black54,
                  //       fontFamily: "Gotik"),
                  // ),
                  // Padding(padding: EdgeInsets.only(top: 20.0)),

                  /// For RadioButton if selected or not selected
                  // InkWell(
                  //   onTap: () {
                  //     setState(() {
                  //       if (tapvalue == 0) {
                  //         tapvalue++;
                  //       } else {
                  //         tapvalue--;
                  //       }
                  //     });
                  //   },
                  //   child: Row(
                  //     children: <Widget>[
                  //       Radio(
                  //         value: 1,
                  //         groupValue: tapvalue,
                  //         onChanged: null,
                  //       ),
                  //       Text(
                  //         // AppLocalizations.of(context).tr('credit'),
                  //         "credit",
                  //         style: _customStyle,
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 40.0),
                  //         child: Image.asset(
                  //           "assets/img/credit.png",
                  //           height: 25.0,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // Padding(padding: EdgeInsets.only(top: 15.0)),
                  // Divider(
                  //   height: 1.0,
                  //   color: Colors.black26,
                  // ),
                  Padding(padding: EdgeInsets.only(top: 15.0)),
                  // InkWell(
                  //   onTap: () {
                  //     // setState(() {
                  //     //   if (tapvalue2 == 0) {
                  //     //     tapvalue2++;
                  //     //   } else {
                  //     //     tapvalue2--;
                  //     //   }
                  //     // });
                  //   },
                  //   child: Row(
                  //     children: <Widget>[
                  //       Radio(
                  //         value: 1,
                  //         groupValue: 1,
                  //         onChanged: null,
                  //       ),
                  //       Text(

                  //           // AppLocalizations.of(context).tr('cashOn'),
                  //           "Cash on Delivery",
                  //           style: _customStyle),
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 50.0),
                  //         child: Image.asset(
                  //           "assets/img/handshake.png",
                  //           height: 25.0,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  
                  // Padding(padding: EdgeInsets.only(top: 15.0)),
                  // Divider(
                  //   height: 1.0,
                  //   color: Colors.black26,
                  // ),
                  // Padding(padding: EdgeInsets.only(top: 15.0)),
                  // InkWell(
                  //   onTap: () {
                  //     setState(() {
                  //       if (tapvalue3 == 0) {
                  //         tapvalue3++;
                  //       } else {
                  //         tapvalue3--;
                  //       }
                  //     });
                  //   },
                  //   child: Row(
                  //     children: <Widget>[
                  //       Radio(
                  //         value: 1,
                  //         groupValue: tapvalue3,
                  //         onChanged: null,
                  //       ),
                  //       Text(
                  //         // AppLocalizations.of(context).tr('paypal'),
                  //         "paypal",

                  //         style: _customStyle),
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 130.0),
                  //         child: Image.asset(
                  //           "assets/img/paypal.png",
                  //           height: 25.0,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Padding(padding: EdgeInsets.only(top: 15.0)),

                  Card(
                    elevation: 0,
                                      child: Container(
                      decoration: BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(width: 1, color: Colors.black)),
                                  borderRadius: BorderRadius.circular(10)
                      ),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Order Amount:",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  total_amount == null
                                      ? ""
                                      : total_amount.toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Delivery Charges ",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "+ " + charges.toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 0.5,
                            indent: 20,
                            endIndent: 20,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Total Amount:",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  total_pay.toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextField(
                      controller: _comment,
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Write some comment....",
                        helperText: "Any request or remark for your order.."

                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("All the deliveries will be subjected to availability of stock due to Corona Crisis",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600),),
                             SizedBox(height: 10,),
                              Text("You can pay through Paytm/Google Pay/Cash to our Delivery Executive",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600),),
                                  SizedBox(height: 10,),
                              Text("In case of unavailability of any product, other similar quality product may be delivered",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600),),
             SizedBox(height: 10,),
                              Text("Your order will be delivered within 24 hrs",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600),),
    SizedBox(height: 10,),
                              Text("Order above 1200 is free of delivery cost",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600),),

                      ],
                    ),
                  ),
                  // Padding(padding: EdgeInsets.only(top: 15.0)),
                  // InkWell(
                  //   onTap: () {
                  //     setState(() {
                  //       if (tapvalue4 == 0) {
                  //         tapvalue4++;
                  //       } else {
                  //         tapvalue4--;
                  //       }
                  //     });
                  //   },
                  //   child: Row(
                  //     children: <Widget>[
                  //       Radio(
                  //         value: 1,
                  //         groupValue: tapvalue4,
                  //         onChanged: null,
                  //       ),
                  //       Text(
                  //         // AppLocalizations.of(context).tr('googleWallet'),
                  //         "google wallet",

                  //        style: _customStyle),
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 65.0),
                  //         child: Image.asset(
                  //           "assets/img/googlewallet.png",
                  //           height: 25.0,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Padding(padding: EdgeInsets.only(top: 60.0)),

                  /// Button pay
                  InkWell(
                    onTap: () {
                      order();
                      _showDialog(context);
                      StartTime();
                    },
                    child: Container(
                      height: 55.0,
                      width: 300.0,
                      decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius:
                              BorderRadius.all(Radius.circular(40.0))),
                      child: Center(
                        child: Text(
                          // AppLocalizations.of(context).tr('pay'),
                          "Place Order",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.5,
                              letterSpacing: 2.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom Text Header for Dialog after user succes payment
var _txtCustomHead = TextStyle(
  color: Colors.black54,
  fontSize: 23.0,
  fontWeight: FontWeight.w600,
  fontFamily: "Gotik",
);

/// Custom Text Description for Dialog after user succes payment
var _txtCustomSub = TextStyle(
  color: Colors.black38,
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
  fontFamily: "Gotik",
);

/// Card Popup if success payment
_showDialog(BuildContext ctx) {
  showDialog(
    context: ctx,
    barrierDismissible: true,
    child: SimpleDialog(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 30.0, right: 60.0, left: 60.0),
          color: Colors.white,
          child: Image.asset(
            "assets/img/checklist.png",
            height: 110.0,
            color: Colors.lightGreen,
          ),
        ),
        Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            // AppLocalizations.of(ctx).tr('yuppy'),
            "Done!",
            style: _txtCustomHead,
          ),
        )),
        Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 40.0),
          child: Text(
            // AppLocalizations.of(ctx).tr('paymentReceive'),
            "Order Placed",
            style: _txtCustomSub,
          ),
        )),
      ],
    ),
  );
}

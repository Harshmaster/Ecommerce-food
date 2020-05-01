import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kirana_app/ListItem/CartItemData.dart';
import 'package:kirana_app/UI/CartUIComponent/Delivery.dart';
import 'package:kirana_app/UI/CartUIComponent/confirm_screen.dart';
import 'package:kirana_app/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class cart extends StatefulWidget {
       final FirebaseAnalytics analytics;
final FirebaseAnalyticsObserver observer;

cart({this.analytics,this.observer});
  @override
  _cartState createState() => _cartState();
}

class _cartState extends State<cart> {
  String userId;

// Future<Null> _sendAnalytics() async{
// await widget.analytics.logEvent(name: "Cart Screen Logged",
// parameters: <String,dynamic>{}
// );
// print("Cart Screen logged");
// }



  getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");
    });

    getCartStats();
    // gettotal(15);
  }

  // final  List<cartItem> items = new List();

  @override
  void initState() {
    super.initState();
    getid();
    // _sendAnalytics();
  }

  int cart_count, cart_amount;
  getCartStats() async {
    var doc =
        await Firestore.instance.collection("users").document(userId).get();
    setState(() {
      cart_count = doc["cart_count"];
      cart_amount = doc["cart_amount"];
    });
  }

  /// Declare price and value for chart
  int value = 1;
  int pay = 0;
  int count;

//   gettotal(int mn)async{
//     print(mn);
//     if(mn == 15){
//       print("correct");
//       DocumentSnapshot doc = await Firestore.instance.collection("users").document(userId).get();
// int amt = doc["cart_amount"];
// int count = doc["cart_count"];
// setState(() {
//   pay = amt;
//   count = count;
// });
// print("total amount is" + pay.toString());

//     }else{
//       print("not");
//     }

//   }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      backgroundColor: Colors.green,
      content: new Text(value),
    ));
  }

  @override
  Widget build(BuildContext context) {

  var pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false);

// show(){
//   // pr.show();
//   print("show");
// }

    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
          key: _scaffoldKey,
          floatingActionButton: FloatingActionButton(
            tooltip: "press to buy",
            onPressed: () {
              print("$cart_count in cart");
              if (cart_count > 0 && cart_amount>0) {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => new delivery()));
              } else {
                print("No items in cart");
                showInSnackBar("No items in Cart");
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Icon(Icons.shopping_cart),
                Text("Buy")
              ],
            ),
          ),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Color(0xFF6991C7)),
            centerTitle: true,
            // backgroundColor: Colors.white,
            backgroundColor: ColorPlatte.themecolor,
            title: Text(
              //  AppLocalizations.of(context).tr('cart'),
              "Cart",
              style: TextStyle(
                  fontFamily: "Gotik",
                  fontSize: 18.0,
                  // color: Colors.black54,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
            elevation: 0.0,
          ),

          ///
          ///
          /// Checking item value of cart
          ///
          ///
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height *0.8,
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height *0.8,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection("users")
                            .document(userId)
                            .collection("cart")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                             if(snapshot.data.documents.length >0){
                            return ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, position) {
                                  // print(snapshot.data.documents.length);
                                  //    print("snapshot.data.documents.length");
                                  //       print(snapshot.data.documents.length);

                                 

                                  return  
                                  CartItem(
                                    name: snapshot.data.documents[position]
                                        .data["product_name"],
                                    image: snapshot.data.documents[position]
                                        .data["product_image_url"],
                                    price: snapshot.data.documents[position]
                                        .data["product_price"],
                                    qty: snapshot.data.documents[position]
                                        .data["product_qty"],
                                    size: snapshot.data.documents[position]
                                        .data["product_size"],
                                    vendor: snapshot.data.documents[position]
                                        .data["vendor_name"],
                                    itemId: snapshot.data.documents[position]
                                        .data["cart_item_id"],
                                    cart_total: pay,
                                    userId: userId,
                                    cart_count: count,
                                    // show: show(),
                                  );


                             
                                });}else{
                                  return noItemCart();
                                }
                          } else {
                            return noItemCart();
                          }
                        }),
                  ),
//                   Expanded(

//                     // color: Colors.green,
//                     child: Container(
//                       color: Colors.redAccent,
// height: 300,
//                       width: MediaQuery.of(context).size.width,
//                       child: Row(

//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: <Widget>[
//                           // Padding(
//                           //   padding: const EdgeInsets.all(8.0),
//                           //   child: Text("Total Amount: ₹ "+pay.toString(),style: TextStyle(
//                           //     fontSize: 20,
//                           //     fontWeight: FontWeight.w600,
//                           //     color: Colors.white
//                           //   ),),
//                           // ),
//                           InkWell(
//                             onTap: (){
//                               print("ss");

                  //      Navigator.of(context).push(PageRouteBuilder(
                  // pageBuilder: (_, __, ___) => new delivery()));
//                             },
//                                                       child: Padding(
//                         padding: const EdgeInsets.only(right: 10.0),
//                         child: Container(
//                             height: 40.0,
//                             width: 120.0,
//                             decoration: BoxDecoration(
//                               color: Colors.green,
//                             ),
//                             child: Center(
//                               child: Text(
//                                 // AppLocalizations.of(context).tr('cartPay'),
//                                 "Proceed",

//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontFamily: "Sans",
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                         ),
//                       ),
//                           ),
//                         ],
//                       )),
//                   )
                ],
              ),
            ),
          )

          // :noItemCart()
          ),
    );
  }
}

class CartItem extends StatefulWidget {
  String name, image, vendor, size, price, itemId, userId;
  int qty, cart_total, cart_count;
  // dynamic update;
  TapGestureRecognizer show;


  CartItem(
      {this.name,
      this.price,
      this.image,
      this.qty,
      this.size,
      this.vendor,
      this.itemId,
      this.userId,
      this.cart_total,
      this.cart_count,
      this.show
     });
  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
      var pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false);
    int pay = widget.qty * int.parse(widget.price);
    return Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        new IconSlideAction(
          // key: Key(items[position].id.toString()),
          caption: "Delete Item",
          color: Colors.redAccent,
          icon: Icons.delete,
          onTap: () async {
           pr.show();
            var doc = await Firestore.instance
                .collection("users")
                .document(widget.userId)
                .get();
            int old_cart_amount = doc["cart_amount"];
            int old_cart_count = doc["cart_count"];

            Firestore.instance
                .collection("users")
                .document(widget.userId)
                .updateData({
              "cart_amount":
                  old_cart_amount - widget.qty * int.parse(widget.price),
              "cart_count": old_cart_count - widget.qty
            });
            Firestore.instance
                .collection("users")
                .document(widget.userId)
                .collection("cart")
                .document(widget.itemId)
                .delete()
                .then((done) {
              print("Item deleted Sucessfully");
            });

            ///
            /// SnackBar show if cart delet
            ///
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("deleted"),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.redAccent,
            ));
            pr.hide();
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(top: 1.0, left: 13.0, right: 13.0),

        /// Background Constructor for card
        child: Container(
          height: 220.0,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.1),
                blurRadius: 3.5,
                spreadRadius: 0.4,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(10.0),

                      /// Image item
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12.withOpacity(0.1),
                                    blurRadius: 0.5,
                                    spreadRadius: 0.1)
                              ]),
                          child: widget.image != null
                              ? Image.network(
                                  widget.image,
                                  height: 130.0,
                                  width: 120.0,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 130,
                                  width: 120,
                                ))),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 25.0, left: 10.0, right: 5.0),
                      child: Column(
                        /// Text Information Item
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name ==null? "Name": widget.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: "Sans",
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(padding: EdgeInsets.only(top: 10.0)),
                          Text(
                            widget.vendor == null? "":widget.vendor,
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10.0)),
                          Text(widget.price),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 18.0, left: 0.0),
                            child: Container(
                              width: 112.0,
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  border: Border.all(
                                      color: Colors.black12.withOpacity(0.1))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  /// Decrease of value item
                                  minus_loader != false
                                      ? Container(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            backgroundColor:
                                                Colors.black12.withOpacity(0.1),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () async {
                                             pr.show();
                                            await minus(pay);
                                            pr.hide();
                                            // widget.show;
                                           
                                            // widget.update(15);
                                          },
                                          child: Container(
                                            height: 30.0,
                                            width: 30.0,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(
                                                        color: Colors.black12
                                                            .withOpacity(
                                                                0.1)))),
                                            child: Center(child: Text("-")),
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0),
                                    child: Text(
                                      widget.qty.toString()== null? "":  widget.qty.toString(),
                                      style: TextStyle(),
                                    ),
                                  ),

                                  /// Increasing value of item
                                  plus_loader != false
                                      ? Container(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            backgroundColor:
                                                Colors.black12.withOpacity(0.1),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () async {
                                            pr.show();
                                            setState(() {
                                              plus_loader = true;
                                              widget.qty = widget.qty + 1;
                                              pay = int.parse(widget.price) *
                                                  widget.qty;
                                            });
                                            await Firestore.instance
                                                .collection("users")
                                                .document(widget.userId)
                                                .collection("cart")
                                                .document(widget.itemId)
                                                .updateData({
                                              "product_qty": widget.qty,
                                            }).then((onValue) {
                                              print("qty updated");
                                            }).catchError((onError) {
                                              print("error hereeeeee");
                                            });

                                            var doc = await Firestore.instance
                                                .collection("users")
                                                .document(widget.userId)
                                                .get();
                                            int old_cart_amount =
                                                doc["cart_amount"];
                                            int old_cart_count =
                                                doc["cart_count"];

                                            int new_value = old_cart_amount +
                                                int.parse(widget.price);
                                            int new_count = old_cart_count + 1;

                                            await Firestore.instance
                                                .collection("users")
                                                .document(widget.userId)
                                                .updateData({
                                              "cart_amount": new_value,
                                              "cart_count": new_count
                                            }).then((onValue) {
                                              print("cart qty updated");
                                              setState(() {
                                                plus_loader = false;
                                              });
                                              pr.hide();
                                            }).catchError((onError) {
                                              print(onError.toString());
                                            });
                                          },
                                          child: Container(
                                            height: 30.0,
                                            width: 28.0,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    left: BorderSide(
                                                        color: Colors.black12
                                                            .withOpacity(
                                                                0.1)))),
                                            child: Center(child: Text("+")),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 8.0)),
              Divider(
                height: 2.0,
                color: Colors.black12,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 9.0, left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),

                      /// Total price of item buy
                      child: Text(
                        "Total  ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.5,
                            fontFamily: "Sans"),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Navigator.of(context).push(PageRouteBuilder(
                        //     pageBuilder: (_, __, ___) => delivery()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Container(
                          height: 40.0,
                          width: 120.0,
                          decoration: BoxDecoration(
                              // color: Color(0xFFA3BDED),
                              color: Colors.blueAccent),
                          child: Center(
                            child: Text(
                              // AppLocalizations.of(context).tr('cartPay'),
                              pay.toString() ==null? "": pay.toString(),

                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Sans",
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool minus_loader = false;
  bool plus_loader = false;
  bool _islast = false;
  minus(int pay) async {
    setState(() {
      minus_loader = true;
      widget.qty = widget.qty - 1;
      pay = int.parse(widget.price) * widget.qty;
    });


        var doc = await Firestore.instance
        .collection("users")
        .document(widget.userId)
        .get();
    int old_cart_amount = doc["cart_amount"];
    int old_cart_count = doc["cart_count"];

    int new_value = old_cart_amount - int.parse(widget.price);
    int new_count = old_cart_count - 1;



    if (widget.qty > 0) {
      await Firestore.instance
          .collection("users")
          .document(widget.userId)
          .collection("cart")
          .document(widget.itemId)
          .updateData({
        "product_qty": widget.qty,
      }).then((onValue) {
        print("qty updated");
      }).catchError((onError) {
        print("error hereeeeee");

      });


      await Firestore.instance
        .collection("users")
        .document(widget.userId)
        .updateData({"cart_amount": new_value, "cart_count": new_count}).then(
            (onValue) {
      print("user cart stats updated");
      setState(() {
        minus_loader = false;
      });
    }).catchError((onError) {
      print(onError.toString());
    });
    } else {
      await Firestore.instance
          .collection("users")
          .document(widget.userId)
          .collection("cart")
          .document(widget.itemId)
          .delete();


      await Firestore.instance
        .collection("users")
        .document(widget.userId)
        .updateData({"cart_amount": new_value, "cart_count": new_count}).then(
            (onValue) {
      print("user cart stats updated");
      
   
    }).catchError((onError) {
      print(onError.toString());
    });
    }



  }
}

///
///
/// If no item cart this class showing
///
class noItemCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      width: 500.0,
      color: Colors.white,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding:
                    EdgeInsets.only(top: mediaQueryData.padding.top + 50.0)),
            Image.asset(
              "assets/imgIllustration/IlustrasiCart.png",
              height: 300.0,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            Text(
              // AppLocalizations.of(context).tr('cartNoItem'),
              "NO item",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18.5,
                  color: Colors.black26.withOpacity(0.2),
                  fontFamily: "Popins"),
            ),
          ],
        ),
      ),
    );
  }
}

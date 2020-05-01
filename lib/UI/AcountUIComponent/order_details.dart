import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kirana_app/UI/HomeUIComponent/ChatItem.dart';

class OrderDetails extends StatefulWidget {
  final String orderId;
  OrderDetails({this.orderId});
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  String id, status;
  Timestamp date;
  int total, count,delivery;

  @override
  void initState() {
    super.initState();
    getOrderData();
  }

  getOrderData() async {
    var doc = await Firestore.instance
        .collection("orders")
        .document(widget.orderId)
        .get();
    setState(() {
      total = doc["order_amount"];
      count = doc["order_count"];
      id = doc["order_id"];
      date = doc["timestamp"];
      status = doc["status"];
      delivery = doc["delivery_charge"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            // AppLocalizations.of(context).tr('notification'),
            "Order Details",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                color: Colors.black54,
                fontFamily: "Gotik"),
          ),
          iconTheme: IconThemeData(
            color: const Color(0xFF6991C7),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Text(
                  "View Order Details",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Container(
                height: 140,
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Order date",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                              fontFamily: "Gotik"),
                        ),
                        Text(
                          "Order #",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                              fontFamily: "Gotik"),
                        ),
                        Text(
                          "Total Amount",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                              fontFamily: "Gotik"),
                        ),
                            Text(
                          "Delivery Charges",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                              fontFamily: "Gotik"),
                        ),
                        Text(
                          "Total Items",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                              fontFamily: "Gotik"),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        date == null
                            ? Text("Date")
                            : Text(date.toDate().day.toString() +
                                "-" +
                                date.toDate().month.toString() +
                                "-" +
                                date.toDate().year.toString()),
                        id == null ? Text("Id") : Text(id),
                        total == null ? Text("Amount") : Text("₹"+total.toString()),
                             delivery == null ? Text("Amount") : Text("₹"+delivery.toString()),
                        count == null ? Text("Count") : Text(count.toString()),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: Text(
                        "View Item Details",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: Text(
                        status == null ? "STATUS" : status.toUpperCase(),
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   padding: EdgeInsets.all(4),
              //   margin: EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(5),
              //       border: Border.all(width: 1)),
              //   child: productsStream(),
              // ),
              SingleChildScrollView(
          child: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("orders")
                .document(widget.orderId)
                .collection("items")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    String tempname =
                        snapshot.data.documents[index].data["product_name"];
                    String tempimage =
                        snapshot.data.documents[index].data["product_image_url"];
                    String tempprice =
                        snapshot.data.documents[index].data["product_price"];
                    int tempqty =
                        snapshot.data.documents[index].data["product_qty"];

                    return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        margin: EdgeInsets.all(10),
                        child: Material(
                            // elevation: 1,
                            child: Container(
                                height: 120,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 2),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Image.network(tempimage),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20, left: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              tempname,
                                              // overflow: TextOverflow.fade,
                                              softWrap: true,

                                              style: TextStyle(
                                                  // fontFamily: "gotik",
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              " ₹" + tempprice,
                                              style: TextStyle(
                                                  // fontFamily: "gotik",
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              tempqty.toString() + " Units",
                                              style: TextStyle(
                                                  // fontFamily: "gotik",
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ))));
                  },
                );
              } else {
                return Container(
                  child: Text("No data"),
                );
              }
            }),
      ),
    ),

              orderComplain()
            ],
          ),
        ));
  }

  Widget orderComplain() {
    return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Have any issue?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            FlatButton(
                color: Colors.blueAccent,
                onPressed: () {
                  print("Go to chat");
                  String msg = "Hello, I am having issue with order id $id.";
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new chatItem()));
                },
                child: Text(
                  "Chat now",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ));
  }

  Widget productsStream() {
    return  Container(); }
}

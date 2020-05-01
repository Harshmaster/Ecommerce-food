import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kirana_app/ListItem/HomeGridItemRecomended.dart';
import 'package:kirana_app/UI/HomeUIComponent/Home.dart';
import 'package:kirana_app/UI/HomeUIComponent/Search.dart';
import 'package:kirana_app/colors.dart';

class BrandsProductScreen extends StatefulWidget {
 final String name;
  BrandsProductScreen({this.name});

  @override
  _BrandsProductScreenState createState() => _BrandsProductScreenState();
}

class _BrandsProductScreenState extends State<BrandsProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      // backgroundColor: Color(0xFFFFFFFF),
      backgroundColor: ColorPlatte.themecolor,
      elevation: 0.0,
      title: Padding(
        padding: const EdgeInsets.only(left: 10.0,right: 10.0),
        child: Text(
          // AppLocalizations.of(context).tr('categoryBrand'),
          widget.name.toString(),
          style: TextStyle(
              fontFamily: "Gotik",
              fontSize: 20.0,
              color: Colors.black54,
              fontWeight: FontWeight.w700),
        ),
      ),
      actions: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new searchAppbar()));
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0,left: 20.0),
            child: Icon(
              Icons.search,
              size: 27.0,
              color: Colors.black54,
            ),
          ),
        )
      ],
    ),
        body: SingleChildScrollView(
                  child: Container(
            // height: 400,
            child: Column(
              children: <Widget>[
                Container(
                    child: Container(
                        color: Colors.white,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, top: 20.0, right: 20.0),
                                // child: Text(
                                //   "Recommended",
                                //   style: TextStyle(
                                //     fontWeight: FontWeight.w700,
                                //     fontSize: 17.0,
                                //   ),
                                // ),
                              ),
                              SingleChildScrollView(
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: Firestore.instance
                                        .collection("products")
                                        .where("product_brand", isEqualTo: widget.name.toUpperCase())
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return GridView.count(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 20.0),
                                            crossAxisSpacing: 10.0,
                                            mainAxisSpacing: 17.0,
                                            childAspectRatio: 0.545,
                                            crossAxisCount: 2,
                                            primary: false,
                                            children: List.generate(
                                              snapshot.data.documents.length,
                                              (index) => ItemGrid(
                                                GridItem(
                                                    title: snapshot
                                                        .data
                                                        .documents[index]
                                                        .data["product_name"],
                                                    img: snapshot.data.documents[index]
                                                        .data["product_image_url"],
                                                    price: snapshot
                                                        .data
                                                        .documents[index]
                                                        .data["product_price"],
                                                    qty: snapshot.data.documents[index]
                                                        .data["product_size"],
                                                    id: "$index",
                                                    vendor_name: snapshot
                                                        .data
                                                        .documents[index]
                                                        .data["product_vendor"],
                                                    category: snapshot
                                                        .data
                                                        .documents[index]
                                                        .data["product_category"]),
                                              ),
                                            ));

                                        // ListView.builder(
                                        //   shrinkWrap: true,
                                        //   itemCount: snapshot.data.documents.length,
                                        //   itemBuilder: (context, index) {

                                        //     return Padding(padding: EdgeInsets.all(8),
                                        //     child: Text(snapshot.data.documents[index].data["product_name"]),

                                        //     );
                                        //   },
                                        // );
                                      } else {
                                        return Center();
                                      }
                                    }),
                              )
                            ]))),
              ],
            ),
          ),
        ));
  }
}

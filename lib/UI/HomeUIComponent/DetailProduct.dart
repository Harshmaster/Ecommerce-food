import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';

import 'package:flutter/material.dart';

import 'package:flutter_rating/flutter_rating.dart';
import 'package:kirana_app/Library/carousel_pro/src/carousel_pro.dart';
import 'package:kirana_app/ListItem/HomeGridItemRecomended.dart';
import 'package:kirana_app/UI/CartUIComponent/CartLayout.dart';
import 'package:kirana_app/UI/CartUIComponent/Delivery.dart';
import 'package:kirana_app/UI/HomeUIComponent/ChatItem.dart';
import 'package:kirana_app/UI/HomeUIComponent/ReviewLayout.dart';
import 'package:kirana_app/UI/HomeUIComponent/Search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class detailProduk extends StatefulWidget {
  GridItem gridItem;

  detailProduk(this.gridItem);

  @override
  _detailProdukState createState() => _detailProdukState(gridItem);
}

/// Detail Product for Recomended Grid in home screen
class _detailProdukState extends State<detailProduk> {



List<SearchProduct> allMostSellingProductList = List();

  getMostSelling(){
        List<SearchProduct> productList = List();
    Firestore.instance.collection("most_selling").getDocuments().
    then((querySnapshot){
     for (var i = 0; i < querySnapshot.documents.length; i++) {
        productList.add(SearchProduct.fromMap(querySnapshot.documents[i].data));
      }
      setState(() {
        allMostSellingProductList = productList;
      });

    });
  }








  TextEditingController _qty = TextEditingController(text: "1");

  String userId;
  getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getid();
      getMostSelling();
    super.initState();
  }

  void showInSnackBar(String value) {
    _key.currentState.showSnackBar(new SnackBar(
      backgroundColor: Colors.green,
      content: new Text(
        value,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    ));
  }

  double rating = 3.5;
  int starCount = 5;

  /// Declaration List item HomeGridItemRe....dart Class
  final GridItem gridItem;
  _detailProdukState(this.gridItem);
  int value = 1;
  int pay = 200;
  @override
  static BuildContext ctx;
  int valueItemChart = 0;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  /// BottomSheet for view more in specification
  void _bottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SingleChildScrollView(
            child: Container(
              color: Colors.black26,
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Container(
                  height: 1500.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: 20.0)),
                      Center(
                          child: Text(
                        // AppLocalizations.of(context).tr('description'),
                        "description",
                        style: _subHeaderCustomStyle,
                      )),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
                        child: Text(
                            // AppLocalizations.of(context).tr('longLorem'),
                            "longLorem",
                            style: _detailText),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          // AppLocalizations.of(context).tr('spesifications'),
                          "spesifications",
                          style: TextStyle(
                              fontFamily: "Gotik",
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                              color: Colors.black,
                              letterSpacing: 0.3,
                              wordSpacing: 0.5),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                        child: Text(
                          // AppLocalizations.of(context).tr('loremIpsum'),
                          "loremIpsum",
                          style: _detailText,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  /// Custom Text black
  static var _customTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: "Gotik",
    fontSize: 17.0,
    fontWeight: FontWeight.w800,
  );

  /// Custom Text for Header title
  static var _subHeaderCustomStyle = TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.w700,
      fontFamily: "Gotik",
      fontSize: 16.0);

  /// Custom Text for Detail title
  static var _detailText = TextStyle(
      fontFamily: "Gotik",
      color: Colors.black54,
      letterSpacing: 0.3,
      wordSpacing: 0.5);

  bool _isfirst = true;

  Widget build(BuildContext context) {
    /// Variable Component UI use in bottom layout "Top Rated Products"
    var _suggestedItem = Padding(
      padding: const EdgeInsets.only(
          left: 15.0, right: 20.0, top: 30.0, bottom: 20.0),
      child: Container(
        height: 280.0,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  // AppLocalizations.of(context).tr('topRated'),
                  "Most Selling Products",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "Gotik",
                      fontSize: 15.0),
                ),
                // InkWell(
                //   onTap: () {},
                //   child: Text(
                //     // AppLocalizations.of(context).tr('seeAll'),
                //     "See all",
                //     style: TextStyle(
                //         color: Colors.indigoAccent.withOpacity(0.8),
                //         fontFamily: "Gotik",
                //         fontWeight: FontWeight.w700),
                //   ),
                // )
              ],
            ),
           
Expanded(
  child:  ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allMostSellingProductList.length,
        itemBuilder: ((context, index) {
       

   SearchProduct searchedproduct = SearchProduct(
              id: allMostSellingProductList[index].id,
              name: allMostSellingProductList[index].name,
              image: allMostSellingProductList[index].image,
              price: allMostSellingProductList[index].price,
              size: allMostSellingProductList[index].size);
          return InkWell(
onTap: (){
     Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (_, __, ___) => detailProduk(GridItem(id: searchedproduct.id,title: searchedproduct.name,img: searchedproduct.image,price: searchedproduct.price,category: searchedproduct.name,qty: searchedproduct.size,vendor_name: searchedproduct.vendor))));
          
          },
                      child:          Container(

                        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        child:     FavoriteItem(
                    image: searchedproduct.image,
                    title: searchedproduct.name,
                    Salary: searchedproduct.price,
                    Rating: "4.8",
                    sale: "65",
                  ),
                      ),
          );
         
        }),
      ),
)
            // Expanded(
            //   child: ListView(
            //     padding: EdgeInsets.only(top: 20.0, bottom: 2.0),
            //     scrollDirection: Axis.horizontal,
            //     children: <Widget>[
            //       FavoriteItem(
            //         image: "assets/imgItem/shoes1.jpg",
            //         title: "productTitle1",
            //         Salary: "\$ 10",
            //         Rating: "4.8",
            //         sale: "65",
            //       ),
            //       Padding(padding: EdgeInsets.only(left: 10.0)),
              
            //       Padding(padding: EdgeInsets.only(left: 10.0)),
            //       FavoriteItem(
            //         image: "assets/imgItem/shoes1.jpg",
            //         title: "productTitle1",
            //         Salary: "\$ 10",
            //         Rating: "4.8",
            //         sale: "65",
            //       ),
            //       Padding(padding: EdgeInsets.only(left: 10.0)),
            //       FavoriteItem(
            //         image: "assets/imgItem/shoes1.jpg",
            //         title: "productTitle1",
            //         Salary: "\$ 10",
            //         Rating: "4.8",
            //         sale: "65",
            //       ),
            //       Padding(padding: EdgeInsets.only(left: 10.0)),
            //     ],
            //   ),
            // ),


          ],
        ),
      ),
    );

    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    PageRouteBuilder(pageBuilder: (_, __, ___) => new cart()));
              },
              child: Stack(
                alignment: AlignmentDirectional(-1.0, -0.8),
                children: <Widget>[
                  IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.black26,
                      )),
                  // CircleAvatar(
                  //   radius: 10.0,
                  //   backgroundColor: Colors.red,
                  //   child: Text(
                  //     valueItemChart.toString(),
                  //     style: TextStyle(color: Colors.white, fontSize: 13.0),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
          elevation: 0.5,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            // AppLocalizations.of(context).tr('productDetail'),
            "Product Detail",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black54,
              fontSize: 17.0,
              fontFamily: "Gotik",
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /// Header image slider
                    Container(
                      height: 300.0,
                      child: Hero(
                        tag: "hero-grid-${gridItem.id}",
                        child: Material(
                          child: new Carousel(
                            dotColor: Colors.black26,
                            dotIncreaseSize: 1.7,
                            dotBgColor: Colors.transparent,
                            autoplay: false,
                            boxFit: BoxFit.contain,
                            images: [
                              NetworkImage(gridItem.img),
                              NetworkImage(gridItem.img),
                              NetworkImage(gridItem.img),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// Background white title,price and ratting
                    Container(
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Color(0xFF656565).withOpacity(0.15),
                          blurRadius: 1.0,
                          spreadRadius: 0.2,
                        )
                      ]),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 10.0, right: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              gridItem.title,
                              style: _customTextStyle,
                            ),
                            Padding(padding: EdgeInsets.only(top: 5.0)),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "₹" + gridItem.price,
                                  style: _customTextStyle,
                                ),
                                Text(
                                  gridItem.qty,
                                  style: _customTextStyle,
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(top: 10.0)),
                            Divider(
                              color: Colors.black12,
                              height: 1.0,
                            ),
                            Text(gridItem.vendor_name ==null? "Rasoi Ghar": gridItem.vendor_name,
                                style: TextStyle(fontSize: 20)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Text(gridItem.category ==null? "Rasoi Ghar": gridItem.category,
                                style: TextStyle(fontSize: 20)),
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _isfirst == true
                                      ? RaisedButton(
                                          color: Colors.green,
                                          onPressed: () {
                                            setState(() {
                                              _isfirst = false;
                                              value = 1;
                                            });
                                          },
                                          child: Container(
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "Add",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.add_shopping_cart,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              top: 18.0, left: 0.0),
                                          child: Container(
                                            width: 112.0,
                                            decoration: BoxDecoration(
                                                color: Colors.white70,
                                                border: Border.all(
                                                    color: Colors.black12
                                                        .withOpacity(0.1))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                /// Decrease of value item
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (value > 1) {
                                                        value = value - 1;
                                                        // pay= 950 * value;
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 30.0,
                                                    width: 30.0,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            right: BorderSide(
                                                                color: Colors
                                                                    .black12
                                                                    .withOpacity(
                                                                        0.1)))),
                                                    child: Center(
                                                        child: Text("-")),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 18.0),
                                                  child: Text(value.toString()),
                                                ),

                                                /// Increasing value of item
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (value < 5) {
                                                        value = value + 1;
                                                        // pay = 950 * value;
                                                      } else {
                                                        showInSnackBar(
                                                            "Maximum Qty Reached");
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 30.0,
                                                    width: 28.0,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            left: BorderSide(
                                                                color: Colors
                                                                    .black12
                                                                    .withOpacity(
                                                                        0.1)))),
                                                    child: Center(
                                                        child: Text("+")),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    /// Background white for chose Size and Color
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10.0),
//                       child: Container(
//                         height: 220.0,
//                         width: 600.0,
//                         decoration:
//                             BoxDecoration(color: Colors.white, boxShadow: [
//                           BoxShadow(
//                             color: Color(0xFF656565).withOpacity(0.15),
//                             blurRadius: 1.0,
//                             spreadRadius: 0.2,
//                           )
//                         ]),
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               top: 20.0, left: 20.0, right: 20.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Text(
//                                 // AppLocalizations.of(context).tr('size'),
//                                 "Size",
//                                   style: _subHeaderCustomStyle),
//                               Row(
//                                 children: <Widget>[
//                                   RadioButtonCustom(
//                                     txt:

//                                     //  AppLocalizations.of(context).tr('s'),
//                                     "S"
//                                   ),
//                                   Padding(padding: EdgeInsets.only(left: 15.0)),
//                                   RadioButtonCustom(
//                                     txt:
//                                     //  AppLocalizations.of(context).tr('m'),
//                                     "m",
//                                   ),
//                                   Padding(padding: EdgeInsets.only(left: 15.0)),
//                                   RadioButtonCustom(
//                                     txt:
//                                     // AppLocalizations.of(context).tr('l'),
//                                     "l"
//                                   ),
//                                   Padding(padding: EdgeInsets.only(left: 15.0)),
//                                   RadioButtonCustom(
//                                     txt:
//                                     // AppLocalizations.of(context).tr('xl'),
//                                     "xl",
//                                   ),
//                                 ],
//                               ),
//                               Padding(padding: EdgeInsets.only(top: 15.0)),
//                               Divider(
//                                 color: Colors.black12,
//                                 height: 1.0,
//                               ),
//                               Padding(padding: EdgeInsets.only(top: 10.0)),
//                               Text(
//                                 // AppLocalizations.of(context).tr('color'),
//                                 "Color",

//                                 style: _subHeaderCustomStyle,
//                               ),
//                               Row(
//                                 children: <Widget>[
//                                   RadioButtonColor(Colors.black),
//                                   Padding(padding: EdgeInsets.only(left: 15.0)),
//                                   RadioButtonColor(Colors.white),
//                                   Padding(padding: EdgeInsets.only(left: 15.0)),
//                                   RadioButtonColor(Colors.blue),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),

//                     /// Background white for description
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10.0),
//                       child: Container(
//                         width: 600.0,
//                         decoration:
//                             BoxDecoration(color: Colors.white, boxShadow: [
//                           BoxShadow(
//                             color: Color(0xFF656565).withOpacity(0.15),
//                             blurRadius: 1.0,
//                             spreadRadius: 0.2,
//                           )
//                         ]),
//                         child: Padding(
//                           padding: EdgeInsets.only(top: 20.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 20.0, right: 20.0),
//                                 child: Text(
//                                   // AppLocalizations.of(context)
//                                   //     .tr('description'),
// "description",
//                                   style: _subHeaderCustomStyle,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 15.0,
//                                     right: 20.0,
//                                     bottom: 10.0,
//                                     left: 20.0),
//                                 child: Text(gridItem.description,
//                                     style: _detailText),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(bottom: 15.0),
//                                 child: Center(
//                                   child: InkWell(
//                                     onTap: () {
//                                       _bottomSheet();
//                                     },
//                                     child: Text(
//                                       // AppLocalizations.of(context)
//                                       //     .tr('viewMore'),
//                                       "View more",
//                                       style: TextStyle(
//                                         color: Colors.indigoAccent,
//                                         fontSize: 15.0,
//                                         fontFamily: "Gotik",
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),

                    // /// Background white for Ratting
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10.0),
                    //   child: Container(
                    //     width: 600.0,
                    //     decoration:
                    //         BoxDecoration(color: Colors.white, boxShadow: [
                    //       BoxShadow(
                    //         color: Color(0xFF656565).withOpacity(0.15),
                    //         blurRadius: 1.0,
                    //         spreadRadius: 0.2,
                    //       )
                    //     ]),
                    //     child: Padding(
                    //       padding: EdgeInsets.only(
                    //           top: 20.0, left: 20.0, right: 20.0),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: <Widget>[
                    //           Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: <Widget>[
                    //               Text(
                    //                 // AppLocalizations.of(context).tr('review'),
                    //                 "Review",
                    //                 style: _subHeaderCustomStyle,
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.only(
                    //                     left: 20.0, top: 15.0, bottom: 15.0),
                    //                 child: Row(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.start,
                    //                   children: <Widget>[
                    //                     InkWell(
                    //                       child: Padding(
                    //                           padding: EdgeInsets.only(
                    //                               top: 2.0, right: 3.0),
                    //                           child: Text(
                    //                             // AppLocalizations.of(context)
                    //                             //     .tr('viewAll'),
                    //                             "View all",
                    //                             style: _subHeaderCustomStyle
                    //                                 .copyWith(
                    //                                     color:
                    //                                         Colors.indigoAccent,
                    //                                     fontSize: 14.0),
                    //                           )),
                    //                       onTap: () {
                    //                         Navigator.of(context).push(
                    //                             PageRouteBuilder(
                    //                                 pageBuilder: (_, __, ___) =>
                    //                                     ReviewsAll()));
                    //                       },
                    //                     ),
                    //                     Padding(
                    //                       padding: const EdgeInsets.only(
                    //                           right: 15.0, top: 2.0),
                    //                       child: Icon(
                    //                         Icons.arrow_forward_ios,
                    //                         size: 18.0,
                    //                         color: Colors.black54,
                    //                       ),
                    //                     )
                    //                   ],
                    //                 ),
                    //               )
                    //             ],
                    //           ),
                    //           Row(
                    //             children: <Widget>[
                    //               Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.start,
                    //                   children: <Widget>[
                    //                     StarRating(
                    //                       size: 25.0,
                    //                       starCount: 5,
                    //                       rating: 4.0,
                    //                       color: Colors.yellow,
                    //                     ),
                    //                     SizedBox(width: 5.0),
                    //                     Text(
                    //                       // AppLocalizations.of(context)
                    //                       //     .tr('reviews'),
                    //                       "reviews"
                    //                     )
                    //                   ]),
                    //             ],
                    //           ),
                    //           Padding(
                    //             padding: EdgeInsets.only(
                    //                 left: 0.0,
                    //                 right: 20.0,
                    //                 top: 15.0,
                    //                 bottom: 7.0),
                    //             child: _line(),
                    //           ),
                    //           _buildRating(
                    //               // AppLocalizations.of(context).tr('date'),
                    //               "date",
                    //               // AppLocalizations.of(context)
                    //               //     .tr('ratingReview')
                    //                   "ratingReview"
                    //                   , (rating) {
                    //             setState(() {
                    //               this.rating = rating;
                    //             });
                    //           }, "assets/avatars/avatar-1.jpg"),
                    //           Padding(
                    //             padding: EdgeInsets.only(
                    //                 left: 0.0,
                    //                 right: 20.0,
                    //                 top: 15.0,
                    //                 bottom: 7.0),
                    //             child: _line(),
                    //           ),
                    //           _buildRating(
                    //               // AppLocalizations.of(context).tr('date'),
                    //               "date",
                    //               // AppLocalizations.of(context)
                    //               //     .tr('ratingReview')
                    //                   "ratingReview"
                    //                   , (rating) {
                    //             setState(() {
                    //               this.rating = rating;
                    //             });
                    //           }, "assets/avatars/avatar-4.jpg"),
                    //           Padding(
                    //             padding: EdgeInsets.only(
                    //                 left: 0.0,
                    //                 right: 20.0,
                    //                 top: 15.0,
                    //                 bottom: 7.0),
                    //             child: _line(),
                    //           ),
                    //           _buildRating(
                    //               // AppLocalizations.of(context).tr('date'),
                    //               "date",
                    //               // AppLocalizations.of(context)
                    //               //     .tr('ratingReview')
                    //                   "ratingReview"
                    //                   , (rating) {
                    //             setState(() {
                    //               this.rating = rating;
                    //             });
                    //           }, "assets/avatars/avatar-2.jpg"),
                    //           Padding(padding: EdgeInsets.only(bottom: 20.0)),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    _suggestedItem
                  ],
                ),
              ),
            ),

            /// If user click icon chart SnackBar show
            /// this code to show a SnackBar
            /// and Increase a valueItemChart + 1
            InkWell(
              onTap: () {

                       Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (_, ___, ____) => new cart()));
                // var snackbar = SnackBar(
                //   content: Text(
                //       // AppLocalizations.of(context).tr('itemAdded'),
                //       "Item Added"),
                // );
                // setState(() {
                //   valueItemChart++;
                // });
                // _key.currentState.showSnackBar(snackbar);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 40.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                            color: Colors.white12.withOpacity(0.1),
                            border: Border.all(color: Colors.black12)),
                        child: Center(
                          child: Image.asset(
                            "assets/icon/shopping-cart.png",
                            height: 23.0,
                          ),
                        ),
                      ),

                      /// Chat Icon
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (_, ___, ____) => new chatItem()));
                        },
                        child: Container(
                          height: 40.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                              color: Colors.white12.withOpacity(0.1),
                              border: Border.all(color: Colors.black12)),
                          child: Center(
                            child: Image.asset("assets/icon/message.png",
                                height: 20.0),
                          ),
                        ),
                      ),

                      /// Button Pay
                      InkWell(
                        onTap: () async {

                          var cartItemId = Uuid().v4();
                          Firestore.instance
                              .collection("users")
                              .document(userId)
                              .collection("cart")
                              .document(cartItemId).setData({
                            "product_name": gridItem.title,
                            "product_price": gridItem.price,
                            "product_qty": value,
                            "vendor_name": gridItem.vendor_name,
                            "product_size": gridItem.qty,
                            "product_image_url": gridItem.img,
                            "cart_item_id": cartItemId
                          }).then((onValue) {
                            print("Product Added in cart");
                            showInSnackBar(value.toString() +
                                " " +
                                gridItem.title.toString() +
                                " Added in Cart");
                          });
                          var doc = await Firestore.instance
                              .collection("users")
                              .document(userId)
                              .get();
                          int cartAmount = doc["cart_amount"];
                          int cartCount = doc["cart_count"];
                          String cartVendor = doc["cart_vendor"];
                       cartAmount += int.parse(gridItem.price) * value;
                          cartCount += value;
 print(" cart amount"+ cartAmount.toString());
  print(" cart count"+ cartCount.toString());
                          Firestore.instance
                              .collection("users")
                              .document(userId)
                              .updateData({
                            "cart_amount": cartAmount.toInt(),
                            "cart_vendor": gridItem.vendor_name,
                            "cart_count": cartCount
                          }).then((onValue){
                           
                              print("cart stats updated in user profile");
                           
                          }).catchError((onError){
                            print(onError.toString());
                          });

                          // Navigator.of(context).push(PageRouteBuilder(
                          //     pageBuilder: (_, __, ___) => new cart()));
                        },
                        child: Container(
                          height: 45.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                            color: Colors.indigoAccent,
                          ),
                          child: Center(
                            child: Text(
                              // AppLocalizations.of(context).tr('cartPay'),
                              "Add to Cart",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRating(
      String date, String details, Function changeRating, String image) {
    return ListTile(
      leading: Container(
        height: 45.0,
        width: 45.0,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
            borderRadius: BorderRadius.all(Radius.circular(50.0))),
      ),
      title: Row(
        children: <Widget>[
          StarRating(
              size: 20.0,
              rating: 3.5,
              starCount: 5,
              color: Colors.yellow,
              onRatingChanged: changeRating),
          SizedBox(width: 8.0),
          Text(
            date,
            style: TextStyle(fontSize: 12.0),
          )
        ],
      ),
      subtitle: Text(
        details,
        style: _detailText,
      ),
    );
  }
}

/// RadioButton for item choose in size
class RadioButtonCustom extends StatefulWidget {
  String txt;

  RadioButtonCustom({this.txt});

  @override
  _RadioButtonCustomState createState() => _RadioButtonCustomState(this.txt);
}

class _RadioButtonCustomState extends State<RadioButtonCustom> {
  _RadioButtonCustomState(this.txt);

  String txt;
  bool itemSelected = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: InkWell(
        onTap: () {
          setState(() {
            if (itemSelected == false) {
              setState(() {
                itemSelected = true;
              });
            } else if (itemSelected == true) {
              setState(() {
                itemSelected = false;
              });
            }
          });
        },
        child: Container(
          height: 37.0,
          width: 37.0,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: itemSelected ? Colors.black54 : Colors.indigoAccent),
              shape: BoxShape.circle),
          child: Center(
            child: Text(
              txt,
              style: TextStyle(
                  color: itemSelected ? Colors.black54 : Colors.indigoAccent),
            ),
          ),
        ),
      ),
    );
  }
}

/// RadioButton for item choose in color
class RadioButtonColor extends StatefulWidget {
  Color clr;

  RadioButtonColor(this.clr);

  @override
  _RadioButtonColorState createState() => _RadioButtonColorState(this.clr);
}

class _RadioButtonColorState extends State<RadioButtonColor> {
  bool itemSelected = true;
  Color clr;

  _RadioButtonColorState(this.clr);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: InkWell(
        onTap: () {
          if (itemSelected == false) {
            setState(() {
              itemSelected = true;
            });
          } else if (itemSelected == true) {
            setState(() {
              itemSelected = false;
            });
          }
        },
        child: Container(
          height: 37.0,
          width: 37.0,
          decoration: BoxDecoration(
              color: clr,
              border: Border.all(
                  color: itemSelected ? Colors.black26 : Colors.indigoAccent,
                  width: 2.0),
              shape: BoxShape.circle),
        ),
      ),
    );
  }
}

/// Class for card product in "Top Rated Products"
class FavoriteItem extends StatelessWidget {
  String image, Rating, Salary, title, sale;

  FavoriteItem({this.image, this.Rating, this.Salary, this.title, this.sale});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF656565).withOpacity(0.15),
                blurRadius: 4.0,
                spreadRadius: 1.0,
//           offset: Offset(4.0, 10.0)
              )
            ]),
        child: Wrap(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 150.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7.0),
                          topRight: Radius.circular(7.0)),
                      image: DecorationImage(
                          image: NetworkImage(image), fit: BoxFit.cover)),
                ),
                Padding(padding: EdgeInsets.only(top: 15.0)),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    title,
                    style: TextStyle(
                        letterSpacing: 0.5,
                        color: Colors.black54,
                        fontFamily: "Sans",
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 1.0)),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    Salary,
                    style: TextStyle(
                        fontFamily: "Sans",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            Rating,
                            style: TextStyle(
                                fontFamily: "Sans",
                                color: Colors.black26,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0),
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 14.0,
                          )
                        ],
                      ),
                      Text(
                        sale,
                        style: TextStyle(
                            fontFamily: "Sans",
                            color: Colors.black26,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _line() {
  return Container(
    height: 0.9,
    width: double.infinity,
    color: Colors.black12,
  );
}

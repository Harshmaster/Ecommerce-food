import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:kirana_app/Library/carousel_pro/src/carousel_pro.dart';
import 'package:kirana_app/ListItem/CategoryItem.dart';
import 'package:kirana_app/ListItem/HomeGridItemRecomended.dart';
import 'package:kirana_app/ListItem/PromotionData.dart';
import 'package:kirana_app/UI/HomeUIComponent/PromotionDetail.dart';
import 'package:kirana_app/UI/HomeUIComponent/Search.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter/material.dart';

class CategoryDetail extends StatefulWidget {
  final String category_name, category_id, categoryImg;

  CategoryDetail({this.category_id, this.category_name, this.categoryImg});
  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

/// if user click icon in category layout navigate to CategoryDetail Layout
class _CategoryDetailState extends State<CategoryDetail> {
  ///
  /// Get image data dummy from firebase server
  ///
  var imageNetwork = NetworkImage(
      "https://firebasestorage.googleapis.com/v0/b/beauty-look.appspot.com/o/Screenshot_20181005-213916.png?alt=media&token=f952caf0-2de7-417c-9c9e-3b6dcea953f4");

  ///
  /// check the condition is right or wrong for image loaded or no
  ///
  bool loadImage = true;

  /// custom text variable is make it easy a custom textStyle black font
  static var _customTextStyleBlack = TextStyle(
      fontFamily: "Gotik",
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 15.0);

  /// Custom text blue in variable
  static var _customTextStyleBlue = TextStyle(
      fontFamily: "Gotik",
      color: Color(0xFF6991C7),
      fontWeight: FontWeight.w700,
      fontSize: 15.0);

  ///
  /// SetState after imageNetwork loaded to change list card
  ///
  ///

  String banner1, banner2, banner3, banner4;
  getBannerUrl() async {
    var doc = await Firestore.instance
        .collection("banners")
        .document(widget.category_id)
        .get();
    if (doc.exists) {
      print("banner document found");
      print(doc["banner3"]);
      setState(() {
        banner1 = doc["banner1"];

        banner2 = doc["banner2"];
        banner3 = doc["banner3"];
        banner4 = doc["banner4"];
      });
    } else {
      print("no banner document");
    }
  }

  @override
  void initState() {
    getBannerUrl();
    Timer(Duration(seconds: 3), () {
      setState(() {
        loadImage = false;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  /// All Widget Component layout
  @override
  Widget build(BuildContext context) {
    /// imageSlider in header layout category detail
    var _imageSlider = Padding(
      padding: const EdgeInsets.only(
          top: 0.0, left: 10.0, right: 10.0, bottom: 35.0),
      child: Container(
        height: 180.0,
        child: new Carousel(
          boxFit: BoxFit.cover,
          dotColor: Colors.transparent,
          dotSize: 5.5,
          dotSpacing: 16.0,
          dotBgColor: Colors.transparent,
          showIndicator: false,
          overlayShadow: false,
          overlayShadowColors: Colors.white.withOpacity(0.9),
          overlayShadowSize: 0.9,
          images: [
            // AssetImage("assets/category_banner/spices1.png"),
            // AssetImage("assets/category_banner/spices2.png"),
            //  AssetImage("assets/category_banner/spices3.png"),
            //   AssetImage("assets/category_banner/spices4.png"),

            banner1 != null
                ? CachedNetworkImage(
                    imageUrl: banner1,
                    placeholder: (context, content) {
                      return Container(
                        child: Image.asset(widget.categoryImg),
                      );
                    },
                  )
                // ? NetworkImage()
                : AssetImage(widget.categoryImg),
            banner2 != null
                ? CachedNetworkImage(
                    imageUrl: banner2,
                    placeholder: (context, content) {
                      return Container(
                        child: Image.asset(widget.categoryImg),
                      );
                    },
                  )
                : AssetImage(widget.categoryImg),
            banner3 != null
                ? NetworkImage(banner3)
                : AssetImage(widget.categoryImg),
            banner4 != null
                ? NetworkImage(banner4)
                : AssetImage(widget.categoryImg),
          ],
        ),
      ),
    );

    /// Variable Category (Sub Category)
    var _subCategory = Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  // AppLocalizations.of(context).tr('subCategory'),
                  "Sub Category",
                  style: _customTextStyleBlack,
                ),
                // InkWell(
                //   onTap: () {
                //     Navigator.of(context).push(PageRouteBuilder(
                //         pageBuilder: (_, __, ___) => new promoDetail()));
                //   },
                //   child: Text(
                //       // AppLocalizations.of(context).tr('seeMore'),
                //       "See more",
                //       style:
                //           _customTextStyleBlue.copyWith(color: Colors.black26)),
                // ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.only(right: 10.0, top: 5.0),
              height: 110.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(left: 20.0)),
                  KeywordItem(
                    title: "Category1",
                    title2: "CAtegory2",
                  ),
                  Padding(padding: EdgeInsets.only(left: 15.0)),
                  KeywordItem(
                    title: "Category1",
                    title2: "CAtegory2",
                  ),
                  Padding(padding: EdgeInsets.only(left: 15.0)),
                  KeywordItem(
                    title: "Category1",
                    title2: "CAtegory2",
                  ),
                  Padding(padding: EdgeInsets.only(left: 15.0)),
                  KeywordItem(
                    title: "Category1",
                    title2: "CAtegory2",
                  ),
                  Padding(padding: EdgeInsets.only(right: 20.0)),
                ],
              ),
            ),
          )
        ],
      ),
    );

    /// Variable item Discount with Card
    var _itemDiscount = Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  //  AppLocalizations.of(context).tr('itemDiscount'),
                  "Item Discount",
                  style: _customTextStyleBlack,
                ),
                // InkWell(
                //   onTap: () {
                //     Navigator.of(context).push(PageRouteBuilder(
                //         pageBuilder: (_, __, ___) => new promoDetail()));
                //   },
                //   child: Text(
                //       // AppLocalizations.of(context).tr('seeMore'),
                //       "See more",
                //       style: _customTextStyleBlue),
                // ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(right: 10.0),
              height: 300.0,

              ///
              ///
              /// check the condition if image data from server firebase loaded or no
              /// if image true (image still downloading from server)
              /// Card to set card loading animation
              ///
              ///
              child: loadImage
                  ? _loadingImageAnimationDiscount(context)
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) =>
                          discountItem(itemDiscount[index]),
                      itemCount: itemDiscount.length,
                    ),
            ),
          )
        ],
      ),
    );

    /// Variable item Popular with Card
    var _itemPopular = Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    //  AppLocalizations.of(context).tr('itemPopular'),

                    "Item Popular",
                    style: _customTextStyleBlack,
                  ),
                  // InkWell(
                  //   onTap: null,
                  //   child: Text(
                  //       // AppLocalizations.of(context).tr('seeMore'),
                  //       "See more",
                  //       style: _customTextStyleBlue),
                  // ),
                ],
              ),
            ),

            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("products")
                      .where("product_category", isEqualTo: widget.category_id)
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
                              promotionData(
                                  title: snapshot.data.documents[index]
                                      .data["product_name"],
                                  image: snapshot.data.documents[index]
                                      .data["product_image_url"],
                                  rating: "",
                                  salary: snapshot.data.documents[index]
                                      .data["product_price"],
                                  sale: "",
                                  category: snapshot.data.documents[index]
                                      .data["product_category"],
                                  qty: snapshot.data.documents[index]
                                      .data["product_size"],
                                  vendorname: snapshot.data.documents[index]
                                      .data["product_vendor"]),
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
            ),

            // SingleChildScrollView(
            //   child: Container(
            //     margin: EdgeInsets.only(right: 10.0),
            //     height: 300.0,

            //     ///
            //     ///
            //     /// check the condition if image data from server firebase loaded or no
            //     /// if image true (image still downloading from server)
            //     /// Card to set card loading animation
            //     ///
            //     ///
            //     child: loadImage
            //         ? _loadingImageAnimation(context)
            //         :

            //         ListView.builder(
            //             scrollDirection: Axis.horizontal,
            //             itemBuilder: (BuildContext context, int index) =>
            //                 Item(itemPopularData[index]),
            //             itemCount: itemDiscount.length,
            //           ),
            //   ),
            // )
          ],
        ),
      ),
    );

    /// Variable New Items with Card
    var _itemNew = Padding(
      padding: const EdgeInsets.only(top: 30.0, bottom: 15.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    //  AppLocalizations.of(context).tr('newItem'),
                    "new item",
                    style: _customTextStyleBlack,
                  ),
                  InkWell(
                    onTap: null,
                    child: Text(
                        // AppLocalizations.of(context).tr('seeMore'),
                        "See more",
                        style: _customTextStyleBlue),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(right: 10.0, bottom: 15.0),
                height: 300.0,

                ///
                ///
                /// check the condition if image data from server firebase loaded or no
                /// if image true (image still downloading from server)
                /// Card to set card loading animation
                ///
                ///
                child: loadImage
                    ? _loadingImageAnimation(context)
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) =>
                            Item(newItems[index]),
                        itemCount: itemDiscount.length,
                      ),
              ),
            )
          ],
        ),
      ),
    );

    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => new searchAppbar()));
              },
              icon: Icon(Icons.search, color: Color(0xFF6991C7)),
            ),
          ],
          centerTitle: true,
          title: Text(
            // AppLocalizations.of(context).tr('man'),
            widget.category_name,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16.0,
                color: Colors.black54,
                fontFamily: "Gotik"),
          ),
          iconTheme: IconThemeData(
            color: Color(0xFF6991C7),
          ),
          elevation: 0.0,
        ),

        /// For call a variable include to body
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                _imageSlider,
                // _subCategory,
                // _itemDiscount,
                _itemPopular,
                // _itemNew
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Class Component a Item Discount Card
class discountItem extends StatelessWidget {
  categoryItem item;

  discountItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0, left: 10.0, bottom: 10.0, right: 0.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF656565).withOpacity(0.15),
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
//           offset: Offset(4.0, 10.0)
                )
              ]),
          child: Wrap(
            children: <Widget>[
              Container(
                width: 160.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 185.0,
                          width: 160.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7.0),
                                  topRight: Radius.circular(7.0)),
                              image: DecorationImage(
                                  image: AssetImage(item.image),
                                  fit: BoxFit.cover)),
                        ),
                        Container(
                          height: 25.5,
                          width: 55.0,
                          decoration: BoxDecoration(
                              color: Color(0xFFD7124A),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20.0),
                                  topLeft: Radius.circular(5.0))),
                          child: Center(
                              child: Text(
                            "10%",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          )),
                        )
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 7.0)),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Text(
                        item.title,
                        overflow: TextOverflow.ellipsis,
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
                        item.Salary,
                        style: TextStyle(
                            fontFamily: "Sans",
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                item.Rating,
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
                            item.sale,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Class Component Card in Category Detail
class Item extends StatelessWidget {
  categoryItem item;

  Item(this.item);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0, left: 10.0, bottom: 10.0, right: 0.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF656565).withOpacity(0.15),
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
//           offset: Offset(4.0, 10.0)
                )
              ]),
          child: Wrap(
            children: <Widget>[
              Container(
                width: 160.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 185.0,
                      width: 160.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(7.0),
                              topRight: Radius.circular(7.0)),
                          image: DecorationImage(
                              image: AssetImage(item.image),
                              fit: BoxFit.cover)),
                    ),
                    Padding(padding: EdgeInsets.only(top: 7.0)),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Text(
                        item.title,
                        overflow: TextOverflow.ellipsis,
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
                        item.Salary,
                        style: TextStyle(
                            fontFamily: "Sans",
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                item.Rating,
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
                            item.sale,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///
///
///
/// Loading Item Card Animation Constructor
///
///
///
class loadingMenuItemDiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0, left: 10.0, bottom: 10.0, right: 0.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF656565).withOpacity(0.15),
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
//           offset: Offset(4.0, 10.0)
                )
              ]),
          child: Wrap(
            children: <Widget>[
              Shimmer.fromColors(
                baseColor: Colors.black38,
                highlightColor: Colors.white,
                child: Container(
                  width: 160.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            height: 185.0,
                            width: 160.0,
                            color: Colors.black12,
                          ),
                          Container(
                            height: 25.5,
                            width: 65.0,
                            decoration: BoxDecoration(
                                color: Color(0xFFD7124A),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20.0),
                                    topLeft: Radius.circular(5.0))),
                          )
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 5.0, top: 12.0),
                          child: Container(
                            height: 9.5,
                            width: 130.0,
                            color: Colors.black12,
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 5.0, top: 10.0),
                          child: Container(
                            height: 9.5,
                            width: 80.0,
                            color: Colors.black12,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "",
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
                            Container(
                              height: 8.0,
                              width: 30.0,
                              color: Colors.black12,
                            )
                          ],
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
    );
  }
}

///
///
///
/// Loading Item Card Animation Constructor
///
///
///
class loadingMenuItemCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0, left: 10.0, bottom: 10.0, right: 0.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF656565).withOpacity(0.15),
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
//           offset: Offset(4.0, 10.0)
                )
              ]),
          child: Wrap(
            children: <Widget>[
              Shimmer.fromColors(
                baseColor: Colors.black38,
                highlightColor: Colors.white,
                child: Container(
                  width: 160.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 185.0,
                        width: 160.0,
                        color: Colors.black12,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 5.0, top: 12.0),
                          child: Container(
                            height: 9.5,
                            width: 130.0,
                            color: Colors.black12,
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 5.0, top: 10.0),
                          child: Container(
                            height: 9.5,
                            width: 80.0,
                            color: Colors.black12,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "",
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
                            Container(
                              height: 8.0,
                              width: 30.0,
                              color: Colors.black12,
                            )
                          ],
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
    );
  }
}

///
///
/// Calling imageLoading animation for set a grid layout
///
///
Widget _loadingImageAnimation(BuildContext context) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemBuilder: (BuildContext context, int index) => loadingMenuItemCard(),
    itemCount: itemDiscount.length,
  );
}

///
///
/// Calling imageLoading animation for set a grid layout
///
///
Widget _loadingImageAnimationDiscount(BuildContext context) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemBuilder: (BuildContext context, int index) =>
        loadingMenuItemDiscountCard(),
    itemCount: itemDiscount.length,
  );
}

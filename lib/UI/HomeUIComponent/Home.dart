import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'package:flutter/material.dart';
import 'package:kirana_app/Library/carousel_pro/src/carousel_pro.dart';
import 'package:kirana_app/Library/countdown_timer/countDownTimer.dart';
import 'package:kirana_app/ListItem/HomeGridItemRecomended.dart';
import 'package:kirana_app/UI/HomeUIComponent/AppbarGradient.dart';
import 'package:kirana_app/UI/HomeUIComponent/CategoryDetail.dart';
import 'package:kirana_app/UI/HomeUIComponent/DetailProduct.dart';
import 'package:kirana_app/UI/HomeUIComponent/MenuDetail.dart';
import 'package:kirana_app/UI/HomeUIComponent/PromotionDetail.dart';
import 'package:kirana_app/UI/HomeUIComponent/Search.dart';

import 'FlashSale.dart';

class Menu extends StatefulWidget {
  
     final FirebaseAnalytics analytics;
final FirebaseAnalyticsObserver observer;

Menu({this.analytics,this.observer});
  @override
  _MenuState createState() => _MenuState();
}

/// Component all widget in home
class _MenuState extends State<Menu> with TickerProviderStateMixin {
  /// Declare class GridItem from HomeGridItemReoomended.dart in folder ListItem
  GridItem gridItem;

  bool isStarted = false;
 List<SearchProduct> allFlashProductList = List();

  getEssentials(){
        List<SearchProduct> productList = List();
    Firestore.instance.collection("essential_products").getDocuments().
    then((querySnapshot){
     for (var i = 0; i < querySnapshot.documents.length; i++) {
        productList.add(SearchProduct.fromMap(querySnapshot.documents[i].data));
      }
      setState(() {
        allFlashProductList = productList;
      });

    });
  }

  String banner1, banner2, banner3, banner4;
  getBannerUrl() async {
    var doc = await Firestore.instance
        .collection("banners")
        .document("homepage")
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

// Future<Null> _sendAnalytics() async{
// await widget.analytics.logEvent(name: "Menu Screen Logged",
// parameters: <String,dynamic>{}
// );
// print("Menu Screen logged");
// }


  @override
  void initState() {
    // TODO: implement initState
    getEssentials();
    getBannerUrl();
    super.initState();
    // _sendAnalytics();
  }


  

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double size = mediaQueryData.size.height;


  Widget mostEssentialsIntro(){  
         
       return  Container(
         margin: EdgeInsets.only(right: 30),
         child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(left: mediaQueryData.padding.left + 20),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/img/flashsaleicon.png",
                      height: size * 0.087,
                    ),
                    Text(
                      // AppLocalizations.of(context).tr('flas'),
                      "Daily \nEssentials",
                      style: TextStyle(
                        fontFamily: "Popins",
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      // AppLocalizations.of(context).tr('sale'),
                      "Sale",
                      style: TextStyle(
                        fontFamily: "Sans",
                        fontSize: 28.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: mediaQueryData.padding.top + 30),
                    ),
                    Text(
                      // AppLocalizations.of(context).tr('endSaleIn'),
                      "Sales ends in",
                      style: TextStyle(
                        fontFamily: "Sans",
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                    ),
                    CountDownTimer(
                        secondsRemaining: 86400,
                        whenTimeExpires: () {
                          setState(() {
                            //hasTimerStopped = true;
                          });
                        },
                        countDownTimerStyle: TextStyle(
                          fontFamily: "Sans",
                          fontSize: 19.0,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )),
                  ],
                )
              ],
            ),
       );
         }
    /// Navigation to MenuDetail.dart if user Click icon in category Menu like a example camera
    var onClickMenuIcon = () {
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) => new menuDetail(),
          transitionDuration: Duration(milliseconds: 750),

          /// Set animation with opacity
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            return Opacity(
              opacity: animation.value,
              child: child,
            );
          }));
    };

    /// Navigation to promoDetail.dart if user Click icon in Week Promotion
    var onClickWeekPromotion = () {
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) => new promoDetail(),
          transitionDuration: Duration(milliseconds: 750),
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            return Opacity(
              opacity: animation.value,
              child: child,
            );
          }));
    };

    /// Navigation to categoryDetail.dart if user Click icon in Category
    var onClickCategory = (String name,String id,String img) {
      Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) => new CategoryDetail(category_name: name,category_id: id,categoryImg: img,),
          // transitionDuration: Duration(milliseconds: 750),
          // transitionsBuilder:
          //     (_, Animation<double> animation, __, Widget child) {
          //   return Opacity(
          //     opacity: animation.value,
          //     child: child,
          //   );
          // }
          )
          );
    };

    /// Declare device Size
    var deviceSize = MediaQuery.of(context).size;

    /// ImageSlider in header
    var imageSlider = Container(
      height: 182.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        dotColor: Color(0xFF6991C7).withOpacity(0.8),
        dotSize: 5.5,
        dotSpacing: 16.0,
        dotBgColor: Colors.transparent,
        showIndicator: true,
        overlayShadow: false,
        overlayShadowColors: Colors.white.withOpacity(0.9),
        overlayShadowSize: 0.0,
        images: [
          // AssetImage("assets/category_banner/beauty.png"),
            // AssetImage("assets/category_banner/grains.png"),
            //   AssetImage("assets/category_banner/oils.png"),
            //     AssetImage("assets/category_banner/spices.png"),

                    banner1 != null
                ? CachedNetworkImage(
                    imageUrl: banner1,
                    placeholder: (context, content) {
                      return Container(
                        child: Image.asset("assets/category_banner/spices.png"),
                      );
                    },
                  )
                // ? NetworkImage()
                : AssetImage("assets/category_banner/spices.png"),

                      banner2 != null
                ? CachedNetworkImage(
                    imageUrl: banner2,
                    placeholder: (context, content) {
                      return Container(
                        child: Image.asset("assets/category_banner/beverages.png"),
                      );
                    },
                  )
                // ? NetworkImage()
                : AssetImage("assets/category_banner/beverages.png"),

                      banner3 != null
                ? CachedNetworkImage(
                    imageUrl: banner3,
                    placeholder: (context, content) {
                      return Container(
                        child: Image.asset("assets/category_banner/dryfruits.png"),
                      );
                    },
                  )
                // ? NetworkImage()
                : AssetImage("assets/category_banner/dryfruits.png"),
                      banner4 != null
                ? CachedNetworkImage(
                    imageUrl: banner4,
                    placeholder: (context, content) {
                      return Container(
                        child: Image.asset("assets/category_banner/cosmetics.jpg"),
                      );
                    },
                  )
                // ? NetworkImage()
                : AssetImage("assets/category_banner/cosmetics.jpg"),
       
        ],
      ),
    );

    /// CategoryIcon Component
    // var categoryIcon = Container(
    //   color: Colors.white,
    //   padding: EdgeInsets.only(top: 20.0),
    //   alignment: AlignmentDirectional.centerStart,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       Padding(
    //         padding: EdgeInsets.only(left: 20.0, top: 0.0, right: 20.0),
    //         child: Text(
    //           // AppLocalizations.of(context).tr('menu'),
    //           "Menu",
    //           style: TextStyle(
    //               fontSize: 13.5,
    //               fontFamily: "Sans",
    //               fontWeight: FontWeight.w700),
    //         ),
    //       ),
    //       Padding(padding: EdgeInsets.only(top: 20.0)),

    //       /// Get class CategoryIconValue
    //       CategoryIconValue(
    //         tap1: onClickMenuIcon,
    //         icon1: "assets/icon/camera.png",
    //         title1: "Camera",
    //         tap2: onClickMenuIcon,
    //         icon2: "assets/icon/food.png",
    //         title2: "Food",
    //         tap3: onClickMenuIcon,
    //         icon3: "assets/icon/handphone.png",
    //         title3: "headphone",
    //         tap4: onClickMenuIcon,
    //         icon4: "assets/icon/game.png",
    //         title4: "Gaming",
    //       ),
    //       Padding(padding: EdgeInsets.only(top: 23.0)),
    //       CategoryIconValue(
    //         tap1: onClickMenuIcon,
    //         icon1: "assets/icon/camera.png",
    //         title1: "Camera",
    //         tap2: onClickMenuIcon,
    //         icon2: "assets/icon/food.png",
    //         title2: "Food",
    //         tap3: onClickMenuIcon,
    //         icon3: "assets/icon/handphone.png",
    //         title3: "headphone",
    //         tap4: onClickMenuIcon,
    //         icon4: "assets/icon/game.png",
    //         title4: "Gaming",
    //       ),
    //       Padding(padding: EdgeInsets.only(top: 23.0)),
    //       CategoryIconValue(
    //         tap1: onClickMenuIcon,
    //         icon1: "assets/icon/camera.png",
    //         title1: "Camera",
    //         tap2: onClickMenuIcon,
    //         icon2: "assets/icon/food.png",
    //         title2: "Food",
    //         tap3: onClickMenuIcon,
    //         icon3: "assets/icon/handphone.png",
    //         title3: "headphone",
    //         tap4: onClickMenuIcon,
    //         icon4: "assets/icon/game.png",
    //         title4: "Gaming",
    //       ),

    //       Padding(padding: EdgeInsets.only(bottom: 30.0))
    //     ],
    //   ),
    // );

    // /// ListView a WeekPromotion Component
    // var PromoHorizontalList = Container(
    //   color: Colors.white,
    //   height: 230.0,
    //   padding: EdgeInsets.only(bottom: 40.0),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       Padding(
    //           padding: EdgeInsets.only(
    //               left: 20.0, top: 15.0, bottom: 3.0, right: 20.0),
    //           child: Text(
    //             // AppLocalizations.of(context).tr('weekPromotion'),
    //             "Week Promotion",
    //             style: TextStyle(
    //                 fontSize: 15.0,
    //                 fontFamily: "Sans",
    //                 fontWeight: FontWeight.w700),
    //           )),
    //       Expanded(
    //         child: ListView(
    //           shrinkWrap: true,
    //           padding: EdgeInsets.only(top: 10.0),
    //           scrollDirection: Axis.horizontal,
    //           children: <Widget>[
    //             // Padding(padding: EdgeInsets.only(left: 20.0)),
    //             // InkWell(
    //             //     onTap: onClickWeekPromotion,
    //             //     child: Image.asset("assets/imgPromo/Discount1.png")),
    //             // Padding(padding: EdgeInsets.only(left: 10.0)),
    //             // InkWell(
    //             //     onTap: onClickWeekPromotion,
    //             //     child: Image.asset("assets/imgPromo/Discount3.png")),
    //             // Padding(padding: EdgeInsets.only(left: 10.0)),
    //             // InkWell(
    //             //     onTap: onClickWeekPromotion,
    //             //     child: Image.asset("assets/imgPromo/Discount2.png")),
    //             // Padding(padding: EdgeInsets.only(left: 10.0)),
             
    //             Padding(padding: EdgeInsets.only(left: 10.0)),
    //             InkWell(
    //                 onTap: onClickWeekPromotion,
    //                 child: Image.asset("assets/imgPromo/Discount5.png")),
    //             Padding(padding: EdgeInsets.only(left: 10.0)),
    //             InkWell(
    //                 onTap: onClickWeekPromotion,
    //                 child: Image.asset("assets/imgPromo/Discount6.png")),
    //                 Padding(padding: EdgeInsets.only(left: 10.0)),
    //              InkWell(
    //                 onTap: onClickWeekPromotion,
    //                 child: Image.asset("assets/products/tide_sale.png")),
    //             Padding(padding: EdgeInsets.only(left: 10.0)),
    //                InkWell(
    //                 onTap: onClickWeekPromotion,
    //                 child: Image.asset("assets/products/dove_sale.png")),
    //             Padding(padding: EdgeInsets.only(left: 10.0)),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    /// FlashSale component
    var FlashSell = Container(
      height: 390.0,
      decoration: BoxDecoration(
        /// To set Gradient in flashSale background
        gradient: LinearGradient(colors: [
          Color(0xFF7F7FD5).withOpacity(0.8),
          Color(0xFF86A8E7),
          Color(0xFF91EAE4)
        ]),
      ),

      /// To set FlashSale Scrolling horizontal
      child:  ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allFlashProductList.length + 1,
        itemBuilder: ((context, index) {
       

              if(index == 0){
                return mostEssentialsIntro();
              }
   SearchProduct searchedproduct = SearchProduct(
              id: allFlashProductList[index-1].id,
              name: allFlashProductList[index-1].name,
              image: allFlashProductList[index-1].image,
              price: allFlashProductList[index-1].price,
              size: allFlashProductList[index-1].size);
          return InkWell(
onTap: (){
     Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) => detailProduk(GridItem(id: searchedproduct.id,title: searchedproduct.name,img: searchedproduct.image,price: searchedproduct.price,category: searchedproduct.name,qty: searchedproduct.size,vendor_name: searchedproduct.vendor))));
          
          },
                      child:          Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: flashSaleItem(
            image: searchedproduct.image,
            title: searchedproduct.name,
            normalprice: searchedproduct.price,
            discountprice: searchedproduct.price,
            ratingvalue: "(56)",
            place: "fPlace1",
            stock: "fAvailable1",
            colorLine: 0xFFFFA500,
            widthLine: 50.0,
          ),
                      ),
          );
          //  CustomTile(
          //   mini: false,
          //   onTap: () {},
          //   leading: CircleAvatar(
          //     backgroundImage: NetworkImage(searchedUser.profilePhoto),
          //     backgroundColor: Colors.grey,
          //   ),
          //   title: Text(
          //     searchedUser.username,
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   subtitle: Text(
          //     searchedUser.name,
          //     style: TextStyle(color: UniversalVariables.greyColor),
          //   ),
          // );
        }),
      ));
      
      // ListView(
      //   scrollDirection: Axis.horizontal,
      //   children: <Widget>[
       
          // Padding(padding: EdgeInsets.only(left: 40.0)),

          // /// Get a component flashSaleItem class
          // flashSaleItem(
          //   image: "assets/products/ezee_sale.png",
          //   title: "Ezee",
          //   normalprice: "220",
          //   discountprice: "130",
          //   ratingvalue: "(56)",
          //   place: "fPlace1",
          //   stock: "fAvailable1",
          //   colorLine: 0xFFFFA500,
          //   widthLine: 50.0,
          // ),
          // Padding(padding: EdgeInsets.only(left: 10.0)),
          // flashSaleItem(
          //   image: "assets/products/tide_sale.png",
          //   title: "Tide",
          //   normalprice: "120",
          //   discountprice: "100",
          //   ratingvalue: "(56)",
          //   place: "fPlace1",
          //   stock: "fAvailable1",
          //   colorLine: 0xFFFFA500,
          //   widthLine: 50.0,
          // ),
          // Padding(padding: EdgeInsets.only(left: 10.0)),

          // flashSaleItem(
          //   image: "assets/products/pantene_sale.png",
          //   title: "Pantene",
          //   normalprice: "160",
          //   discountprice: "130",
          //   ratingvalue: "(56)",
          //   place: "fPlace1",
          //   stock: "fAvailable1",
          //   colorLine: 0xFFFFA500,
          //   widthLine: 50.0,
          // ),
          // Padding(padding: EdgeInsets.only(left: 10.0)),
          // flashSaleItem(
          //   image: "assets/products/detol_sale.png",
          //   title: "Detol",
          //   normalprice: "90",
          //   discountprice: "70",
          //   ratingvalue: "(56)",
          //   place: "fPlace1",
          //   stock: "fAvailable1",
          //   colorLine: 0xFFFFA500,
          //   widthLine: 50.0,
          // ),
          // Padding(padding: EdgeInsets.only(left: 10.0)),
          // flashSaleItem(
          //   image: "assets/products/dove_sale.png",
          //   title: "Dove",
          //   normalprice: "90",
          //   discountprice: "70",
          //   ratingvalue: "(56)",
          //   place: "fPlace1",
          //   stock: "fAvailable1",
          //   colorLine: 0xFFFFA500,
          //   widthLine: 50.0,
          // ),
          // Padding(padding: EdgeInsets.only(left: 10.0)),
        // ],
      // ),
    // );

    /// Category Component in bottom of flash sale
    var categoryImageBottom = Container(
      height: 600.0,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
            child: Text(
              //
              "Category",
              style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Sans"),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 2),

              child: Column(
                // scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 5
                      // left: 20.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        // Padding(padding: EdgeInsets.only(top: 15.0)),
                        CategoryItemValue(
                          image: "assets/category_banner/spices.png",
                          title:
                              // AppLocalizations.of(context).tr('fashionMan'),
                              "Spices",
                      tap: (){
                          onClickCategory("Spices","Spices","assets/category_banner/spices.png");
                        },
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(top: 10.0),
                        // ),
                        CategoryItemValue(
                          image: "assets/category_banner/oils.png",
                          title:
                              // AppLocalizations.of(context).tr('fashionGirl'),
                              "Oils",
                  tap: (){
                          onClickCategory("Oils","Oils","assets/category_banner/oils.png");
                        },
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10.0)),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // Padding(padding: EdgeInsets.only(top: 15.0)),
                      CategoryItemValue(
                        image: "assets/category_banner/staples.jpg",
                        title: "Staples",
                        tap: (){
                          onClickCategory("Staples","Staples","assets/category_banner/grains.png");
                        },
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 10.0),
                      // ),
                      CategoryItemValue(
                        image: "assets/category_banner/cosmetics.jpg",
                        title: "Cosmetics",
                     tap: (){
                          onClickCategory("Cosmetics","Cosmetics","assets/category_banner/cosmetics.jpg");
                        },
                      ),
                    ],
                  ),
                  // Padding(padding: EdgeInsets.only(left: 10.0)),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // Padding(padding: EdgeInsets.only(top: 15.0)),
                      CategoryItemValue(
                        image: "assets/category_banner/beverages.png",
                        title: "Beverages",
                        tap: (){
                          onClickCategory("Beverages","Beverages","assets/category_banner/beverages.png");
                        },
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 10.0),
                      // ),
                      CategoryItemValue(
                        image: "assets/category_banner/dryfruits.png",
                        title: "Dry Fruits",
                     tap: (){
                          onClickCategory("Dry Fruits","Dry Fruits","assets/category_banner/dryfruits.png");
                        },
                      ),
                    ],
                  ),
                  // Padding(padding: EdgeInsets.only(left: 10.0)),
 Padding(padding: EdgeInsets.only(top: 20.0)),
                   Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // Padding(padding: EdgeInsets.only(top: 15.0)),
                      CategoryItemValue(
                        image: "assets/category_banner/cleaning.jpg",
                        title: "Cleaning",
                        tap: (){
                          onClickCategory("Cleaning","Cleaning ","assets/category_banner/cleaning.jpg");
                        },
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 10.0),
                      // ),
                      CategoryItemValue(
                        image: "assets/category_banner/snacks.jpg",
                        title: "Snacks",
                     tap: (){
                          onClickCategory("Snacks","Snacks","assets/category_banner/snacks.jpg");
                        },
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  

                 
                ],
              ),
            ),
          )
        ],
      ),
    );

    ///  Grid item in bottom of Category
    var Grid = SingleChildScrollView(
      child: 
      
      Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
              child: Text(
                "Recommended",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17.0,
                ),
              ),
            ),
            SingleChildScrollView(
        child:
          StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection("products")
                            .where("isRecommended", isEqualTo: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return GridView.count(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 17.0,
                childAspectRatio: 0.545,
                crossAxisCount: 2,
                primary: false,
                children: List.generate(
                  snapshot.data.documents.length,
                  (index) => ItemGrid(
                    GridItem(
                      title: snapshot.data.documents[index].data["product_name"],
                      img: snapshot.data.documents[index].data["product_image_url"],
                      price: snapshot.data.documents[index].data["product_price"],
                      qty: snapshot.data.documents[index].data["product_size"],
                      id: "$index",
                      vendor_name: snapshot.data.documents[index].data["product_vendor"],
                     category:  snapshot.data.documents[index].data["product_category"]

                      
                      ),
                    
                    
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
                            return Center(
                     
                            );
                          }
                        }),
        ),
    

             
            /// To set GridView item
            // GridView.count(
            //     shrinkWrap: true,
            //     padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            //     crossAxisSpacing: 10.0,
            //     mainAxisSpacing: 17.0,
            //     childAspectRatio: 0.545,
            //     crossAxisCount: 2,
            //     primary: false,
            //     children: List.generate(
            //       gridItemArray.length,
            //       (index) => ItemGrid(gridItemArray[index]),
            //     ))
          ],
        ),
      ),
    );

    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        /// Use Stack to costume a appbar
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          top: mediaQueryData.padding.top + 58.5)),

                  /// Call var imageSlider
                  imageSlider,
  categoryImageBottom,
                  /// Call var categoryIcon
                  // categoryIcon,
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),

                  /// Call var PromoHorizontalList
                  // PromoHorizontalList,

                  /// Call var a FlashSell, i am sorry Typo :v
                  FlashSell,
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                  ),

                  /// Call a Grid variable, this is item list in Recomended item
                  Grid,
                ],
              ),
            ),

            /// Get a class AppbarGradient
            /// This is a Appbar in home activity
            AppbarGradient(),
          ],
        ),
      ),
    );
  }
}

/// ItemGrid in bottom item "Recomended" item
class ItemGrid extends StatelessWidget {
  /// Get data from HomeGridItem.....dart class
  GridItem gridItem;
  ItemGrid(this.gridItem);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) => new detailProduk(gridItem),

            transitionDuration: Duration(milliseconds: 500),

            /// Set animation Opacity in route to detailProduk layout
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            }));
      },
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
                /// Set Animation image to detailProduk layout
                Hero(
                  tag: "hero-grid-${gridItem.id}",
                  child: Material(
                    child: InkWell(
                      onTap: () {

                           Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) => new detailProduk(gridItem),

            transitionDuration: Duration(milliseconds: 500),

            /// Set animation Opacity in route to detailProduk layout
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return Opacity(
                opacity: animation.value,
                child: child,
              );
            }));
                        // Navigator.of(context).push(PageRouteBuilder(
                        //     opaque: false,
                        //     pageBuilder: (BuildContext context, _, __) {
                        //       return new Material(
                        //         color: Colors.black54,
                        //         child: Container(
                        //           padding: EdgeInsets.all(30.0),
                        //           child: InkWell(
                        //             child: Hero(
                        //                 tag: "hero-grid-${gridItem.id}",
                        //                 child: Image.network(
                        //                   gridItem.img,
                        //                   width: 300.0,
                        //                   height: 300.0,
                        //                   alignment: Alignment.center,
                        //                   fit: BoxFit.contain,
                        //                 )),
                        //             onTap: () {
                        //               Navigator.pop(context);
                        //             },
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //     transitionDuration: Duration(milliseconds: 500)));
                      },
                      child: Container(
                        height: mediaQueryData.size.height / 3.3,
                        width: 200.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(7.0),
                                topRight: Radius.circular(7.0)),
                            image: DecorationImage(
                                image: NetworkImage(gridItem.img),
                                fit: BoxFit.contain)),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 7.0)),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    gridItem.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        letterSpacing: 0.5,
                        color: Colors.black,
                        fontFamily: "Sans",
                        fontWeight: FontWeight.w700,
                        fontSize: 13.0),
                  )
                ),
                Padding(padding: EdgeInsets.only(top: 1.0)),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: <Widget>[
                      Text(
                       "₹ "+ gridItem.price,
                        style: TextStyle(
                            fontFamily: "Sans",
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0),
                      ),
                        Text(
                        gridItem.qty,
                        style: TextStyle(
                            fontFamily: "Sans",
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: <Widget>[
                //       Row(
                //         children: <Widget>[
                //           Text(
                //             // gridItem.rattingValue,
                //             gridItem.qty,
                //             style: TextStyle(
                //                 fontFamily: "Sans",
                //                 color: Colors.black26,
                //                 fontWeight: FontWeight.w500,
                //                 fontSize: 12.0),
                //           ),
                //           // Icon(
                //           //   Icons.star,
                //           //   color: Colors.yellow,
                //           //   size: 14.0,
                //           // )
                //         ],
                //       ),
                //       // Text(
                //       //   "",
                //       //   style: TextStyle(
                //       //       fontFamily: "Sans",
                //       //       color: Colors.black26,
                //       //       fontWeight: FontWeight.w500,
                //       //       fontSize: 12.0),
                //       // )
                //     ],
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Component FlashSaleItem
class flashSaleItem extends StatelessWidget {
  final String image;
  final String title;
  final String normalprice;
  final String discountprice;
  final String ratingvalue;
  final String place;
  final String stock;
  final int colorLine;
  final double widthLine;

  flashSaleItem(
      {this.image,
      this.title,
      this.normalprice,
      this.discountprice,
      this.ratingvalue,
      this.place,
      this.stock,
      this.colorLine,
      this.widthLine});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              // onTap: () {
              //   // Navigator.of(context).push(PageRouteBuilder(
              //   //     pageBuilder: (_, __, ___) => new flashSale(),
              //   //     transitionsBuilder:
              //   //         (_, Animation<double> animation, __, Widget child) {
              //   //       return Opacity(
              //   //         opacity: animation.value,
              //   //         child: child,
              //   //       );
              //   //     },
              //   //     transitionDuration: Duration(milliseconds: 850)));
              // },
              child: Container(
                height: 310.0,
                width: 145.0,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 140.0,
                      width: 145.0,
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 8.0, right: 8.0, top: 15.0),
                      child: Text(title,
                          style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Sans")),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0),
                      child: Text(normalprice,
                          style: TextStyle(
                              fontSize: 10.5,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Sans")),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0),
                      child: Text(discountprice,
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Color(0xFF7F7FD5),
                              fontWeight: FontWeight.w800,
                              fontFamily: "Sans")),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 5.0, right: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            size: 11.0,
                            color: Colors.yellow,
                          ),
                          Icon(
                            Icons.star,
                            size: 11.0,
                            color: Colors.yellow,
                          ),
                          Icon(
                            Icons.star,
                            size: 11.0,
                            color: Colors.yellow,
                          ),
                          Icon(
                            Icons.star,
                            size: 11.0,
                            color: Colors.yellow,
                          ),
                          Icon(
                            Icons.star_half,
                            size: 11.0,
                            color: Colors.yellow,
                          ),
                          Text(
                            ratingvalue,
                            style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Sans",
                                color: Colors.black38),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 5.0, right: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 11.0,
                            color: Colors.black38,
                          ),
                          Text(
                            place,
                            style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Sans",
                                color: Colors.black38),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 10.0, right: 10.0),
                      child: Text(
                        stock,
                        style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Sans",
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, left: 10.0, right: 10.0),
                      child: Container(
                        height: 5.0,
                        width: widthLine,
                        decoration: BoxDecoration(
                            color: Color(colorLine),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            shape: BoxShape.rectangle),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}

/// Component category item bellow FlashSale
class CategoryItemValue extends StatelessWidget {
  String image, title;
  GestureTapCallback tap;

  CategoryItemValue({
    this.image,
    this.title,
    this.tap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Container(
        height: 105.0,
        width: 160.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3.0)),
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
            color: Colors.black.withOpacity(0.25),
          ),
          child: Center(
              child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Berlin",
              fontSize: 20,
              letterSpacing: 0.7,
              fontWeight: FontWeight.w800,
            ),
          )),
        ),
      ),
    );
  }
}

/// Component item Menu icon bellow a ImageSlider
class CategoryIconValue extends StatelessWidget {
  String icon1, icon2, icon3, icon4, title1, title2, title3, title4;
  GestureTapCallback tap1, tap2, tap3, tap4;

  CategoryIconValue(
      {this.icon1,
      this.tap1,
      this.icon2,
      this.tap2,
      this.icon3,
      this.tap3,
      this.icon4,
      this.tap4,
      this.title1,
      this.title2,
      this.title3,
      this.title4});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: tap1,
          child: Column(
            children: <Widget>[
              Image.asset(
                icon1,
                height: 19.2,
              ),
              Padding(padding: EdgeInsets.only(top: 7.0)),
              Text(
                title1,
                style: TextStyle(
                  fontFamily: "Sans",
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: tap2,
          child: Column(
            children: <Widget>[
              Image.asset(
                icon2,
                height: 26.2,
              ),
              Padding(padding: EdgeInsets.only(top: 0.0)),
              Text(
                title2,
                style: TextStyle(
                  fontFamily: "Sans",
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: tap3,
          child: Column(
            children: <Widget>[
              Image.asset(
                icon3,
                height: 22.2,
              ),
              Padding(padding: EdgeInsets.only(top: 4.0)),
              Text(
                title3,
                style: TextStyle(
                  fontFamily: "Sans",
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: tap4,
          child: Column(
            children: <Widget>[
              Image.asset(
                icon4,
                height: 19.2,
              ),
              Padding(padding: EdgeInsets.only(top: 7.0)),
              Text(
                title4,
                style: TextStyle(
                  fontFamily: "Sans",
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

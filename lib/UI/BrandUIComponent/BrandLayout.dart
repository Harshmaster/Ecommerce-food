
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:kirana_app/ListItem/BrandDataList.dart';
import 'package:kirana_app/UI/BrandUIComponent/BrandDetail.dart';
import 'package:kirana_app/UI/BrandUIComponent/BrandsProducts.dart';
import 'package:kirana_app/UI/HomeUIComponent/Search.dart';
import 'package:kirana_app/colors.dart';
import 'package:shimmer/shimmer.dart';


bool loadImage = true;

class brand extends StatefulWidget {
       final FirebaseAnalytics analytics;
final FirebaseAnalyticsObserver observer;

brand({this.analytics,this.observer});
  @override
  _brandState createState() => _brandState();
}

class _brandState extends State<brand> {
// Future<Null> _sendAnalytics() async{
// await widget.analytics.logEvent(name: "Brand Screen Logged",
// parameters: <String,dynamic>{}
// );
// print("Brand Screen logged");
// }


@override
  void initState() {
    // TODO: implement initState
    // _sendAnalytics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// Component appbar
    var _appbar = AppBar(
      // backgroundColor: Color(0xFFFFFFFF),
      backgroundColor: ColorPlatte.themecolor,
      elevation: 0.0,
      title: Padding(
        padding: const EdgeInsets.only(left: 10.0,right: 10.0),
        child: Text(
          // AppLocalizations.of(context).tr('categoryBrand'),
          "Our Brands",
          style: TextStyle(
              fontFamily: "Gotik",
              fontSize: 20.0,
color: Colors.white,
              // color: Colors.black54,
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
    );

        var data = EasyLocalizationProvider.of(context).data;
        
    return EasyLocalizationProvider(
          data: data,
          child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Scaffold(
          /// Calling variable appbar
            appBar: _appbar,
            body: _imageLoaded(context),
            
            
           ),
      ),
    );
  }
}




///
///
/// Calling ImageLoaded animation for set layout
///
///
Widget _imageLoaded(BuildContext context){
  return  Container(
            color: Colors.white,
            child: SingleChildScrollView(
        child:
          StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection("brands")
                            // .where("isRecommended", isEqualTo: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {

                            return GridView.count(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 17.0,
                // childAspectRatio: 0.545,
                crossAxisCount: 2,
                primary: false,
                children: List.generate(
                  snapshot.data.documents.length,
                  (index) => SizedBox(
                    height: 50,
                    width: 50,
                                      child: BrandCardValue(title: snapshot.data.documents[index].data["brand_name"] ,
                    image: snapshot.data.documents[index].data["brand_img_url"],
                    tap: (){
                         Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) => new BrandsProductScreen(name: snapshot.data.documents[index].data["brand_name"],),
         ));
                    },
                    ),
                  )
                ));

                            
                      // return    ListView.builder(
                      //         shrinkWrap: true,
                      //         itemCount: snapshot.data.documents.length,
                      //         itemBuilder: (context, index) {
                               
                      
                      //           return Padding(padding: EdgeInsets.all(8),
                      //           child: Text(snapshot.data.documents[index].data["brand_name"]),
                                 
                      //           );
                      //         },
                      //       );
                          } else {
                            return Center(
                     
                            );
                          }
                        }),
        ),
            
            
            //  CustomScrollView(
            //   /// Create List Menu
            //   slivers: <Widget>[
            //     SliverPadding(
            //       padding: EdgeInsets.only(top: 0.0),
            //       sliver: SliverFixedExtentList(
            //           itemExtent: 145.0,
            //           delegate: SliverChildBuilderDelegate(
            //             /// Calling itemCard Class for constructor card
            //                   (context, index) => itemCard(brandData[index]),
            //               childCount: brandData.length)),
            //     ),
            //   ],
            // ),
          );
}



/// Constructor for itemCard for List Menu
// class itemCard extends StatefulWidget {
//    /// Declaration and Get data from BrandDataList.dart
//  final  Brand brand;
//   itemCard(this.brand);

//   _itemCardState createState() => _itemCardState(brand);
// }

// class _itemCardState extends State<itemCard> {
//     final Brand brand;

// _itemCardState(this.brand);
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:
//       const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
//       child: InkWell(
//         onTap: () {

          
//           Navigator.of(context).pushAndRemoveUntil(
//             PageRouteBuilder(
//                 pageBuilder: (_, __, ___) => new brandDetail(brand),
//                 transitionDuration: Duration(milliseconds: 600),
//                 transitionsBuilder:
//                     (_, Animation<double> animation, __, Widget child) {
//                   return Opacity(
//                     opacity: animation.value,
//                     child: child,
//                   );
//                 }),
//                 (Route<dynamic> route) => true
//           );
//         },
//         child: Container(
//           // height: 130.0,
//           height: 200,
//           width: 400.0,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(15.0))),
//           child: Hero(         
//             tag: 'hero-tag-${brand.id}',
//             transitionOnUserGestures: true,
//             child: Material(
//               child: DecoratedBox(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                   image: DecorationImage(
//                       image: AssetImage(brand.img), fit: BoxFit.cover),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color(0xFFABABAB).withOpacity(0.3),
//                       blurRadius: 1.0,
//                       spreadRadius: 2.0,
//                     ),
//                   ],
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                     color: Colors.black12.withOpacity(0.1),
//                   ),
//                   child: Center(
//                     child: Text(
//                       brand.name,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontFamily: "Berlin",
//                         fontSize: 35.0,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


class BrandCardValue extends StatelessWidget {
  String image, title;
  GestureTapCallback tap;

  BrandCardValue({
    this.image,
    this.title,
    this.tap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Container(
        height: 90.0,
        width: 60.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3.0)),
          border: Border.all(width: 1)
          // image: DecorationImage(image: NetworkImage(image), fit: BoxFit.contain),
        ),
        child: Container(
      
          padding: EdgeInsets.all(40),
          decoration: BoxDecoration(
            //  color: Colors.red,
              image: DecorationImage(
                   
                image: NetworkImage(image), fit: BoxFit.contain),
          ),
                  child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
              // color: Colors.black.withOpacity(0.20),
            ),
            // child: Center(
            //     child: Text(
            //   title,
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontFamily: "Berlin",
            //     fontSize: 20,
            //     letterSpacing: 0.7,
            //     fontWeight: FontWeight.w800,
            //   ),
            // )),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:kirana_app/ListItem/HomeGridItemRecomended.dart';
import 'package:kirana_app/UI/HomeUIComponent/DetailProduct.dart';

class searchAppbar extends StatefulWidget {
  @override
  _searchAppbarState createState() => _searchAppbarState();
}

class _searchAppbarState extends State<searchAppbar> {
  @override
  List<SearchProduct> allProductList = List();
  String query = "";
  @override
  void initState() {
    super.initState();
    getInitialData();
  }

  buildSuggestions(String query) {
    final List<SearchProduct> suggestionList = query.isEmpty
        ? []
        : allProductList.where((SearchProduct product) {
            String _query = query.toLowerCase();
            String _getName = product.name.toLowerCase();
            // bool matchesUsername = _getUsername.contains(_query);
            bool matchesName = _getName.contains(_query);

            return (matchesName);

            // (User user) => (user.username.toLowerCase().contains(query.toLowerCase()) ||
            //     (user.name.toLowerCase().contains(query.toLowerCase()))),
          }).toList();

    return Container(
      height: MediaQuery.of(context).size.height - 260,
      child: ListView.builder(
        
        itemCount: suggestionList.length,
        itemBuilder: ((context, index) {
          SearchProduct searchedproduct = SearchProduct(
              id: suggestionList[index].id,
              name: suggestionList[index].name,
              image: suggestionList[index].image,
              price: suggestionList[index].price,
              size: suggestionList[index].size);

          return InkWell(
onTap: (){
     Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) => detailProduk(GridItem(id: searchedproduct.id,title: searchedproduct.name,img: searchedproduct.image,price: searchedproduct.price,category: searchedproduct.name,qty: searchedproduct.size,vendor_name: searchedproduct.vendor))));
          
          },
                      child: Container(
              child: ListTile(
                title: Text(searchedproduct.name),
                subtitle: Text(searchedproduct.price),
                trailing: Text(searchedproduct.size),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.network(searchedproduct.image,fit: BoxFit.fill,),
                ),
              ),
            )),
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
      ),
    );
  }

  getInitialData() {
    List<SearchProduct> productList = List();
    Firestore.instance
        .collection("products")
        .getDocuments()
        .then((querySnapshot) {
      for (var i = 0; i < querySnapshot.documents.length; i++) {
        productList.add(SearchProduct.fromMap(querySnapshot.documents[i].data));
      }
      setState(() {
        allProductList = productList;
      });
    });
  }

  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;

  // handleSearch(String query) {
  //   print("object");
  //   Future<QuerySnapshot> products = Firestore.instance.collection("products")
  //       .where("product_name", isGreaterThanOrEqualTo: query.toUpperCase())
  //       .getDocuments();
  //   setState(() {
  //     searchResultsFuture = products;
  //   });
  // }

  clearSearch() {
    searchController.clear();
  }

  // Widget buildSearchResults() {
  //   return Container(
  //     height: 300,
  //     child: FutureBuilder(
  //       future: searchResultsFuture,
  //       builder: (context, snapshot) {
  //         if (!snapshot.hasData) {
  //           return CircularProgressIndicator();
  //         }
  //         List<Text> searchResults = [];
  //         snapshot.data.documents.forEach((doc) {
  //           // User user = User.fromDocument(doc);
  //           searchResults.add(Text(doc["product_name"]));
  //           print(doc["product_name"]);
  //         });
  //         return ListView(
  //           children: searchResults,
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    /// Sentence Text header "Hello i am Treva.........."
    var _textHello = Padding(
      padding: const EdgeInsets.only(right: 50.0, left: 20.0),
      child: Container(
        height: 70,
        child: Text(
          // AppLocalizations.of(context).tr('searchHello'),
          "Hello, What are you looking for??",
          style: TextStyle(
              letterSpacing: 0.1,
              fontWeight: FontWeight.w600,
              fontSize: 27.0,
              color: Colors.black54,
              fontFamily: "Gotik"),
        ),
      ),
    );

    /// Item TextFromField Search
    var _search = Padding(
      padding: const EdgeInsets.only(top: 35.0, right: 20.0, left: 20.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15.0,
                  spreadRadius: 0.0)
            ]),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: Theme(
              data: ThemeData(hintColor: Colors.transparent),
              child: TextFormField(
                // onFieldSubmitted: handleSearch(searchController.text),
                onChanged: (val) {
                  setState(() {
                    query = val;
                  });
                },
                controller: searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.search,
                    color: Color(0xFF6991C7),
                    size: 28.0,
                  ),
                  hintText:
                      // AppLocalizations.of(context).tr('findYouWant'),
                      "Search your product",
                  hintStyle: TextStyle(
                      color: Colors.black54,
                      fontFamily: "Gotik",
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    /// Item Favorite Item with Card item
    // var _favorite = Padding(
    //   padding: const EdgeInsets.only(top: 20.0),
    //   child: Container(
    //     height: 250.0,
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         Padding(
    //           padding: const EdgeInsets.only(left: 20.0, right: 20.0),
    //           child: Text(
    //             // AppLocalizations.of(context).tr('favorite'),
    //             "favorite",
    //             style: TextStyle(fontFamily: "Gotik", color: Colors.black26),
    //           ),
    //         ),
    //         Expanded(
    //           child: ListView(
    //             padding: EdgeInsets.only(top: 20.0, bottom: 2.0),
    //             scrollDirection: Axis.horizontal,
    //             children: <Widget>[
    //               /// Get class FavoriteItem
    //               Padding(padding: EdgeInsets.only(left: 20.0)),
    //               FavoriteItem(
    //                 image: "assets/imgItem/shoes1.jpg",
    //                 title:
    //                     //  AppLocalizations.of(context).tr('productTitle1'),
    //                     "productTitle1",
    //                 Salary: "\$ 10",
    //                 Rating: "4.8",
    //                 sale:
    //                     // AppLocalizations.of(context).tr('productSale1'),
    //                     "2",
    //               ),
    //               Padding(padding: EdgeInsets.only(left: 20.0)),
    //               FavoriteItem(
    //                 image: "assets/imgItem/acesoris1.jpg",
    //                 title:
    //                     // AppLocalizations.of(context).tr('productTitle2'),
    //                     "productTitle1",
    //                 Salary: "\$ 200",
    //                 Rating: "4.2",
    //                 sale:
    //                     // AppLocalizations.of(context).tr('productSale2'),
    //                     "33",
    //               ),
    //               Padding(padding: EdgeInsets.only(left: 20.0)),
    //               FavoriteItem(
    //                   image: "assets/imgItem/kids1.jpg",
    //                   title:
    //                       // AppLocalizations.of(context).tr('productTitle3'),
    //                       "productTitle1",
    //                   Salary: "\$ 3",
    //                   Rating: "4.8",
    //                   sale:
    //                       // AppLocalizations.of(context).tr('productSale3'),
    //                       "33"),
    //               Padding(padding: EdgeInsets.only(right: 10.0)),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    /// Popular Keyword Item
    // var _sugestedText = Container(
    //   height: 145.0,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       Padding(
    //         padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
    //         child: Text(
    //           // AppLocalizations.of(context).tr('popularity'),
    //           "Popularity",

    //           style: TextStyle(fontFamily: "Gotik", color: Colors.black26),
    //         ),
    //       ),
    //       Padding(padding: EdgeInsets.only(top: 20.0)),
    //       Expanded(
    //           child: ListView(
    //         scrollDirection: Axis.horizontal,
    //         children: <Widget>[
    //           Padding(padding: EdgeInsets.only(left: 20.0)),
    //           KeywordItem(
    //             title: "Surf",
    //             title2: "MAggi",
    //           ),
    //           KeywordItem(
    //             title: "Surf",
    //             title2: "MAggi",
    //           ),
    //           KeywordItem(
    //             title: "Surf",
    //             title2: "MAggi",
    //           ),
    //           KeywordItem(
    //             title: "Surf",
    //             title2: "MAggi",
    //           ),
    //         ],
    //       ))
    //     ],
    //   ),
    // );

    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Search",
            style: TextStyle(
                fontFamily: "Sans",
                fontSize: 19.0,
                fontWeight: FontWeight.w500,
                color: Colors.black54),
          ),
          iconTheme: IconThemeData(color: Color(0xFF6991C7)),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /// Caliing a variable
                  _textHello,
                  _search,
                  // _sugestedText,
                  // _favorite,
                  // Padding(padding: EdgeInsets.only(bottom: 30.0, top: 2.0)),
                  // buildSearchResults(),
                  buildSuggestions(query)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchProduct {
  String id;
  String name;
  String image;
  String price;
  String size;

  String vendor;

  SearchProduct({
    this.id,
    this.name,
    this.image,
    this.price,
    this.size,
    this.vendor,
  
  });

  Map toMap(SearchProduct user) {
    var data = Map<String, dynamic>();
    data['product_id'] = user.id;
    data['product_name'] = user.name;
    data['product_image_url'] = user.image;
    data['product_price'] = user.price;
    data["product_size"] = user.size;
    data["product_vendor"] = user.vendor;

    return data;
  }

  SearchProduct.fromMap(Map<String, dynamic> mapData) {
    this.id = mapData['product_id'];
    this.name = mapData['product_name'];
    this.price = mapData['product_price'];
    this.image = mapData['product_image_url'];
    this.size = mapData['product_size'];
    this.vendor = mapData["product_vendor"];
  }
}

/// Popular Keyword Item class
class KeywordItem extends StatelessWidget {
  @override
  String title, title2;

  KeywordItem({this.title, this.title2});

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 3.0),
          child: Container(
            height: 29.5,
            width: 90.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.5,
                  spreadRadius: 1.0,
                )
              ],
            ),
            child: Center(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black54, fontFamily: "Sans"),
              ),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 15.0)),
        Container(
          height: 29.5,
          width: 90.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4.5,
                spreadRadius: 1.0,
              )
            ],
          ),
          child: Center(
            child: Text(
              title2,
              style: TextStyle(
                color: Colors.black54,
                fontFamily: "Sans",
              ),
            ),
          ),
        ),
      ],
    );
  }
}

///Favorite Item Card
class FavoriteItem extends StatelessWidget {
  String image, Rating, Salary, title, sale;

  FavoriteItem({this.image, this.Rating, this.Salary, this.title, this.sale});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
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
                  height: 120.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7.0),
                          topRight: Radius.circular(7.0)),
                      image: DecorationImage(
                          image: AssetImage(image), fit: BoxFit.cover)),
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

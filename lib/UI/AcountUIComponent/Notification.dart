import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:kirana_app/ListItem/notificationsData.dart';
import 'package:kirana_app/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:treva_shop_flutter/ListItem/notificationsData.dart';

class notification extends StatefulWidget {
  @override
  _notificationState createState() => _notificationState();
}

class _notificationState extends State<notification> {
String userId;
  getid()async{

   SharedPreferences prefs =  await SharedPreferences.getInstance();
   setState(() {
     userId = prefs.getString("userId");
   });

}



  // final List<Post> items = new List();
  @override
  void initState() {
    super.initState();
    getid();
    // setState(() {
    //   items.add(  Post(
    //       image:"assets/img/Logo.png",
    //       id: 1,
    //       title:"Treva Shop",
    //       desc: "Thanks for downloaded treva shop application"),);
    //   items.add( Post(
    //       image:"assets/img/Logo.png",
    //       id: 2,
    //       title:"Treva Shop",
    //       desc: "Your Item Delivery"),);
    //   items.add( Post(
    //       image:"assets/img/Logo.png",
    //       id: 3,
    //       title:"Treva Shop",
    //       desc: "Pending List Item Shoes"),);
    //   items.add( Post(
    //       image:"assets/img/Logo.png",
    //       id: 4,
    //       title:"Treva Shop",
    //       desc: "Get 10% Discount for macbook pro 2018"),);
    // });
  }

  Widget build(BuildContext context) {
        var data = EasyLocalizationProvider.of(context).data;
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return EasyLocalizationProvider(
          data: data,
          child: Scaffold(
        backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              // AppLocalizations.of(context).tr('notification'),
              "Notification",
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
            // backgroundColor: Colors.white,
            backgroundColor: ColorPlatte.themecolor
          ),
          body:  StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection("users")
                            .document(userId)
                            .collection("notification")
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {


                            if(snapshot.data.documents.length >0){
                                return  ListView.builder(
              itemCount: snapshot.data.documents.length,
              padding: const EdgeInsets.all(5.0),
              itemBuilder: (context, position) {
                return Dismissible(
                    key: Key(snapshot.data.documents[position].documentID),
                    onDismissed: (direction) {
                      // setState(() {
                      //   items.removeAt(position);
                      // });
                    },
                    background: Container(
                      color: Color(0xFF6991C7),
                    ),
                    child: Container(
                      height: 88.0,
                      child: Column(
                        children: <Widget>[
                          Divider(height: 5.0),
                          ListTile(
                            title: Text(
                              snapshot.data.documents[position].data["title"],
                              style: TextStyle(
                                  fontSize: 17.5,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top:6.0),
                              child: Container(
                                width: 440.0,
                                child: Text(
                                  snapshot.data.documents[position].data["desc"],
                                  style: new TextStyle(
                                      fontSize: 15.0,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black38
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            leading: Column(
                              children: <Widget>[
                                Container(
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(60.0)),
                                      image: DecorationImage(image: AssetImage("assets/img/Logo.png"),fit: BoxFit.cover)
                                  ),
                                )
                              ],
                            ),
                            // onTap: () => _onTapItem(context, items[position]),
                          ),
                          Divider(height: 5.0),
                        ],
                      ),
                    ));
              });
                            }else{
                              return noItemNotifications();
                            }
                          
                          
                          }
                          
                          else {
                            return noItemNotifications();
                          }
                        }),
          
          
          // items.length>0?
          // ListView.builder(
          //     itemCount: items.length,
          //     padding: const EdgeInsets.all(5.0),
          //     itemBuilder: (context, position) {
          //       return Dismissible(
          //           key: Key(items[position].id.toString()),
          //           onDismissed: (direction) {
          //             setState(() {
          //               items.removeAt(position);
          //             });
          //           },
          //           background: Container(
          //             color: Color(0xFF6991C7),
          //           ),
          //           child: Container(
          //             height: 88.0,
          //             child: Column(
          //               children: <Widget>[
          //                 Divider(height: 5.0),
          //                 ListTile(
          //                   title: Text(
          //                     '${items[position].title}',
          //                     style: TextStyle(
          //                         fontSize: 17.5,
          //                         color: Colors.black87,
          //                         fontWeight: FontWeight.w600
          //                     ),
          //                   ),
          //                   subtitle: Padding(
          //                     padding: const EdgeInsets.only(top:6.0),
          //                     child: Container(
          //                       width: 440.0,
          //                       child: Text(
          //                         '${items[position].desc}',
          //                         style: new TextStyle(
          //                             fontSize: 15.0,
          //                             fontStyle: FontStyle.italic,
          //                             color: Colors.black38
          //                         ),
          //                         overflow: TextOverflow.ellipsis,
          //                       ),
          //                     ),
          //                   ),
          //                   leading: Column(
          //                     children: <Widget>[
          //                       Container(
          //                         height: 40.0,
          //                         width: 40.0,
          //                         decoration: BoxDecoration(
          //                             borderRadius: BorderRadius.all(Radius.circular(60.0)),
          //                             image: DecorationImage(image: AssetImage('${items[position].image}'),fit: BoxFit.cover)
          //                         ),
          //                       )
          //                     ],
          //                   ),
          //                   onTap: () => _onTapItem(context, items[position]),
          //                 ),
          //                 Divider(height: 5.0),
          //               ],
          //             ),
          //           ));
          //     })
          //     :noItemNotifications()
      ),
    );
  }
}
void _onTapItem(BuildContext context, Post post) {
  Scaffold
      .of(context)
      .showSnackBar(new SnackBar(content: new Text(post.id.toString() + ' - ' + post.title)));
}
class noItemNotifications extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return  Container(
      width: 500.0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding:
                EdgeInsets.only(top: mediaQueryData.padding.top + 100.0)),
            Image.asset(
              "assets/img/noNotification.png",
              height: 200.0,
            ),
            Padding(padding: EdgeInsets.only(bottom: 30.0)),
            Text(
              // AppLocalizations.of(context).tr('notHaveNotification'),
              "No Notification",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.5,
                  color: Colors.black54,
                  fontFamily: "Gotik"),
            ),
          ],
        ),
      ),
    );
  }
}



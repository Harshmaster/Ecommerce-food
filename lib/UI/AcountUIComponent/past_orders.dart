import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kirana_app/UI/AcountUIComponent/order_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PastOrderScreen extends StatefulWidget {
  @override
  _PastOrderScreenState createState() => _PastOrderScreenState();
}

class _PastOrderScreenState extends State<PastOrderScreen> {


String userId;
  
getid()async{

   SharedPreferences prefs =  await SharedPreferences.getInstance();
   setState(() {
     userId = prefs.getString("userId");
   });
print(userId);
}

@override
  void initState() {
    // TODO: implement initState
    getid();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              // AppLocalizations.of(context).tr('notification'),
              "Past Orders",
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
          body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("orders")

        .where("user_id",isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                int tempcount = snapshot.data.documents[index].data["order_count"];
                int tempamount = snapshot.data.documents[index].data["order_amount"];
                   String temporderId = snapshot.data.documents[index].data["order_id"];
                    String tempvendor = snapshot.data.documents[index].data["order_vendor"];
                      String temp = snapshot.data.documents[index].data["user_name"];
                           String status = snapshot.data.documents[index].data["status"];
              
                return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    margin: EdgeInsets.all(10),
                    child: Material(
                       elevation: 1,
                       
                                          child: InkWell(
                                                            
                                                            onTap: (){
                                                                 Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => new OrderDetails(orderId: temporderId,)));
                                                            },
                                                                                      child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(left: BorderSide(color: Colors.redAccent,width: 7))
                                              ),
                        height: 120,
                        
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
Padding(
  padding: const EdgeInsets.only(top: 4),
  child:   Text("Id: "+temporderId,textAlign: TextAlign.right,style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "gotik"),),
),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: <Widget>[
 Container(
   padding: EdgeInsets.only(top: 20),
   height: 70,
   child: Column(
     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
     children: <Widget>[
       Text(tempcount.toString() + " Items",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,fontFamily: "gotik"),),
         Text(tempamount.toString() + " Amount"),
          Text(tempvendor.toString()),

     ],
   ),
 ) ,
 Container(
   
    padding: EdgeInsets.only(top: 20),
   height: 70,
   child: Column(
     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
     children: <Widget>[
       Container(
         padding: EdgeInsets.all(3),
         decoration: BoxDecoration(
           border: Border.all(width: 2,color: Colors.green)
         ),
         child: Text(status.toUpperCase(),style: TextStyle(fontWeight: FontWeight.w800, color: Colors.green,fontFamily: "gotik"),)),
       Text("cash".toUpperCase(),style: TextStyle(fontWeight: FontWeight.w800, color: Colors.green,fontFamily: "gotik"),)  
     ],
   ),
 )  ,
 
  ],
)
// Text(tempcount.toString() + " Items Ordered from Quality Store for " + tempamount.toString())


                          ],
                        ),
                      ),
                                          ),
                    ));
              },
            );
          } else {
            return Container(
              child: Text("No data"),
            );
          }
        })
    );
  }
}
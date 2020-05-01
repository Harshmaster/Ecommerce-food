import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class chatItem extends StatefulWidget {
  @override
  _chatItemState createState() => _chatItemState();
}

/// defaultUserName use in a Chat name
const String defaultUserName = "Alisa Hearth";

class _chatItemState extends State<chatItem> with TickerProviderStateMixin {
  String username;
  String userId;
  getprefab() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("name");
      userId = prefs.getString("userId");
    });
  }

  final List<Msg> _messages = <Msg>[];

  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false;
  static String custommsg;
  @override
  void initState() {
    // TODO: implement initState
    getprefab();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // custommsg = widget.message.toString();
    var data = EasyLocalizationProvider.of(context).data;
    return EasyLocalizationProvider(
      data: data,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.4,
          title: Text(
            //  AppLocalizations.of(context).tr('chatting'),
            "Customer Care Chat",
            style: TextStyle(
                fontFamily: "Gotik", fontSize: 18.0, color: Colors.black54),
          ),
          iconTheme: IconThemeData(color: Color(0xFF6991C7)),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),

        /// body in chat like a list in a message
        body: Container(
          color: Colors.white,
          child: new Column(children: <Widget>[
            new Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("chat_rooms")
                        .document(userId)
                        .collection("chats")
                        .orderBy("time")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.documents.length > 0) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                return ChatMessage(
                                    snapshot.data.documents[index].data["text"],
                                    "2:30",
                                    snapshot
                                        .data.documents[index].data["isUser"]);

                                //   Container(

                                // padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                //     child: Text(snapshot
                                //         .data.documents[index].data["text"],style: TextStyle(
                                //           fontSize: 20
                                //         ),),
                                //   );
                              });
                        } else {
                          return NoMessage();
                        }
                      } else {
                        return NoMessage();
                      }
                    })),

            // _messages.length > 0
            //     ? Container(
            //         child: new ListView.builder(
            //           itemBuilder: (_, int index) => _messages[index],
            //           itemCount: _messages.length,
            //           reverse: true,
            //           padding: new EdgeInsets.all(10.0),
            //         ),
            //       )
            //     : NoMessage(),

            /// Line
            new Divider(height: 1.5),
            new Container(
              child: _buildComposer(),
              decoration: new BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(blurRadius: 1.0, color: Colors.black12)
                  ]),
            ),
          ]),
        ),
      ),
    );
  }

  /// Component for typing text
  Widget _buildComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 10),
          child: new Row(
            children: <Widget>[
              // Icon(
              //   Icons.add,
              //   color: Colors.blueAccent,
              //   size: 27.0,
              // ),
              new Flexible(
                child: Container(
                  // margin: EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new TextField(
                          controller: _textController,
                          onChanged: (String txt) {
                            setState(() {
                              _isWriting = txt.length > 0;
                            });
                          },
                          onSubmitted: _submitMsg,
                          decoration: new InputDecoration(
                              hintText:
                                  // AppLocalizations.of(context).tr('hintChat'),
                                  "Please tell us about your issue...",
                              hintStyle: TextStyle(
                                  fontFamily: "Sans",
                                  fontSize: 16.0,
                                  color: Colors.black26)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? new CupertinoButton(
                          child: new Text("Submit"),
                          onPressed: _isWriting
                              ? () => _submitMsg(_textController.text)
                              : null)
                      : new IconButton(
                          icon: new Icon(Icons.send),
                          onPressed: _isWriting
                              ? () => _submitMsg(_textController.text)
                              : null,
                        )),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border: new Border(top: new BorderSide(color: Colors.brown)))
              : null),
    );
  }

  void _submitMsg(String txt) async {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
//     String roomId;
// DocumentSnapshot doc =  await Firestore.instance.collection("rooms").document(userId).get();
// if(doc.exists){
// roomId = doc["roomId"];
//    Firestore.instance.collection("chats").add({
//      "roomId": roomId,
//       "text": txt,
//       "time": DateTime.now(),
//       "sender": "customer",
//       "userid": userId
//    });
// }else{

// }
    var doc = await Firestore.instance
        .collection("chat_rooms")
        .document(userId)
        .get();

    if (doc.exists) {
      Firestore.instance
          .collection("chat_rooms")
          .document(userId)
          .collection("chats")
          .add({
        "text": txt,
        "sender": userId,
        "time": DateTime.now(),
        "user_name": username,
        "isUser": true
      }).then((onValue) {
        print("Sent!");
      });
    } else {
      print("First time chat");
      Firestore.instance.collection("chat_rooms").document(userId).setData({
        "userId": userId,
        "user_name": username,
        "first_timestamp": DateTime.now(),
        "isUser": true,
        "sender":"admin"
      });

      Firestore.instance
          .collection("chat_rooms")
          .document(userId)
          .collection("chats")
          .add({
        "text": txt,
        "sender": userId,
        "time": DateTime.now(),
         "isUser": true,
      }).then((onValue) {
        print("Sent!");
      });
    }

    // Msg msg = new Msg(
    //   txt: txt,
    //   animationController: new AnimationController(
    //       vsync: this, duration: new Duration(milliseconds: 800)),
    // );
    // setState(() {
    //   _messages.insert(0, msg);
    // });
    // msg.animationController.forward();
  }

  @override
  void dispose() {
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  final String text, time;
  bool isCurrentUser;
  ChatMessage(this.text, this.time, this.isCurrentUser);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: isCurrentUser ? Colors.blueAccent : Colors.blue,
              // color: Colors.green[300],
            ),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Msg extends StatelessWidget {
  Msg({this.txt, this.animationController});

  final String txt;
  final AnimationController animationController;

  @override
  Widget build(BuildContext ctx) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.fastOutSlowIn),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Expanded(
              child: Padding(
                padding: const EdgeInsets.all(00.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(1.0),
                            bottomLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                            topLeft: Radius.circular(20.0)),
                        color: Color(0xFF6991C7).withOpacity(0.6),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: new Text(
                        txt,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
//            new Container(
//              margin: const EdgeInsets.only(right: 5.0,left: 10.0),
//              child: new CircleAvatar(
//                backgroundImage: AssetImage("assets/avatars/avatar-1.jpg"),
////                  backgroundColor: Colors.indigoAccent,
////                  child: new Text(defaultUserName[0])),
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}

class NoMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Center(
              child: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    "assets/imgIllustration/IlustrasiMessage.png",
                    height: 220.0,
                  )),
            ),
          ),
          Center(
              child: Text(
            // AppLocalizations.of(context).tr('notHaveMessage'),
            "No message",
            style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black12,
                fontSize: 17.0,
                fontFamily: "Popins"),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Center(
                child: Text(
              // AppLocalizations.of(context).tr('notHaveMessage'),
              "Please drop a text in case of any issue/query",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black12,
                  fontSize: 17.0,
                  fontFamily: "Popins"),
            )),
          ),
        ],
      ),
    ));
  }
}

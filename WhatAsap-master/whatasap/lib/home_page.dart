import 'package:flutter/material.dart';
import './session.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import './conversation.dart';
import './login_page.dart';
import './create_conversation.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _HomePageState();
  }
}



class _HomePageState extends State<HomePage> {

  List _allConversations;
  List allConversations;
  String allConversationsUrl = '$ipaddress/AllConversations';
  bool dataLoaded = true;
  Session session = new Session();

  @override
  void initState() {
    if(id == ''){
      Navigator.of(context).pushNamed(LoginPage.tag);
    }

    Future<String> response = session.get(allConversationsUrl);
    response.then((s) => 
      (decodeResponse(s))
    ).catchError((e)=>print('$e'));
    super.initState();
  }

  void decodeResponse(String s) {
    sleep(
      Duration(
        seconds: 2
      )
    );
    
    _allConversations = json.decode(s)['data'];
    
    setState(() {
      dataLoaded = false;
      allConversations = _allConversations;
    });
    allConversations = json.decode(s)['data'];
    print(allConversations);
  }

  void _onclickChat(String oid, String oName){
    otherId = oid;
    otherName = oName;
    Navigator.of(context).pushNamed(Conversation.tag);
  }

  void _onClickHome(){
    Navigator.of(context).pushNamed(HomePage.tag);
  }

  void _createConversation(){
    Navigator.of(context).pushNamed(CreateConversation.tag);
  }

  void _onClickExit() {
    Future<String> response = session.get('$ipaddress/LogoutServlet');
    response.then((s) => 
      (decodeLogoutResponse(s))
    ).catchError((e)=>print('$e'));
  }

  void decodeLogoutResponse(String s) {
    var logoutResponse = json.decode(s)['status'];
    if(logoutResponse == true){
      id = '';
      Navigator.of(context).pushNamed(LoginPage.tag);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final appbar = Padding(
      padding: EdgeInsets.all(8.0),
      
      child: Row(
        children:[
          Text(
            'Chats',
            style: TextStyle(fontSize: 28.0, color: Colors.white),
          ),
          Container(width: 30.0, height: 0.0),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
              IconButton(
                icon: new Icon(Icons.home),
                onPressed: () => _onClickHome(),
              ),
              IconButton(
                icon: new Icon(Icons.create),
                onPressed: () => _createConversation(),
              ),
              IconButton(
                icon: new Icon(Icons.exit_to_app),
                onPressed: () => _onClickExit(),
              ),
              ]
            )
          ),
        ],
      )
    );

    // final body = 
    return Scaffold(
      appBar: AppBar(
        title: appbar,
        // automaticallyImplyLeading: false,
      ),
      body: dataLoaded? Center(
        child: Text('Loading AllConversations')
      ):
        Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(2.0, 20.0, 2.0, 0.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.blue,
            Colors.white,
          ]),
        ),
        child: Column(
          children: [
            TextField(
              onChanged: (val){
                List<dynamic> l = new List();
                _allConversations.forEach(
                  (f){
                    if (f['uid'].toString().toLowerCase().contains(val.trim().toLowerCase()) || f['name'].toString().toLowerCase().contains(val.trim().toLowerCase())) {
                      l.add(f);
                    }
                  }
                );
                
                // setState(() {
                setState(() {
                  allConversations = l;
                });
                // });
              },
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                fillColor: Colors.white,
                hintText: 'Search...',
              ),
            ),
            Container(width: 0.0, height: 20.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children:(allConversations.length == 0)?
                  [
                    Text("No Result Found"),
                  ]
                  :
                  allConversations
                  .map((element) => Card(
                    child : RaisedButton(
                      child: Row(
                        children: <Widget>[
                          Container(width: 10.0, height: 0.0),
                          Icon(Icons.account_circle, size:50.0,),
                          Container(width: 22.0, height: 0.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: new Text(
                                    element['name'].toString(),
                                    style: new TextStyle(
                                      fontSize: 35.0,
                                      fontFamily: 'Roboto',
                                      color: Colors.green,
                                    ), 
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Text(
                                  (element['last_timestamp'] == null)? '' :element['last_timestamp'].toString().substring(0, 19), 
                                  textAlign: TextAlign.left,
                                  style: new TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                              ]
                            ),
                          ),
                          Text(
                            element['uid'], 
                            // textAlign: TextAlign.center,
                            style: new TextStyle(
                              fontSize: 30.0,
                            ),
                          ),
                          Container(width: 20.0, height: 0.0),
                        ],
                      ),
                      onPressed:() => _onclickChat(element['uid'], element['name']),// _onclickChat(element['uid']),
                    ),
                ),)
                .toList(),
              ),
            ),
            // Text('anshu'),
          ],
        )
        
      )
    );
  }
}
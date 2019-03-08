library flutter_typeahead;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './home_page.dart';
import './login_page.dart';
import './conversation.dart';
import './session.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';


class CreateConversation extends StatefulWidget {
  static String tag = 'create-conversation';
  @override
  _CreateConversationNewState createState() => new _CreateConversationNewState();
}

class _CreateConversationNewState extends State<CreateConversation> {

  final String url = '$ipaddress/CreateConversation?other_id=$otherId';
  final TextEditingController _controller = new TextEditingController();
  List autoCompleteData;
  List _autoCompleteData;
  Session session = new Session();
  // String _newID;

  @override
  void initState() {
    if(id == ''){
      Navigator.of(context).pushNamed(LoginPage.tag);
    }
    super.initState();
  }

  void _onClickHome(){
    Navigator.of(context).pushNamed(HomePage.tag);
  }

  void _createConversationNew(){
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

  void _getAutoComplete(String s){
    Future<String> response = session.get('$ipaddress/AutoCompleteUser?term=$s');
    response.then((s) => 
      (decodeAutoCompleteResponse(s))
    ).catchError((e)=>print('$e'));
  }

  void decodeAutoCompleteResponse(s){
    
    setState(() {
      autoCompleteData = json.decode(s);
    });
    print(autoCompleteData);
    _autoCompleteData = new List();
    _autoCompleteData = autoCompleteData;
  }

  void _createNewConversation(){
    String data = _controller.text;
    String othID = "";
    String othName = "";
    int i = 0;
    while(data[i] != ':'){
      i++;
    }
    i += 2;
    while(data[i] != ','){
      othID += data[i];
      i++;
    }
    i+=2;
    while(data[i] != ':'){
      i++;
    }
    i += 2;
    while(data[i] != ','){
      othName += data[i];
      i++;
    }
    print(othName);
    if(othID.toString() == id)
      return;
    otherName = othName;
    // Future<String> response = session.get('$ipaddress/CreateConversation?other_id=newID');
    Future<String> response = session.get('$ipaddress/ConversationDetail?other_id=$othID');
    response.then((s) => 
      (conversationResonse(s, othID))
    ).catchError((e)=>print('$e'));
  }

  void setvalue(v, x){
    otherId = v.toString();
    _controller.text = x;
  }

  void conversationResonse(s, newID){
    Map map = json.decode(s);
    bool status = map['status'];
    List data = map['data'];
    print('one$s $newID 23ert');
    if(data == null || data.length == 0){
      Future<String> response = session.get('$ipaddress/CreateConversation?other_id=$newID');
      response.then((s1) => 
        (newConversation(s1, newID))
      ).catchError((e)=>print('$e'));
    }
    else{
      setState(() {
        otherId = newID.toString();
      });
      otherId = newID.toString();
      print(otherId);
      Navigator.of(context).pushNamed(Conversation.tag);
    }
  }

  void newConversation(s1, newID){
    print(s1);
    Map map = json.decode(s1);
    bool status = map['status'];
    if(status){
      setState(() {
        otherId = newID.toString();
      });
      otherId = newID.toString();
      Navigator.of(context).pushNamed(Conversation.tag);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appbar = Padding(
      padding: EdgeInsets.all(0.0),
      child: Row(
        children:[
          Text(
            'Create C',
            style: TextStyle(fontSize: 28.0, color: Colors.white),
          ),
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
                onPressed: () => _createConversationNew(),
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
    
    return new Scaffold(
      appBar: AppBar(
        title: appbar,
      ),
      body: 
      Container(
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onChanged: (val){
                  _getAutoComplete(val);
              },
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                fillColor: Colors.white,
                hintText: 'Search...',
              ),
            ),
            RaisedButton(
              child: new Text('Create Conversation'),
              onPressed: (){
                _createNewConversation();
              },
            ),
            Column(
              children:(_autoCompleteData == null || _autoCompleteData.length == 0)?
                  [
                    (_controller.text.length > 0)?
                    Text("No Result Found"): Text(''),
                  ]
                  : _autoCompleteData
                  .map((element) => Card(
                    child : RaisedButton(
                      child: Row(
                        children: <Widget>[
                          new Text(
                            element['label'].toString(),
                            style: new TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Roboto',
                              color: Colors.green,
                            ), 
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                      onPressed: ()=>
                        setvalue(element['value'], element['label'])
                      ,
                    ),
                ),)
                .toList(),
            ),
          ],
        ),
      )
    );
  }
}
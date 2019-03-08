import 'package:flutter/material.dart';
import './home_page.dart';
import './login_page.dart';
import './session.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import './create_conversation.dart';

class Conversation extends StatefulWidget {
  static String tag = 'conversation';
  @override
  _ConversationState createState() => new _ConversationState();
}

class _ConversationState extends State<Conversation> {

  final String url = '$ipaddress/ConversationDetail?other_id=$otherId';
  final TextEditingController _controller = new TextEditingController();
  List conversationDetails;
  List _conversationDetails;
  bool dataLoaded = true;
  Session session = new Session();
  String _newMessage;

  @override
  void initState() {
    if(id == ''){
      Navigator.of(context).pushNamed(LoginPage.tag);
    }
    Future<String> response = session.get(url);
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
    conversationDetails = json.decode(s)['data'];
    _conversationDetails = json.decode(s)['data'];
    setState(() {
      dataLoaded = false;
    });
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
    var list = json.decode(s)['status'];
    print(list);
    if(list == true){
      id = '';
      Navigator.of(context).pushNamed(LoginPage.tag);
    }
  }


  void _onChange(String val) {
    setState(() {
      _newMessage = val.trim();
    });
  }

  void _onSubmit(String val) {
    setState(() {
      _newMessage = val.trim();
    });
  }

  void _sendMessage(){
    if(_controller.text.trim().length == 0)
      return;
    Future<String> response = session.get('$ipaddress/NewMessage?other_id=$otherId&msg=${_controller.text.trim()}');
    
    response.then((s) => 
      (onSendMessageSuccess(s))
    ).catchError((e)=>print('$e'));
  }

  void onSendMessageSuccess(s){
    bool l = json.decode(s)['status'];
    if(l){
      Future<String> response = session.get(url);
      response.then((s) => 
        (decodeResponse(s))
      ).catchError((e)=>print('$e'));
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
            (otherName.length < 7)? otherName : otherName.substring(0,7),
            style: TextStyle(fontSize: 28.0, color: Colors.white),
          ),
          Container(width: (otherName.length >= 7)? 10.0 : 10.0 + 15.5*(7-otherName.length) , height: 0.0),
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
    
    return new Scaffold(
      appBar: AppBar(
        title: appbar,
      ),
      body: dataLoaded? Center(
        child: Text('Loading Conversation'),
      ):
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextField(
              onChanged: (val){
                List<dynamic> l = new List();
                _conversationDetails.forEach(
                  (f){
                    if (f['text'].toString().toLowerCase().contains(val.trim().toLowerCase())) {
                      l.add(f);
                    }
                  }
                );
                
                setState(() {
                  conversationDetails = l;
                });
              },
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                fillColor: Colors.white,
                hintText: 'Search...',
              ),
            ),
            Container(width: 0.0, height: 20.0,),
            Expanded(
              child: (conversationDetails.length == 0)?
                new Text('No message found')
                :
                ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: conversationDetails.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: (conversationDetails[index]['uid'] == id)? Text(
                      '${conversationDetails[index]['text']}', 
                      style: new TextStyle(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.right,
                    ):
                    Text(
                      '${conversationDetails[index]['text']}', 
                      style: new TextStyle(
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  );
                },
              ),  
            ),
            
            TextField(
              decoration: new InputDecoration(
                hintText: "Type something...",
              ),
              controller: _controller,
              onSubmitted: (String submittedStr) {
                _onSubmit(submittedStr);
              },
              onChanged: (val){
                _onChange(val);
              },
            ),
            RaisedButton(
              child: new Text('Send'),
              onPressed: (){
                _sendMessage();
                _controller.text = "";
              },
            ),
          ],
        )
      )
    );
  }
}
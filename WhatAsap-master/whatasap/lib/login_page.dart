import 'package:flutter/material.dart';
import './home_page.dart';
import './session.dart';
import 'dart:async';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  final String url = '$ipaddress/LoginServlet';
  
  String _email;
  String _password;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _submit(){
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      performLogin();
    }
  }
  
  void performLogin() {
    Map loginMap = {'userid':_email, 'password': _password};

    Session session = new Session();
    Future<String> response = session.post(url, loginMap);
    response.then((s) => 
      (decodeResponse(s))
    ).catchError((e)=>print('123456$e'));
  }

  void decodeResponse(String s){
    Map loginResponse = json.decode(s);
    bool status = loginResponse['status'];
    if(status == true){
      id = _email;
      Navigator.of(context).pushNamed(HomePage.tag);
    }
    else{
      String msg = loginResponse['message'];
      final snackbar = new SnackBar(
        content: new Text('$msg'),
      );
      scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('WhatAsap'),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new SingleChildScrollView(
          child: new Form(
            key: formKey,
            child: new Column(
              children: <Widget>[
                new SizedBox(height: 40.0),
                // Login Logo
                new Hero(
                  tag: 'hero',
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 48.0,
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
                new SizedBox(height: 55.0),
                // Email Field
                new TextFormField(
                  maxLengthEnforced: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: new InputDecoration(
                    labelText: 'Email',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
                  validator: (val)=> val.trim().length<1? 'Invalid Email' : null,
                  onSaved: (val)=> _email = val.trim(),
                ),
                new Padding(
                    padding: const EdgeInsets.only(top: 20.0)
                ),
                //Password Field
                new TextFormField(
                  decoration: new InputDecoration(
                    labelText: 'Password',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
                  validator: (val)=> val.length<1? 'Password too short' : null,
                  onSaved: (val)=>_password = val,
                  obscureText: true,
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                ),
                //Login Button
                new RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 0.0),
                  child: Text('Login'),
                  onPressed: _submit,
                  color: Colors.greenAccent,
                  textColor: Colors.blue,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
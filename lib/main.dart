import 'package:firebasecurd/MyTask.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  final GoogleSignIn googleSignIn=new GoogleSignIn();

  Future<FirebaseUser>  _signIn() async{

    GoogleSignInAccount googleSignInAccount=await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount.authentication;

    AuthCredential authCredential = GoogleAuthProvider.getCredential(
      idToken:googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken
    );

    final FirebaseUser firebaseUser = await firebaseAuth.signInWithCredential(authCredential);

    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (BuildContext context)=>new MyTask(firebaseUser,googleSignIn)
      )
    );

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          image: DecorationImage(
              image:AssetImage("images/bag.png"),
              fit: BoxFit.cover,
              alignment: Alignment.center,
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new MaterialButton(child: new Text("Sign in with Google Account "),color: Colors.red,onPressed: (){
              _signIn();
            }),
            new SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}





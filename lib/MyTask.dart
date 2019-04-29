import 'package:firebasecurd/AddTask.dart';
import 'package:firebasecurd/EditTask.dart';

import 'package:firebasecurd/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyTask extends StatefulWidget {
  final FirebaseUser user;
  final GoogleSignIn googleSignIn;

  MyTask(this.user, this.googleSignIn);

  @override
  _MyTaskState createState() => _MyTaskState();
}

class _MyTaskState extends State<MyTask> {
  void _singOut() {
    AlertDialog alertDialog = new AlertDialog(
      content: Container(
          height: 215.0,
          child: new Column(
            children: <Widget>[
              ClipOval(
                child: new Image.network(widget.user.photoUrl),
              ),
              new SizedBox(
                height: 10,
              ),
              Text("Sing Out"),
              new SizedBox(
                height: 30,
              ),
              new Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      child: new Column(
                        children: <Widget>[
                          new Icon(
                            Icons.check,
                          ),
                          Text("yes")
                        ],
                      ),
                      onTap: () {
                        widget.googleSignIn.signOut();
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => MyHomePage()));
                      },
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: InkWell(
                      child: new Column(
                        children: <Widget>[
                          new Icon(
                            Icons.close,
                          ),
                          Text("Cancle")
                        ],
                      ),
                      onTap: () {},
                    ),
                  )
                ],
              )
            ],
          )),
    );
    showDialog(context: context, child: alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) =>
                  new AddTask(email: widget.user.email)));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: new BottomAppBar(
        elevation: 20,
        color: Colors.black,
        child: ButtonBar(
          children: <Widget>[],
        ),
      ),
      backgroundColor: Colors.white,
      body: new Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection("task")
                  .where("email", isEqualTo: widget.user.email)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return new Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return new TaskList(
                  documents: snapshot.data.documents,
                );
              },
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/wal.jpeg"), fit: BoxFit.cover),
                boxShadow: [
                  new BoxShadow(color: Colors.black, blurRadius: 8.0)
                ]),
            child: Column(
              children: <Widget>[
                new SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Row(
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 60.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: new NetworkImage(widget.user.photoUrl),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                "Welcome",
                                style: new TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              ),
                              new Text(
                                widget.user.displayName,
                                style: new TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _singOut,
                        child: new IconButton(
                          icon: Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                new Text(
                  "My Task",
                  style: TextStyle(
                      color: Colors.white, fontSize: 30.0, letterSpacing: 2.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*TaskList({this.documents});
  final List<DocumentSnapshot>  documents;*/

class TaskList extends StatelessWidget {
  TaskList({this.documents});

  final List<DocumentSnapshot> documents;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: documents.length,

      itemBuilder: (BuildContext context, int i) {
        String title = documents[i].data['title'].toString();
        String email = documents[i].data["email"].toString();
        DateTime dateTime = documents[i].data["duedate"].toDate();
        String note = documents[i].data["note"].toString();
        String duedate="${dateTime.day}/${dateTime.month}/${dateTime.year}";

       // print(dateTime);
        print(title);
        print(email);
        //print(duedate);
        print(note);

        return Dismissible(
          key: new Key(documents[i].documentID),
          onDismissed: (direction){
            Firestore.instance.runTransaction((Transaction transaction) async{
              DocumentSnapshot snapshot=await transaction.get(documents[i].reference);
              await transaction.delete(snapshot.reference);
            });

            Scaffold.of(context).showSnackBar(
              new SnackBar(content: new Text("Data Deleted"))
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(title),
                          Row(
                            children: <Widget>[

                              Icon(Icons.date_range),
                              Expanded(child: Text(duedate)),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.note),
                              Expanded(child: Text(note)),
                            ],
                          ),

                        ],
                      ),
                  ),
                ),

                InkWell(

                  child: Icon(Icons.edit),

                  onTap: (){
                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>EditTask(title: title,duedate: documents[i].data["duedate"].toDate(),note: note,index: documents[i].reference,)));
                  },

                )

              ],
            ),
          ),
        );
      },
    );
  }
}



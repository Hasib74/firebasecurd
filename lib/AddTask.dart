import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AddTask extends StatefulWidget {

  AddTask({this.email});
  final String email;

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {


  DateTime _datetime=new DateTime.now();
  String _dateText;

  String newTask="";
  String note="";

  Future<Null> _seleceteDueDate(BuildContext context) async{

    final picked=await showDatePicker(context: context, initialDate:_datetime, firstDate: DateTime(2019), lastDate: DateTime(2080));
    if(picked !=null){
      setState(() {

          _datetime=picked;
          _dateText="${picked.day}/${picked.month}/${picked.year}";
      });
    }

  }
 void _addDate(){
    Firestore.instance.runTransaction((Transaction transsaction) async{
      CollectionReference reference=Firestore.instance.collection("task");
      await reference.add(
       {
         "email":widget.email,
         "title":newTask,
         "duedate":_datetime,
         "note":note,
       }
      );

    });

    Navigator.pop(context);
 }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateText="${_datetime.day}/${_datetime.month}/${_datetime.year}";
  }
  @override
  Widget build(BuildContext context) {
    return new Material(
      child: Column(
        children: <Widget>[
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/wal.jpeg"),fit: BoxFit.cover
              ),
              color: Colors.white,

            ),
            child: new Column(
              children: <Widget>[
                SizedBox(height: 40),
                Text("My Task",style: TextStyle(fontSize: 30,color: Colors.white,fontFamily: "Courier",letterSpacing: 2.0),),
                SizedBox(height: 20),
                Text("Add Task",style: TextStyle(fontSize: 30,color: Colors.white,fontFamily: "Verdana",letterSpacing: 2.0),),
                SizedBox(height: 10),
                Icon(Icons.menu,size: 35,color: Colors.white,)
              ],


            )
          ),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: TextField(
             onChanged: (String str){
               setState(() {
                 newTask=str;
               });
             },



             decoration: new InputDecoration(
               icon: Icon(Icons.dashboard,color: Colors.black,),
               fillColor: Colors.green,
               hintText: "New task",
               border: InputBorder.none,

             ),
           ),

         ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.date_range),
                new Padding(padding: EdgeInsets.only(right: 5)),
                Text("Due date", style: new TextStyle(fontSize: 22.0,color: Colors.black54),textAlign: TextAlign.center,),
                 SizedBox(width: 140,),
                new FlatButton(onPressed: ()=>_seleceteDueDate(context),
                  child:  Text(_dateText, style: new TextStyle(fontSize: 22.0,color: Colors.black54),textAlign: TextAlign.center,),)

              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (String str){
                setState(() {
                  note=str;
                });
              },

              decoration: new InputDecoration(
                icon: Icon(Icons.note,color: Colors.black,),
                fillColor: Colors.green,
                hintText: "Note ",
                border: InputBorder.none,

              ),
            ),

          ),

          Padding(
            padding: const EdgeInsets.all(30.0),
            child: new Row(
              children: <Widget>[
               Expanded(child: IconButton(icon:Icon(Icons.done), onPressed: (){

                 _addDate();

               })),



               Expanded(child: IconButton(icon:Icon(Icons.close), onPressed: (){
                 Navigator.pop(context);

               }))
              ],
            ),
          )

        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class EditTask extends StatefulWidget {

  EditTask({this.title,this.duedate,this.note,this.index});
 // final String email;
  final String title;
  final DateTime duedate;
  final String note;
  final index;

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {

  TextEditingController controllerTitle;
  TextEditingController controllerNote;


  DateTime _datetime;
  String _dateText;

  String newTask;
  String note;


  void _updateTask(){
   Firestore.instance.runTransaction((Transaction transaction) async{
    // final picked=await showDatePicker(context: context, initialDate: , firstDate: null, lastDate: null)


     DocumentSnapshot snapshot=
         await transaction.get(widget.index);
         await transaction.update(snapshot.reference, {
         "title" :newTask,
         "note":note,
         "duedate":_datetime
     });
   });
   Navigator.pop(context);
  }


  Future<Null> _seleceteDueDate(BuildContext context) async{

    final picked=await showDatePicker(context: context, initialDate:_datetime, firstDate: DateTime(2019), lastDate: DateTime(2080));
    if(picked !=null){
      setState(() {

        _datetime=picked;
        _dateText="${picked.day}/${picked.month}/${picked.year}";
      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controllerTitle=new  TextEditingController(text: widget.title);
    controllerNote=new TextEditingController(text: widget.note);

    _datetime=widget.duedate;
    _dateText="${_datetime.day}/${_datetime.month}/${_datetime.year}";

    newTask=widget.title;
    note=widget.note;

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
                  Text("Edit Task",style: TextStyle(fontSize: 30,color: Colors.white,fontFamily: "Courier",letterSpacing: 2.0),),
                  SizedBox(height: 20),
                  Text("edit  Task",style: TextStyle(fontSize: 30,color: Colors.white,fontFamily: "Verdana",letterSpacing: 2.0),),
                  SizedBox(height: 10),
                  Icon(Icons.menu,size: 35,color: Colors.white,)
                ],


              )
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controllerTitle,
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
              controller: controllerNote,
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
                    _updateTask();

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

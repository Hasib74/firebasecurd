import 'package:flutter/material.dart';
class ShowDetail extends StatefulWidget {

  ShowDetail(this.title,this.date, this.note);
  final String title;
  final String date;
  final String note;
  @override
  _ShowDetailState createState() => _ShowDetailState();


}

class _ShowDetailState extends State<ShowDetail> {
  @override
  Widget build(BuildContext context) {
    return Material(
       child: Column(
        children: <Widget>[
         new Container(
           height: 200,
           width: double.infinity,
           decoration: BoxDecoration(
             image: DecorationImage(image: AssetImage("images/wal.jpeg"),fit: BoxFit.cover)
           ),

             child: new Column(
               children: <Widget>[
                 SizedBox(height: 40),
                 Text("Welcome",style: TextStyle(fontSize: 30,color: Colors.white,fontFamily: "Courier",letterSpacing: 2.0),),
                 SizedBox(height: 20),
                 Text("Detail",style: TextStyle(fontSize: 30,color: Colors.white,fontFamily: "Verdana",letterSpacing: 2.0),),
                 SizedBox(height: 10),
                 Icon(Icons.menu,size: 35,color: Colors.white,)
               ],




             )

         ),
         Padding(
           padding: const EdgeInsets.only(top:8.0),
           child: Text(widget.title,style: TextStyle(fontSize: 20,color: Colors.black), ),
         ) ,
         Text(widget.date,style: TextStyle(fontSize: 15,color: Colors.black), ),
         Divider(color: Colors.grey,),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Text(widget.note),
         ),


        ],
      ),
    );
  }
}

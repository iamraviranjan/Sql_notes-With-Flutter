import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sql/NotesScreen.dart';
import 'package:sql/db_healper.dart';
import 'package:sql/model.dart';

class AddNotes extends StatefulWidget {  @override
State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {

  TextEditingController titleControler = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  DbHelper? dbHelper;
  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    dbHelper = DbHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Nottes'),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            margin: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.brown,width: 3),
                borderRadius: BorderRadius.circular(15)
            ),
            child: Column(
              children: [
                TextFormField(
                  minLines: 1,
                  controller: titleControler,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none,
                  ),
                ),
                TextFormField(
                  maxLines: 7,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: "description",
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),

          InkWell(
            onTap: (){
              dbHelper!.insert(NotesModel(title: titleControler.text.toString(), description: descriptionController.text.toString())).then((value){
                setState(() {
                  notesList = dbHelper!.getNotesList();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Notesscreen()));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Notes Added'), backgroundColor: Colors.green,));
                });
              }).onError((error, stackTrace){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('$error'), backgroundColor: Colors.redAccent,));
              });
            },
            child: Container(
              height: 50,
              margin: EdgeInsets.symmetric( horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.brown,
                border: Border.all(color: Colors.brown,width: 3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(child: Text("save",style: TextStyle(color: Colors.white,fontSize: 22),)),
            ),
          ),

        ],
      ),
    );

  }}
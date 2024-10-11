import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sql/NotesScreen.dart';
import 'package:sql/db_healper.dart';
import 'package:sql/model.dart';

class EditScreen extends StatefulWidget {

  final String title, description;
  final int? id;

  const EditScreen({super.key, required this.title, required this.description, this.id});


  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
 late TextEditingController titleControler = TextEditingController(text: widget.title);
 late TextEditingController descriptionController = TextEditingController(text: widget.description);

 DbHelper? dbHelper;
 late Future<List<NotesModel>> notesList;

 @override
  void initState() {
   dbHelper = DbHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
            onTap:(){
              dbHelper!.edit(NotesModel(
                id: widget.id,
                  title: titleControler.text.toString(),
                  description: descriptionController.text.toString())).then((value){
                  notesList = dbHelper!.getNotesList();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('update Successfuly'),
                  backgroundColor: Colors.green,
                  ));
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Notesscreen()));
              }).onError((error, stackTrace){
                print('error');
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

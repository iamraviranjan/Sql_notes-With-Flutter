import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sql/addnotes.dart';
import 'package:sql/edit_screen.dart';
import 'db_healper.dart';
import 'model.dart';

class Notesscreen extends StatefulWidget {
  @override
  State<Notesscreen> createState() => NotesscreenState();
}

class NotesscreenState extends State<Notesscreen> {
  String search = "";
  bool issearch = false;
  TextEditingController searchController = TextEditingController();

  DbHelper? dbHelper;
  late Future<List<NotesModel>> notesList;
  getData() {
    notesList = dbHelper!.getNotesList();
  }

  @override
  void initState() {
    dbHelper = DbHelper();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: issearch == false
          ? AppBar(
              centerTitle: true,
              title: Text('Sql Notes'),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        issearch = true;
                      });
                    },
                    icon: const Icon(Icons.search))
              ],
            )
          : AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              leading: BackButton(
                onPressed: () {
                  setState(() {
                    issearch = false;
                  });
                },
              ),
              title: TextFormField(
                maxLines: 1,
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'search',
                  border: InputBorder.none,
                ),
                onChanged: (String value) {
                  search = value.toString();
                  setState(() {});
                },
              ),
            ),
      body: FutureBuilder(
          future: notesList,
          builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    if (searchController.text.isEmpty) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(snapshot.data![index].id.toString()),
                          ),
                          title: Text(snapshot.data![index].title.toString()),
                          subtitle: Text(
                              snapshot.data![index].description.toString()),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: ListTile(
                                    leading: Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                    title: Text("Edit"),
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditScreen(
                                                    id: snapshot
                                                        .data![index].id,
                                                    title: snapshot
                                                        .data![index].title
                                                        .toString(),
                                                    description: snapshot
                                                        .data![index]
                                                        .description
                                                        .toString(),
                                                  )));
                                    }),
                              ),
                              PopupMenuItem(
                                  child: ListTile(
                                leading: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                title: Text("delete"),
                                onTap: () {
                                  setState(() {
                                    dbHelper!.delete(snapshot.data![index].id!);
                                    notesList = dbHelper!.getNotesList();
                                    snapshot.data!
                                        .remove(snapshot.data![index]);
                                    Navigator.pop(context);
                                  });
                                },
                              )),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.data![index].title
                        .toLowerCase()
                        .contains(
                            searchController.text.toString().toLowerCase())) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(snapshot.data![index].id.toString()),
                          ),
                          title: Text(snapshot.data![index].title.toString()),
                          subtitle: Text(
                              snapshot.data![index].description.toString()),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: ListTile(
                                    leading: Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                    title: Text("Edit"),
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditScreen(
                                                    id: snapshot
                                                        .data![index].id,
                                                    title: snapshot
                                                        .data![index].title
                                                        .toString(),
                                                    description: snapshot
                                                        .data![index]
                                                        .description
                                                        .toString(),
                                                  )));
                                    }),
                              ),
                              PopupMenuItem(
                                  child: ListTile(
                                leading: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                title: Text("delete"),
                                onTap: () {
                                  setState(() {
                                    dbHelper!.delete(snapshot.data![index].id!);
                                    notesList = dbHelper!.getNotesList();
                                    snapshot.data!
                                        .remove(snapshot.data![index]);
                                    Navigator.pop(context);
                                  });
                                },
                              )),
                            ],
                          ),
                        ),
                      );
                    } else {}
                  });
            } else {}
            return SizedBox();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddNotes()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

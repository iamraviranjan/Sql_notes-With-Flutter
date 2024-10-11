class NotesModel {

  final int? id;
  final String title;
  final String description;

  NotesModel({this.id, required this.title, required this.description});        // create a constructor


NotesModel.forMap(Map<String, dynamic> res):
id =res['id'],
title = res['title'],
description = res['description'];

  Map<String, Object?> toMap(){
    return {
      "id" : id,
      "title" : title,
      "description" : description,
};
}
}
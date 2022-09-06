//Write code here for the project data model class
import 'package:flutter/material.dart';

class ProjectModel {
  final String project_id;
  late String project_title; //if needed later put ? after data type
  final String date;
  bool isSelected = false;
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  List<SecondPageModel> SecondPageModelList = [];
  List<CharacterPageModel> CharacterPageModelList = [];

  ProjectModel(
    this.project_id,
    this.project_title,
    this.date,
  );

  ProjectModel.fromJson(Map<String, dynamic> parsedJson)
      : project_id = parsedJson['id'] ?? "",
        project_title = parsedJson['title'] ?? "",
        date = parsedJson['date'] ?? "";

  Map<String, dynamic> toJson() {
    return {
      "id": this.project_id,
      "title": this.project_title,
      "date": this.date,
    };
  }
}

class SecondPageModel {
  TextEditingController beats =
      TextEditingController(); //if needed later put ? after data type
  TextEditingController body = TextEditingController();
  String? x;
  String? y;

  SecondPageModel();

  SecondPageModel.fromJson(Map<String, dynamic> parsedJson)
      : x = parsedJson['beats'] ?? "",
        y = parsedJson['body'] ?? "";

  Map<String, dynamic> toJson() {
    return {
      "beats": this.beats.text,
      "body": this.body.text,
    };
  }
}

class CharacterPageModel {
  TextEditingController name =
      TextEditingController(); //if needed later put ? after data type
  TextEditingController descriptions = TextEditingController();
  String? x;
  String? y;

  CharacterPageModel();

  CharacterPageModel.fromJson(Map<String, dynamic> parsedJson)
      : x = parsedJson['name'] ?? "",
        y = parsedJson['descriptions'] ?? "";

  Map<String, dynamic> toJson() {
    return {
      "name": this.name.text,
      "descriptions": this.descriptions.text,
    };
  }
}

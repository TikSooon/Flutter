//Write code here for the project data model class
import 'package:flutter/material.dart';

class ProjectModel {
  late String project_title; //if needed later put ? after data type
  final String date;
  final String more_icon; //Icon? more_icon;
  final String project_link; //AssetImage? project_link;
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  List<SecondPageModel> SecondPageModelList = [];
  List<CharacterPageModel> CharacterPageModelList = [];

  ProjectModel(
    this.project_title,
    this.date,
    this.more_icon,
    this.project_link,
  );

  ProjectModel.fromJson(Map<String, dynamic> parsedJson)
      : project_title = parsedJson['title'] ?? "",
        date = parsedJson['date'] ?? "",
        more_icon = parsedJson['icon'] ?? "",
        project_link = parsedJson['project_link'] ?? "";

  // SecondPageModelList = parsedJson['secondpagemodellist'] ?? "[]";

  Map<String, dynamic> toJson() {
    return {
      "title": this.project_title,
      "date": this.date,
      "icon": this.more_icon,
      "project_link": this.project_link,
      //"secondpagemodellist": this.SecondPageModelList,
    };
  }
}

class SecondPageModel {
  TextEditingController beats = TextEditingController(); //if needed later put ? after data type
  TextEditingController body = TextEditingController();
  bool isExpanded = false;
  String? x;
  String? y;

  SecondPageModel();

  SecondPageModel.fromJson(Map<String, dynamic> parsedJson)
      : x = parsedJson['beats'] ?? "",
        y = parsedJson['body'] ?? "",
        isExpanded = parsedJson['isExpanded'] ?? bool;

  Map<String, dynamic> toJson() {
    return {
      "beats": this.beats.text,
      "body": this.body.text,
      "isExpanded": this.isExpanded,
    };
  }
}

class CharacterPageModel {
  TextEditingController name =
      TextEditingController(); //if needed later put ? after data type
  TextEditingController descriptions = TextEditingController();
  bool isExpanded = false;
  String? x;
  String? y;

  CharacterPageModel();

  CharacterPageModel.fromJson(Map<String, dynamic> parsedJson)
      : x = parsedJson['name'] ?? "",
        y = parsedJson['description'] ?? "",
        isExpanded = parsedJson['isExpanded'];


  Map<String, dynamic> toJson() {
    return {
      "name": this.name.text,
      "description": this.descriptions,
      "isExpanded": this.isExpanded,
    };
  }
}

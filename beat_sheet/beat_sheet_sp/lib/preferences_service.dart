

import 'package:beat_sheet/MainPage.dart';

import 'dart:async';
import 'dart:convert';

import 'package:beat_sheet/Classes/project_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static late SharedPreferences preferences;
  static late List<List<SecondPageModel>> moreproject = [];
  static late List<List<CharacterPageModel>> characterproject = [];

  static Future init() async =>
      preferences = await SharedPreferences.getInstance();

  static Future saveSettings(List<ProjectModel> projects) async {
    for (int i = 0; i < projects.length; i++) {
      moreproject.add(projects[i].SecondPageModelList);
      characterproject.add(projects[i].CharacterPageModelList);
    }
    await saveCharacterSetting(characterproject);
    await saveMoreSetting(moreproject);

    return await preferences.setString('user', jsonEncode(projects));
  }



  static void getProjectModel() async {
    final List<dynamic> jsonData = jsonDecode(
        preferences.getString('user') ?? '[]');

    MainPageState.main_projects_list = jsonData.map<ProjectModel>((e) {
      return ProjectModel.fromJson(e);
    }).toList();

    for (int i = 0; i < MainPageState.main_projects_list.length; i++) {
      getMoreProject(i);
      getCharacterProject(i);
    }
  }

  static Future saveMoreSetting(List<List<SecondPageModel>> projects) async {
    return await preferences.setString('more', jsonEncode(projects));
  }

  static void getMoreProject(int index) async {

    final List<dynamic> jsonData = jsonDecode(
        preferences.getString('more') ?? '[]');

    MainPageState.main_projects_list[index].SecondPageModelList = jsonData[index].map<SecondPageModel>((e) {
      return SecondPageModel.fromJson(e);
    }).toList();

    for(int i=0; i< MainPageState.main_projects_list[index].SecondPageModelList.length; i++){
      MainPageState.main_projects_list[index].SecondPageModelList[i].beats.text =  MainPageState.main_projects_list[index].SecondPageModelList[i].x!;
      MainPageState.main_projects_list[index].SecondPageModelList[i].body.text =  MainPageState.main_projects_list[index].SecondPageModelList[i].y!;
    }
  }

  static Future saveCharacterSetting(List<List<CharacterPageModel>> projects) async {
    return await preferences.setString('characters', jsonEncode(projects));
  }

  static void getCharacterProject(int index) async {

    final List<dynamic> jsonData = jsonDecode(
        preferences.getString('characters') ?? '[]');

    MainPageState.main_projects_list[index].CharacterPageModelList = jsonData[index].map<CharacterPageModel>((e) {
      return CharacterPageModel.fromJson(e);
    }).toList();

    for(int i=0; i< MainPageState.main_projects_list[index].CharacterPageModelList.length; i++){
      MainPageState.main_projects_list[index].CharacterPageModelList[i].name.text =  MainPageState.main_projects_list[index].CharacterPageModelList[i].x!;
      MainPageState.main_projects_list[index].CharacterPageModelList[i].descriptions.text =  MainPageState.main_projects_list[index].CharacterPageModelList[i].y!;
    }
  }
}


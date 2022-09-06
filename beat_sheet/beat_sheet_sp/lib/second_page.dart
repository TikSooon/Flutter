import 'package:beat_sheet/BS_Tab_Beat.dart';
import 'package:beat_sheet/BS_Tab_Characters.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Classes/project_model.dart';

class SecondRoute extends StatefulWidget {
  List<ProjectModel> model;
  int index;

  SecondRoute(this.index, this.model);

  @override
  State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  Color d = const Color.fromARGB(46, 46, 46, 255);
  int _count = 0;
  List<int> _countList = List<int>.generate(0, (index) => index);
  List<TextEditingController> _controller = [];

  @override
  Widget build(BuildContext context) {
    /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xff1E1E1E),
        statusBarColor: Color(0xff1E1E1E),
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light));*/
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    if (kDebugMode) {
      print("Hey 2nd page");
    } //sample printing statement on console..todo:test conditional statements ifelse,for..etc

    return  GestureDetector(
        onTap:(){
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
        _controller.clear();
      }
    },
    child: Scaffold(
      backgroundColor: Color(0xff1E1E1E),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.model[widget.index].project_title,
            style: TextStyle(fontSize: 20, color: Colors.grey)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        leading: IconButton(
          padding: const EdgeInsets.only(left: 14),
          icon: ImageIcon(AssetImage('assets/icons/Arrow_Left_Grey.png'),
               color: Colors.grey),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          height: double.infinity,
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  alignment: Alignment.topCenter,
                  constraints: BoxConstraints.expand(height: 50),
                  child: TabBar(
                      labelColor: Colors.deepOrangeAccent,
                      indicatorColor: Colors.deepOrangeAccent,
                      indicatorSize: TabBarIndicatorSize.label,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        //Beat Tab
                        Tab(
                          child: Text(
                            'Beats',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        //Character Tab
                        Tab(
                          child: Text(
                            'Characters',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                ),
                Expanded(
                  child: Container(
                    child: TabBarView(children: [
                      //Beat Tab
                      BeatPage(widget.index, widget.model),
                      //Character Tab
                      CharactersPage(widget.index, widget.model),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),);
  }
}

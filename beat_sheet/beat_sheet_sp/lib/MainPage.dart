import 'dart:async';

import 'package:beat_sheet/Trash.dart';
import 'package:beat_sheet/preferences_service.dart';
import 'package:beat_sheet/Classes/project_model.dart';
import 'package:beat_sheet/second_page.dart';
import 'package:beat_sheet/widgets/SideMenu.dart';
import 'package:nanoid/nanoid.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/animation.dart';

import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/widgets.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  // const MainPage({Key? key});

  //index of new project (widget)
  static int projectPos = 0;
  static bool isNewProject = false;

  //Budget Sheet menu as default when start app
  static String menuName = "Beat Sheet";

  //Project Lists
  static List<dynamic> projectList = [];

  // static List<List<dynamic>> projectList = main_projects_list.cast<List<dynamic>>();

  //trash Lists (test)
  static List<ProjectModel> trashList = [];
  static List<ProjectModel> main_projects_list = [];

  //Sections
  //static List<List<dynamic>> NewCS = []; //new call sheet list

  // static final GlobalKey<ScaffoldState> scaffoldKey =
  //     new GlobalKey<ScaffoldState>();

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> with TickerProviderStateMixin {
  List<TextEditingController> _controller1 = [];

  List<bool> _rename = [];

  //-Search Bar Visibility-
  bool _isSearchBarActive = true;

  //-Dropdown Template Menu Visibility-
  bool _isMenuActive = false;

  //-Invisible Container when template menu is visible-
  bool _isInvisibleTriggerActive = false;
  bool order = false;

  //search data
  late String _search = '';
  var matchingItems;

  //Animation of dropdown template menu
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  late Timer timer;

  FocusNode _titleFocusNode = FocusNode();
  late AnimationController controller;

  // final listenable = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    PreferencesService.init();
    PreferencesService.getProjectModel();
    if (main_projects_list.isEmpty) {
      main_projects_list = [];
    }
    timer = Timer.periodic(
        Duration(seconds: 1),
        (Timer t) async =>
            await PreferencesService.saveSettings(main_projects_list));

    display_list = List.from(main_projects_list);
  }

  @override
  void didChangeDependencies() {
    //Refresh the list when come back
    setState(() {
      if (TrashPage.recList.isNotEmpty) {
        for (int i = 0; i < TrashPage.recList.length; i++) {
          main_projects_list.add(TrashPage.recList[i]);
          display_list.add(TrashPage.recList[i]);
        }
      }
      TrashPage.recList.clear();
    });
    super.didChangeDependencies();
  }

  late SlidableController slidableController;

  static List<ProjectModel> main_projects_list = [];
  List<ProjectModel> display_list = List.from(main_projects_list);

  //dispose f()
  @override
  void dispose() {
    _controller.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  //Home Page Layout
  @override
  Widget build(BuildContext context) {
    // sets status bar and navi bar colors
    // final SystemUiOverlayStyle themeSet = SystemUiOverlayStyle.dark.copyWith();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    bool showFab = MediaQuery.of(context).viewInsets.bottom != 0;

    //check screen safe area
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    //final ValueNotifier<int> rec_project = ValueNotifier(0);

    _titleFocusNode.addListener(() {
      if (_titleFocusNode.hasFocus) {
        controller.forward();
      } else {
        controller.reverse();
      }
    });

    return SafeArea(
      child: new GestureDetector(
        //hide keyboard
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        //Page Layout
        child: Scaffold(
          primary: false,
          // key: MainPage.scaffoldKey,
          backgroundColor: Color(0xff1E1E1E),

          //Side Menu
          drawer: sideMenu(),
          //body layout
          body: Container(
            width: width,
            height: height,
            child: Stack(
              children: [
                //1st layer
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //empty space, custom appbar height
                      SizedBox(height: 140),

                      ValueListenableBuilder<int>(
                        valueListenable: TrashPage.rec_project,
                        builder:
                            (BuildContext context, int value, Widget? child) {
                          return Expanded(
                            child: display_list.length == 0
                                ? Center(
                                    child: Text(
                                    "No results found",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ))
                                : Theme(
                                    data: ThemeData(
                                        canvasColor: Colors.transparent),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: ReorderableListView.builder(
                                          onReorder: (oldIndex, newIndex) {
                                            setState(() {
                                              if (newIndex > oldIndex)
                                                newIndex--;
                                              final item = display_list
                                                  .removeAt(oldIndex);
                                              display_list.insert(
                                                  newIndex, item);
                                              final itemx = main_projects_list
                                                  .removeAt(oldIndex);
                                              main_projects_list.insert(
                                                  newIndex, itemx);
                                            });
                                          },
                                          shrinkWrap: true,
                                          itemCount: display_list.length,
                                          itemBuilder: (context, index) {
                                            if (display_list[index]
                                                .controller
                                                .text
                                                .isEmpty) {
                                              display_list[index]
                                                      .controller
                                                      .text =
                                                  display_list[index]
                                                      .project_title;
                                            }
                                            return Column(
                                              key:
                                                  ValueKey(display_list[index]),
                                              children: <Widget>[
                                                Slidable(
                                                  endActionPane: ActionPane(
                                                    extentRatio: 0.6,
                                                    motion: StretchMotion(),
                                                    children: [
                                                      SlidableAction(
                                                        onPressed: (context) {
                                                          share(index);
                                                        },
                                                        backgroundColor: Colors
                                                            .blueAccent
                                                            .shade100,
                                                        foregroundColor:
                                                            Colors.white,
                                                        icon: Icons.ios_share,
                                                      ),
                                                      SlidableAction(
                                                        onPressed: (context) {
                                                          rename(index);
                                                        },
                                                        backgroundColor: Colors
                                                            .purple.shade400,
                                                        foregroundColor:
                                                            Colors.white,
                                                        icon: Icons.edit,
                                                      ),
                                                      SlidableAction(
                                                          onPressed: (context) {
                                                            delete(index);
                                                          },
                                                          backgroundColor:
                                                              Colors
                                                                  .red.shade400,
                                                          foregroundColor:
                                                              Colors.white,
                                                          icon: Icons.delete),
                                                    ],
                                                  ),
                                                  child: ListTile(
                                                    // visualDensity: VisualDensity(vertical: 4),
                                                    key: ValueKey(
                                                        display_list[index]),
                                                    // key for the ReorderableListView
                                                    onTap: () {
                                                      print(index);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SecondRoute(
                                                                      index,
                                                                      main_projects_list)));
                                                    },
                                                    contentPadding:
                                                        EdgeInsets.all(8.0),

                                                    title: TextField(
                                                      controller:
                                                          display_list[index]
                                                              .controller,
                                                      onChanged: (text) {
                                                        setState(() {
                                                          main_projects_list[
                                                                      index]
                                                                  .project_title =
                                                              text;
                                                          display_list[index]
                                                                  .project_title =
                                                              text;
                                                        });
                                                      },
                                                      focusNode:
                                                          display_list[index]
                                                              .focusNode,
                                                      autofocus: false,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            display_list[index]
                                                                .project_title,
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ),
                                                    subtitle: Padding(
                                                      padding: const EdgeInsets.only(bottom: 5.0),
                                                      child: Text(
                                                        display_list[index].date,
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  color: Colors.grey.shade800,
                                                  height: 3,
                                                  thickness: 1,
                                                )
                                              ],
                                            );
                                            // ,
                                            // );
                                          }),
                                    ),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                //2nd layer
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //Custom AppBar
                      AppBar(
                        titleSpacing: 25.0,
                        toolbarHeight: 80,
                        backgroundColor: Color(0xff1E1E1E),
                        automaticallyImplyLeading: false,
                        title: Text(
                          MainPage.menuName,
                          style: TextStyle(
                              fontFamily: 'Graphik',
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                              color: Colors.white),
                        ),

                        // Side Menu Widget
                        actions: [
                          Builder(
                            builder: (context) => IconButton(
                              padding: EdgeInsets.only(left: 0, right: 40),
                              icon: Icon(
                                Icons.menu,
                                size: 34,
                                color: Colors.white,
                              ),
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer(),
                            ),
                          ),
                        ],
                        elevation: 0,
                        centerTitle: false,
                      ),

                      //Search Bar
                      Visibility(
                        visible: _isSearchBarActive,
                        child: Container(
                          color: Color(0xff1E1E1E),
                          height: 60,
                          width: width,
                          padding: EdgeInsets.only(
                            bottom: 20,
                            left: 16,
                            right: 16,
                          ),
                          child: TextField(
                            cursorColor: Colors.grey[300],
                            textAlignVertical: TextAlignVertical.center,
                            style:
                                TextStyle(fontSize: 16, color: Colors.white70),
                            onChanged: (newSearch) {
                              _search = newSearch;
                              display_list = main_projects_list
                                  .where((main_projects_list) =>
                                      main_projects_list.project_title
                                          .contains(_search))
                                  .toList();
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              filled: true,
                              fillColor: Color.fromARGB(255, 20, 55, 50),
                              prefixIcon: Icon(Icons.search_rounded,
                                  color: Colors.grey[500]),
                              hintText: "Search",
                              hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  height: 2.3,
                                  fontSize: 20),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide:
                                    new BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide:
                                    new BorderSide(color: Colors.transparent),
                              ),
                            ),
                          ),
                        ), // search bar
                      ),

                      //Transparent Container, hide itself and close template menu when tapped
                      //visible when template menu is shown
                      Expanded(
                        child: GestureDetector(
                          child: Visibility(
                            visible: _isInvisibleTriggerActive,
                            child: Container(
                                color:
                                    Color(0x77000000) //semi-Transparent black
                                //color: Color(0x00000000),
                                ),
                          ),
                          onTap: () {
                            setState(() {
                              _isMenuActive = !_isMenuActive;
                              _isSearchBarActive = !_isSearchBarActive;
                              _isInvisibleTriggerActive =
                                  !_isInvisibleTriggerActive;
                              _controller.reverse();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //Add button
          floatingActionButton: Visibility(
            visible: !showFab,
            child: FloatingActionButton(
              onPressed: () {
                _controller1.add(TextEditingController());
                _rename.add(false);

                MainPage.isNewProject = true;
                createNewProject();
              },
              backgroundColor: Colors.transparent,
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/icons/Add_Pink.png'),
                backgroundColor: Colors.transparent,
                radius: 50,
                onBackgroundImageError: (e, s) {
                  debugPrint('image issue, $e,$s');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }



  //function
  void createNewProject() {
    setState(() {
      main_projects_list = List.from(display_list);
      List<int> x = [];
      for (int i = 0; i < main_projects_list.length; i++) {
        String num = main_projects_list[i]
            .controller
            .text
            .replaceAll(RegExp(r'[^0-9,.]+'), '');
        if (num != "") {
          x.add(int.parse(num));
        }
      }
      String id = nanoid();
      main_projects_list.add(ProjectModel(id,
          "Project ${x.isEmpty ? main_projects_list.length + 1 : x.reduce((value, element) => value > element ? value : element) + 1}",
          "8 AUG 2021"));
    });
    display_list = List.from(main_projects_list);
  }

  void share(int index) {
    Share.share(display_list[index].project_title);
  }

  void rename(int index) {
    display_list[index].focusNode.requestFocus();
  }

  void delete(int index) {
    setState(() {
      MainPage.trashList.add(display_list[index]);
      display_list.removeAt(index);
      main_projects_list.removeAt(index);
    });
  }

/*
  Future<void> Export() async{
       PdfDocument doc = PdfDocument();
       doc.pages.add();

       List<int> bytes = doc.save();
       doc.dispose();

       savedAndLaunchFile(bytes, 'preview.pdf');
    }
    */

}

//remove scroll glow effect
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

void clearTempItems() {
  //MainPage.NewCS = []; //[1]
  /*MyHomePage.NewSL = []; //[2]
  MyHomePage.NewBS = []; //[3]
  MyHomePage.NewOL = []; //[4]
  MyHomePage.NewSB = []; //[5]
  MyHomePage.NewCB = []; //[6]
  MyHomePage.NewScene = [];*/ //[7]
}

import 'dart:async';

import 'package:beat_sheet/Trash.dart';
import 'package:beat_sheet/preferences_service.dart';
import 'package:beat_sheet/Classes/project_model.dart';
import 'package:beat_sheet/second_page.dart';
import 'package:beat_sheet/widgets/SideMenu.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/animation.dart';
import 'package:intl/intl.dart';
import 'package:ios_platform_images/ios_platform_images.dart';

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
  const MainPage({Key? key});

  //index of new project (widget)
  static int projectPos = 0;
  static bool isNewProject = false;

  //Budget Sheet menu as default when start app
  static String menuName = "Beat Sheet";

  //Project Lists
  static List<List<dynamic>> projectList = [];

  //trash Lists (test)
  static List<List<dynamic>> trashList = [];
  static List<ProjectModel> main_projects_list = [];

  //Sections
  static List<List<dynamic>> NewCS = []; //new call sheet list

  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

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

  //-Invisible Container when temlate menu is visible-
  bool _isInvisibleTriggerActive = false;
  bool order = false;

  //search data
  late String _search = '';
  var matchingItems;
  TextEditingController _searchproject = new TextEditingController();

  //Animation of dropdown template menu
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  late Timer timer;

  String _title = '';
  FocusNode _titleFocusNode = FocusNode();
  late AnimationController controller;

  final listenable = ValueNotifier<int>(0);

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

  static List<ProjectModel> main_projects_list = [];
  List<ProjectModel> display_list = List.from(main_projects_list);

  // function to filter list from search and lisview
  void updateList(String value) {
    //function to filter list here..will come back later

    //Work on the search function
    setState(() {
      display_list = main_projects_list.where((element) {
        return element.controller.text
            .toLowerCase()
            .contains(value.toLowerCase());
      }).toList();
    });
  }

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
          key: MainPage.scaffoldKey,
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
                                    child: ReorderableListView.builder(
                                        onReorder: (oldIndex, newIndex) {
                                          setState(() {
                                            if (newIndex > oldIndex) newIndex--;
                                            final item =
                                                display_list.removeAt(oldIndex);
                                            display_list.insert(newIndex, item);
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
                                          return Dismissible(
                                            onDismissed: (direction) {
                                              setState(() {
                                                display_list.removeAt(index);
                                                main_projects_list
                                                    .removeAt(index);
                                              });
                                            },
                                            direction:
                                                DismissDirection.endToStart,
                                            background: Container(
                                              color: Colors.red,
                                              alignment: Alignment.centerRight,
                                              padding:
                                                  EdgeInsets.only(right: 25),
                                              child: ImageIcon(
                                                AssetImage(
                                                    'assets/icons/Bin_White.png'),
                                                size: 30,
                                                color: Colors.white,
                                              ),
                                            ),
                                            key: ValueKey(display_list[index]),
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                  key: ValueKey(
                                                      display_list[index]),
                                                  // key for the ReorderableListView
                                                  onTap: () {
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

                                                  // title: (main_projects_list[index].controller.text.isNotEmpty)?
                                                  //   Text(main_projects_list[index].controller.text,
                                                  //     style: TextStyle(
                                                  //         color: Colors.white,
                                                  //         fontSize: 20,
                                                  //         fontWeight: FontWeight
                                                  //             .bold)):
                                                  //   Text('Project ${index + 1}',
                                                  //     style: TextStyle(
                                                  //         color: Colors.white,
                                                  //         fontSize: 20,
                                                  //         fontWeight: FontWeight
                                                  //             .bold),)
                                                  // ,
                                                  title: TextField(
                                                    controller:
                                                        display_list[index]
                                                            .controller,
                                                    onChanged: (text) {
                                                    setState(() {
                                                      main_projects_list[index]
                                                          .project_title = text;
                                                      display_list[index]
                                                          .project_title = text;
                                                    });
                                                  },
                                                    autofocus: false,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight
                                                            .bold),
                                                    decoration: InputDecoration(
                                                      hintText: display_list[index]
                                                          .project_title,
                                                      hintStyle: TextStyle(
                                                          color: Colors.white),
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    display_list[index].date,
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  trailing: Wrap(
                                                    spacing: 12,
                                                    // space between two icons
                                                    children: <Widget>[
                                                      IconButton(
                                                        onPressed: () {
                                                          //more menu bottom sheet
                                                          showModalBottomSheet<
                                                              dynamic>(
                                                            isScrollControlled:
                                                                true,
                                                            backgroundColor:
                                                                Color(
                                                                    0xff303030),
                                                            context: context,
                                                            builder: (context) {
                                                              return Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  //Divider
                                                                  Divider(
                                                                    height: 30,
                                                                    thickness:
                                                                        1,
                                                                    indent:
                                                                        width,
                                                                    endIndent:
                                                                        width,
                                                                    color: Color(
                                                                        0xff656565),
                                                                  ),

                                                                  //show project name
                                                                  Container(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            30,
                                                                        right:
                                                                            40,
                                                                        top: 10,
                                                                        bottom:
                                                                            10),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        //Icon decoration
                                                                        ImageIcon(
                                                                          AssetImage(
                                                                              'assets/icons/pink.png'),
                                                                          size:
                                                                              35,
                                                                          color:
                                                                              Colors.white,
                                                                        ),

                                                                        //Project Name
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(left: 16),
                                                                          child:
                                                                              Text(
                                                                            display_list[index].project_title,
                                                                            style: TextStyle(
                                                                                fontFamily: 'Graphik',
                                                                                fontSize: 17.5,
                                                                                fontWeight: FontWeight.w900,
                                                                                color: Color(0xffffffff)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  //Divider
                                                                  Divider(
                                                                    height: 30,
                                                                    thickness:
                                                                        2,
                                                                    indent: 10,
                                                                    endIndent:
                                                                        10,
                                                                    color: Color(
                                                                        0xff656565),
                                                                  ),

                                                                  //items
                                                                  _createMoreMenuItem(
                                                                      icon: Icons
                                                                          .ios_share,
                                                                      text:
                                                                          'Share',
                                                                      onTap:
                                                                          () {
                                                                        //share
                                                                        Navigator.pop(
                                                                            context);
                                                                      }),

                                                                  //rename
                                                                  _createMoreMenuItem(
                                                                      icon: Icons
                                                                          .edit,
                                                                      text:
                                                                          'Rename',
                                                                      onTap:
                                                                          () {

                                                                        _rename[index] =
                                                                            true;

                                                                        //rename
                                                                        Navigator.pop(
                                                                            context);
                                                                        setState(() {
                                                                        });

                                                                        // WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                        //   FocusScope.of(context)
                                                                        //       .requestFocus(display_list[index]._titleFocusNode);
                                                                        // });
                                                                      }),

                                                                  //Delete, remove from project list and add into trash list
                                                                  _createMoreMenuItem(
                                                                      icon: Icons
                                                                          .delete,
                                                                      text:
                                                                          'Delete',
                                                                      onTap:
                                                                          () {
                                                                        MainPage
                                                                            .trashList
                                                                            .add(MainPage.projectList[index]);
                                                                        MainPage
                                                                            .projectList
                                                                            .removeAt(index);
                                                                        display_list
                                                                            .removeAt(index);
                                                                        Navigator.pop(
                                                                            context);
                                                                        setState(
                                                                            () {
                                                                          main_projects_list
                                                                              .removeAt(index);
                                                                        });
                                                                      }),

                                                                  //gap
                                                                  SizedBox(
                                                                      height:
                                                                          20),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .more_horiz_sharp,
                                                          size: 26,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  leading: Image(
                                                    image: AssetImage(
                                                        'assets/icons/Sheet_Grey.png'),
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Divider(
                                                  color: Color(0xff656565),
                                                  thickness: 1.5,
                                                  indent: 15,
                                                  endIndent: 15,
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
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
                        /*
                        actions: [
                          Builder(
                            builder: (context) => IconButton(
                              padding: EdgeInsets.only(left: 0, right: 10),
                              icon: Icon(
                                Icons.menu,
                                size: 34,
                                color: Color.fromARGB(255, 248, 144, 144),
                              ),
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer(),
                            ),
                          ),
                        ],*/
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
                switch (MainPage.menuName) {
                  case "Beat Sheet":
                    //Navigator.of(context).push(toBS_main(MainPage.projectPos)).then((value) => setState(() {}));
                    break;
                  case "Shot List":
                    break;
                  case "Budget Sheet":
                    break;
                  case "One Liner":
                    break;
                  case "Storyboard":
                    break;
                  case "Concept Board":
                    break;
                  default:
                    print("N/A");
                    break;
                }
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

  //widget
  //Tap-able Item template, navigate-able
  Widget _createMoreMenuItem(
      {IconData? icon, required String text, GestureTapCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        minVerticalPadding: 10,
        title: Row(
          children: <Widget>[
            //Icon decoration
            Icon(
              icon,
              size: 40,
              color: Color(0xff999999),
            ),
            SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                  fontFamily: 'CenturyGothic',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xffffffff)),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  //function
  void createNewProject() {
    setState(() {
      main_projects_list = List.from(display_list);
      List<int> x = [];
      for (int i = 0; i < main_projects_list.length; i++) {
        x.add(int.parse(main_projects_list[i]
            .controller
            .text
            .replaceAll(RegExp(r'[^0-9,.]+'), '')));
      }
      print(x);
      main_projects_list.add(ProjectModel(
          "Project ${x.isEmpty ? main_projects_list.length + 1 : x.reduce((value, element) => value > element ? value : element) + 1}",
          "8 AUG 2021",
          "icons.more",
          "('assets/Grey_docs2.jpeg')"));
    });
    display_list = List.from(main_projects_list);
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

void rename() {

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
  MainPage.NewCS = []; //[1]
  /*MyHomePage.NewSL = []; //[2]
  MyHomePage.NewBS = []; //[3]
  MyHomePage.NewOL = []; //[4]
  MyHomePage.NewSB = []; //[5]
  MyHomePage.NewCB = []; //[6]
  MyHomePage.NewScene = [];*/ //[7]
}

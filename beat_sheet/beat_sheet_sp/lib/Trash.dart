import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/animation.dart';

import 'MainPage.dart';
//One Shot

//Home Page
class TrashPage extends StatefulWidget {
  const TrashPage({Key? key});
  static ValueNotifier<int> rec_project = ValueNotifier(0);
  @override
  _TrashPageState createState() => _TrashPageState();
}

//Home Page (Private)
class _TrashPageState extends State<TrashPage> with TickerProviderStateMixin {
  //template menu items
  final List<String> menuItems = <String>[
    'Beat Sheet',
    'One-Liner',
    'Budget Sheet',
    'Storyboard',
    'Shot List',
    'Concept Board'
  ];
//static ValueNotifier<int> rec_project = ValueNotifier(0);
  //bool
  bool _isCheckBoxActive = false;
  bool _isEditActive = false;
  bool _isSelectAll = false;
  bool _a = true;
  bool _b = true;

  //declaration for Animation of dropdown template menu
  late final AnimationController _controller;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  //initState f()
  @override
  void initState() {
    super.initState();
    //assignment for Animation of dropdown template menu
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    setState(() {});
  }

  //dispose f()
  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  //Home Page Layout
  @override
  Widget build(BuildContext context) {
    // sets status bar and navi bar colors
    final SystemUiOverlayStyle themeSet = SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Color(0xff1E1E1E),
        statusBarColor: Color(0xff1E1E1E),
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light);

    //check screen safe area
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    //final ValueNotifier<int> rec_project = ValueNotifier(0);

    return new AnnotatedRegion(
      value: themeSet,
      child: SafeArea(
        child: new GestureDetector(
          //hide keyboard
          onTap: () {
            FocusManager.instance.primaryFocus!.unfocus();
          },
          //Page Layout
          child: Scaffold(
            backgroundColor: Colors.black,

            //body layout
            body: Container(
              width: width,
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Custom AppBar
                  AppBar(
                    //backgroundColor: Colors.transparent,
                    elevation: 0,
                    backgroundColor: Colors.black,
                    toolbarHeight: 60,
                    centerTitle: false,
                    //-Left icon - Back Button-
                    leading: Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          padding: EdgeInsets.only(left: 14),
                          icon: const Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 27.5,
                            color: Color(0xffffffff),
                          ),
                          onPressed: () {
                            //reset();
                            clearTempItems();
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                    //-Center Title- New Project-
                    title: Text(
                      'Deleted Files',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 255, 154, 138)),
                    ),
                  ),

                  //Menu Title

                  //Search Bar
                  Container(
                    color: Colors.transparent,
                    height: 55,
                    width: width,
                    padding: EdgeInsets.only(
                        top: 10, left: 16, right: 16, bottom: 10),
                    child: TextField(
                      cursorColor: Colors.grey[300],
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        filled: true,
                        fillColor: Color.fromARGB(255, 20, 55, 50),
                        prefixIcon:
                            Icon(Icons.search_rounded, color: Colors.grey[500]),
                        suffixIcon: Padding(
                            padding: EdgeInsets.all(10),
                            child: ImageIcon(
                                AssetImage('assets/icons/Mic Grey.png'),
                                color: Colors.grey[500])),
                        hintText: "Search",
                        hintStyle: TextStyle(
                            color: Colors.grey[500], height: 1, fontSize: 16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: new BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: new BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    width: width,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 15, right: 20, left: 35),
                          child: Text(
                            'Total Files: ${MainPage.trashList.length}',
                            style: TextStyle(
                              fontFamily: 'Graphik',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Color(0xff999999),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 15, bottom: 12.5, right: 0, left: 125),
                          child: GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              child: Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isSelectAll = true;
                                      _isCheckBoxActive = !_isCheckBoxActive;
                                      _a = !_a;
                                      _b = !_b;
                                      if (_isCheckBoxActive == false) {
                                        for (var i = 0;
                                            i < MainPage.trashList.length;
                                            i++) {
                                          MainPage.trashList[i][0].isSelected =
                                              true;
                                        }
                                        _isEditActive = false;
                                      } else {
                                        _isEditActive = true;
                                      }
                                    });
                                  },
                                  child: Text(
                                    _isCheckBoxActive == true
                                        ? 'Select All'
                                        : 'Edit',
                                    style: TextStyle(
                                        fontFamily: 'Graphik',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Color.fromARGB(255, 255, 154, 138)),
                                  ),
                                ),
                              ),
                            ),
                            /*onTap: () {
                              setState(() {
                                _isSelectAll = false;
                                _isCheckBoxActive = !_isCheckBoxActive;
                                _a = !_a;
                                _b = !_b;
                                if (_isCheckBoxActive == false) {
                                  for (var i = 0;
                                      i < MainPage.trashList.length;
                                      i++) {
                                    MainPage.trashList[i][0].isSelected = false;
                                  }
                                  _isEditActive = false;
                                } else {
                                  _isEditActive = true;
                                }
                              });
                            },*/
                          ),
                        ),
                      ],
                    ),
                  ),
                  //here for divider
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    indent: 30,
                    endIndent: 30,
                    color: Color(0xff656565),
                  ),

                  //project list view
                  Expanded(
                    child: Container(
                      width: width,
                      padding: EdgeInsets.only(
                          top: 20, bottom: 0, left: 0, right: 0),
                      child: ListView.separated(
                        physics: AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: MainPage.trashList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 30, right: 40, top: 15.5, bottom: 15.5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //Checkbox
                                  Visibility(
                                    visible: _isCheckBoxActive,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        MainPage.trashList[index][0]
                                                    .isSelected ==
                                                true
                                            ? Icons.check_circle
                                            : Icons
                                                .radio_button_unchecked_rounded,
                                        size: 20,
                                        color: Color(0xff999999),
                                      ),
                                    ),
                                  ),

                                  //Icon decoration
                                  ImageIcon(
                                    AssetImage('assets/icons/pink.png'),
                                    size: 45,
                                    color: Color(0xff999999),
                                  ),

                                  //Project Name & Date
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //Project Name
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 16),
                                              child: Text(
                                                "${MainPage.trashList[index][0].projectName}",
                                                style: TextStyle(
                                                    fontFamily: 'CenturyGothic',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xffffffff)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        //Project Date
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 16,
                                              ),
                                              child: Text(
                                                "${MainPage.trashList[index][0].projectCreatedDate}",
                                                style: TextStyle(
                                                    fontFamily: 'CenturyGothic',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff999999)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  //more menu
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 0,
                                        bottom: 0,
                                        right: 10,
                                        left: 120),
                                    child: Visibility(
                                      visible: _b,
                                      child: IconButton(
                                        icon: Icon(Icons.more_horiz_sharp,
                                            size: 30,
                                            color: Color.fromARGB(
                                                255, 255, 154, 138)),
                                        onPressed: () {
                                          showModalBottomSheet(
                                            backgroundColor: Color(0xff303030),
                                            context: context,
                                            builder: (context) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  //Divider
                                                  Divider(
                                                    height: 30,
                                                    thickness: 2,
                                                    indent: width / 2 - 15,
                                                    endIndent: width / 2 - 15,
                                                    color: Color(0xff656565),
                                                  ),

                                                  //show project name
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 30,
                                                        right: 40,
                                                        top: 10,
                                                        bottom: 10),
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
                                                          size: 35,
                                                          color:
                                                              Color(0xff999999),
                                                        ),
                                                        //Project Name
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 16),
                                                          child: Text(
                                                            "${MainPage.trashList[index][0].projectName}",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'CenturyGothic',
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                color: Color(
                                                                    0xffffffff)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  //Divider
                                                  Divider(
                                                    height: 30,
                                                    thickness: 2,
                                                    indent: 30,
                                                    endIndent: 30,
                                                    color: Color(0xff656565),
                                                  ),

                                                  //items
                                                  //Recover
                                                  _createMoreMenuItem(
                                                      icon: Icons
                                                          .arrow_circle_up_rounded,
                                                      text: 'Recover',
                                                      onTap: () {
                                                        setState(() {
                                                          MainPage.projectList
                                                              .add(MainPage
                                                                      .trashList[
                                                                  index]);
                                                          TrashPage.rec_project
                                                              .value += 1;
                                                          MainPage.trashList
                                                              .removeAt(index);
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      }),

                                                  //p. delete
                                                  _createMoreMenuItem(
                                                      icon: Icons.delete_sharp,
                                                      text:
                                                          'Permanently deleted',
                                                      onTap: () {
                                                        setState(() {
                                                          MainPage.trashList
                                                              .removeAt(index);
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      }),

                                                  //gap
                                                  SizedBox(height: 40),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onLongPress: () {
                              setState(() {
                                _isCheckBoxActive = true;
                                _isEditActive = true;
                                _a = false;
                                _b = false;
                                MainPage.trashList[index][0].isSelected =
                                    !MainPage.trashList[index][0].isSelected;
                                checkSelected();
                              });
                            },
                            onTap: () {
                              setState(() {
                                if (_isCheckBoxActive == true) {
                                  MainPage.trashList[index][0].isSelected =
                                      !MainPage.trashList[index][0].isSelected;
                                  checkSelected();
                                }
                              });
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          height: 1,
                          thickness: 0.5,
                          indent: 30,
                          endIndent: 30,
                          color: Color(0xff656565),
                        ),
                      ),
                    ),
                  ),

                  //bottom bar
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 100,
                    child: Visibility(
                      visible: _isEditActive,
                      child: Container(
                        height: 100,
                        padding: EdgeInsets.only(left: 300),
                        child: FloatingActionButton(
                          backgroundColor: Color.fromARGB(255, 255, 154, 138),
                          child: ImageIcon(
                            AssetImage('assets/icons/Bin Grey.png'),
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              deleteSelected();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //check selected
  void checkSelected() {
    for (var i = 0; i < MainPage.trashList.length; i++) {
      if (MainPage.trashList[i][0].isSelected == false) {
        _isSelectAll = false;
        break;
      } else {
        _isSelectAll = true;
      }
    }
  }

  //delete selected
  void deleteSelected() {
    for (var i = 0; i < MainPage.trashList.length; i++) {
      if (MainPage.trashList[i][0].isSelected == true) {
        MainPage.trashList.removeAt(i);
        i--;
      }
    }
  }

  //Widget
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
}

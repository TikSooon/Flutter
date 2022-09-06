//flutter
import 'dart:async';

import 'package:beat_sheet/MainPage.dart';
import 'package:beat_sheet/Trash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beat_sheet/Routes.dart';
//


class sideMenu extends StatefulWidget {
  const sideMenu({Key? key}) : super(key: key);

  @override
  _sideMenuState createState() => _sideMenuState();
}

class _sideMenuState extends State<sideMenu> {

  //bool
  bool darkModeSwitch = true;
  bool faceIdSwitch = false;

  //initState f()
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(0xff191919),
      ),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            //Header
            Container(
              height: 90,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                    stops: [
                      0.7,
                      0.3,
                    ],
                    colors: [
                      Color(0xff191919),
                     Color(0xff191919),
                    ],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    //Logo Name
                    Positioned(
                      left: 10,
                      child: Text('Setting',
                        style: TextStyle(fontFamily: "Calibri", fontWeight: FontWeight.w500, fontSize: 25, color: Color(
                            0xffc96d6d)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            //Items & Divider
            _DrawerDivider(),
            SizedBox(height: 10),
            _createDrawerTapItem(icon: CupertinoIcons.trash_fill, text: 'Recently Deleted', onTap: () {
              Navigator.pop(context);
              Navigator.push(context, toTrashPage());
            }),
          ],
        ),
      ),
    );
  }

  //Drawer divider
  Widget _DrawerDivider() {
    return Divider(
      height: 0,
      thickness: 2,
      indent: 0,
      endIndent: 0,
      color: Color(0xff656565),
    );
  }

//Tap-able Item template, navigate-able
  Widget _createDrawerTapItem ({IconData? icon, required String text, GestureTapCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: ListTile(
        title: Row(
          children: <Widget>[
            Icon(icon, color: Color(0xff999999),),
            SizedBox(width: 10),
            Text(text, style: TextStyle(fontFamily: 'Inter', fontSize: 18, color: Color(0xff999999),),),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

//drawer item with switch
  Widget _createDrawerSwitchItem ({required bool bool, required String text}) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: ListTile(
        title: Row(
          children: <Widget>[
            Text(text, style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: Color(0xff999999),),),
            Padding(
              padding: const EdgeInsets.only(right: 32),
              child: Transform.scale(
                scale: 0.6,
                child: CupertinoSwitch(
                    activeColor: Colors.orangeAccent,
                    value: bool,
                    onChanged: (value) {
                      setState(() {
                        bool = value;
                      });
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

